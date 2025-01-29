package com.nlb.service;


import com.mongodb.client.result.UpdateResult;
import com.nlb.dto.request.ExamResultReqDTO;
import com.nlb.dto.response.ExamDataResDTO;
import com.nlb.dto.response.ExamJoinResDTO;
import com.nlb.dto.response.ExamResultCardDTO;
import com.nlb.exception.BadRequestException;
import com.nlb.exception.CustomAccessDeniedException;
import com.nlb.exception.ErrorCode;
import com.nlb.exception.NotFoundException;
import com.nlb.mapper.ExamMapper;
import com.nlb.mapper.ExamResultMapper;
import com.nlb.vo.AnswerVO;
import com.nlb.vo.ExamResultMongoVO;
import com.nlb.vo.ExamResultVO;
import com.nlb.vo.ExamVO;
import com.nlb.vo.QuestionVO;
import java.net.URI;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ExamResultServiceImpl implements ExamResultService {

  @Autowired
  private ExamResultMapper examResultMapper;
  @Autowired
  private MongoTemplate mongoTemplate;
  @Autowired
  private ExamMapper examMapper;
  @Autowired
  private ExamService examService;


  @Override
  public List<ExamResultVO> getExamResultList(int examId, String sortBy, String order,
      Boolean isReviewed) {
    return examResultMapper.selectExamResultList(examId, sortBy, order, isReviewed);
  }

  @Override
  public int setExamResultStatus(int resultId, Boolean isReviewed) {
    return examResultMapper.updateExamResultIsReviewed(resultId, isReviewed);
  }

  @Override
  public List<ExamResultVO> getExamResultListOfUser(int userId, String sortBy, String order,
      Boolean isReviewed) {
    return examResultMapper.selectExamResultListByUserId(userId, sortBy, order, isReviewed);
  }

  @Override
  public ExamResultCardDTO getExamResultAndExam(int resultId) {
    return examResultMapper.selectExamResultAndExamByResultId(resultId);
  }


  @Override
  @Transactional
  public int saveExamAnswers(int examineeId, ExamResultReqDTO examResultReqDTO) {

    int resultId = examResultReqDTO.getExamResultVO().getResultId();
    int dtoExamineeId = examResultReqDTO.getExamResultVO().getExamineeId();
    // 세션 examineeId와 DTO examineeId가 일치하는지 확인
    if (examineeId != dtoExamineeId) {
      throw new CustomAccessDeniedException("잘못된 사용자 입니다");
    }
    if (examResultReqDTO.getExamResultVO().getSubmittedAt() != null) {
      throw new CustomAccessDeniedException("이미 시험이 제출되었습니다");
    }

    // 기존 몽고 데이터 가져와서 다른것 적용 (전체 덮어쓰기랑 비교해 IO 아껴보려는 시도...)
    Query query = Query.query(
        Criteria.where("resultId").is(resultId).and("examineeId").is(examineeId));
    ExamResultMongoVO existingExamResult = mongoTemplate.findOne(query, ExamResultMongoVO.class,
        "examResults");

    List<AnswerVO> existingAnswers = existingExamResult.getAnswers();
    List<AnswerVO> newAnswers = examResultReqDTO.getExamResultMongoVO().getAnswers();
    // 기존 데이터 매핑
    Map<Integer, AnswerVO> answerMap = existingAnswers.stream()
        .collect(Collectors.toMap(AnswerVO::getQuestionId, a -> a));
    // 답변 데이터 적용
    for (AnswerVO newAnswer : newAnswers) {
      answerMap.put(newAnswer.getQuestionId(), newAnswer);
    }

    // 몽고 업데이트
    Update update = new Update().set("answers", new ArrayList<>(answerMap.values()));
    UpdateResult mongoResult = mongoTemplate.updateFirst(query, update, ExamResultMongoVO.class,
        "examResults");

    return (int) mongoResult.getMatchedCount();
  }

  @Override
  @Transactional
  public List<AnswerVO> submitExam(int examineeId, ExamResultReqDTO examResultReqDTO) {
    int resultId = examResultReqDTO.getExamResultVO().getResultId();
    int dtoExamineeId = examResultReqDTO.getExamResultVO().getExamineeId();
    // 세션 examineeId와 DTO examineeId가 일치하는지 확인
    if (examineeId != dtoExamineeId) {
      throw new CustomAccessDeniedException("잘못된 사용자 입니다");
    }
    if (examResultReqDTO.getExamResultVO().getSubmittedAt() != null) {
      throw new CustomAccessDeniedException("이미 시험이 제출되었습니다");
    }
    // MongoDB 업데이트
    Query query = Query.query(
        Criteria.where("resultId").is(resultId).and("examineeId").is(examineeId));
    ExamResultMongoVO existingExamResult = mongoTemplate.findOne(query, ExamResultMongoVO.class,
        "examResults");

    List<AnswerVO> existingAnswers = existingExamResult.getAnswers();
    List<AnswerVO> newAnswers = examResultReqDTO.getExamResultMongoVO().getAnswers();
    // 기존 데이터 맵핑
    Map<Integer, AnswerVO> answerMap = existingAnswers.stream()
        .collect(Collectors.toMap(AnswerVO::getQuestionId, a -> a));
    // 답변 데이터 적용
    for (AnswerVO newAnswer : newAnswers) {
      answerMap.put(newAnswer.getQuestionId(), newAnswer);
    }

    // MongoDB 업데이트  (실제 제출에는 제출 시간 표기)
    List<AnswerVO> updatedAnswers = new ArrayList<>(answerMap.values());
    Update update = new Update()
        .set("answers", updatedAnswers)
        .set("submittedAt", LocalDateTime.now());

    mongoTemplate.updateFirst(query, update, ExamResultMongoVO.class,
        "examResults");

    // RDB 업데이트 (시험 제출 상태)
    ExamResultVO examResultVO = examResultReqDTO.getExamResultVO();
    examResultVO.setResultId(resultId);
    examResultVO.setSubmittedAt(LocalDateTime.now());
    examResultVO.setReviewed(false);
    examResultMapper.updateExamResult(examResultVO);

    return updatedAnswers;
  }

  @Override
  @Transactional
  public ExamJoinResDTO joinExam(String examCode, int examineeId, String entreeCode) {
    ExamVO examVO = examResultMapper.selectExamByCode(examCode);
    System.out.println("examvo 조회 테스트 " + examVO);
    int examId = examVO.getExamId(); // 조회한 examId 사용
    System.out.println("examid 조회 세트스 " + examId);

    if (examVO == null) {
      // 시험이 존재하지 않음
      throw new NotFoundException(ErrorCode.EXAM_NOT_FOUND);
    }
    if (!examVO.getActivationStatus().equals("on_going")) {
      // 시험이 시작되지 않았거나 종료됨
      throw new BadRequestException(ErrorCode.EXAM_NOT_STARTED);
    }
    if (!examVO.getEntreeCode().equals(entreeCode)) {
      // 잘못된 비밀번호
      throw new CustomAccessDeniedException("시험 입장 코드가 올바르지 않습니다.");
    }

    // RDB에 새로운 resultId 생성 및 저장
    ExamResultVO examResultVO = new ExamResultVO();
    examResultVO.setExamId(examId);
    examResultVO.setExamineeId(examineeId);
    examResultVO.setScore(0);
    examResultVO.setReviewed(false);
    examResultMapper.insertExamResult(examResultVO);
    int generatedResultId = examResultVO.getResultId();

    // MongoDB에도 저장
    Query query = Query.query(Criteria.where("resultId").is(generatedResultId));
    Update update = new Update()
        .set("resultId", generatedResultId)
        .set("examId", examId)
        .set("examineeId", examineeId)
        .set("answers", new ArrayList<>()); // 초기 답변은 빈 리스트

    mongoTemplate.upsert(query, update, ExamResultMongoVO.class, "examResults");
    String DataUrl = URI.create(String.format("/api/exams/%d/exam-data", examId)).toString();

    return new ExamJoinResDTO(
        examId,
        generatedResultId,
        examCode,
        examineeId,
        DataUrl);
  }


  @Override
  public Map<String, Object> getExamResultData(int examId, int examineeId) {
    // MongoDB에서 해당 시험의 응시 데이터 가져오기
    Query query = Query.query(Criteria.where("examId").is(examId)
        .and("examineeId").is(examineeId));
    ExamResultMongoVO examResultMongo = mongoTemplate.findOne(query, ExamResultMongoVO.class,
        "examResults");
    int resultId = examResultMongo.getResultId();

    // 기존 응답 데이터 가져오기 (혹시 몰라 디폴트 빈 답변들 생성)
    List<AnswerVO> answers =
        examResultMongo.getAnswers() != null ? examResultMongo.getAnswers() : new ArrayList<>();

    // JSON 응답 구조 구성
    Map<String, Object> resultData = new HashMap<>();
    resultData.put("examId", examId);
    resultData.put("resultId", resultId); // (나중에 제출 시 필요)
    resultData.put("examineeId", examineeId);
    resultData.put("answers", answers);
    return resultData;
  }


  @Override
  public ExamDataResDTO getExamData(int examId, int examineeId) {
    // 시험 문제 가져오기
    List<QuestionVO> questions = examService.getExamQuestions(examId);

    // 응시자가 제출한 데이터 가져오기
    Map<String, Object> examResultData = getExamResultData(examId, examineeId);

    int resultId = (int) examResultData.get("resultId");
    List<AnswerVO> answers = (List<AnswerVO>) examResultData.getOrDefault("answers",
        new ArrayList<>());

    // 응답 DTO 구성
    return new ExamDataResDTO(
        examId,
        resultId,
        examineeId,
        questions,
        answers
    );
  }

}
