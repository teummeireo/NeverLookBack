package com.nlb.service;


import com.mongodb.client.result.UpdateResult;
import com.nlb.dto.request.ExamResultReqDTO;
import com.nlb.dto.response.ExamDataResDTO;
import com.nlb.dto.response.ExamJoinResDTO;
import com.nlb.dto.response.ExamResultCardDTO;
import com.nlb.dto.response.ExamineeInfoResDTO;
import com.nlb.exception.BadRequestException;
import com.nlb.exception.CustomAccessDeniedException;
import com.nlb.exception.ErrorCode;
import com.nlb.exception.NotFoundException;
import com.nlb.mapper.ExamMapper;
import com.nlb.mapper.ExamResultMapper;
import com.nlb.vo.AnswerVO;
import com.nlb.vo.ExamMongoVO;
import com.nlb.vo.ExamResultMongoVO;
import com.nlb.vo.ExamResultVO;
import com.nlb.vo.ExamVO;
import com.nlb.vo.QuestionVO;
import com.nlb.vo.ResultDetailVO;
import java.net.URI;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
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
  public List<ExamResultVO> getAllExamResults() {
    return examResultMapper.selectAllExamResults();
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
    // 시험 제출 여부를 제출시간 갱신 여부로 체크
    if (examResultMapper.selectExamResultByExamIdandUser(
            examResultReqDTO.getExamResultVO().getExamId(), examineeId).getSubmittedAt()
        .isAfter(LocalDateTime.of(1900, 1, 1, 0, 0, 0))) {
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

    return newAnswers.size();
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
    // 시험 제출 여부를 제출시간 갱신 여부로 체크
    if (examResultMapper.selectExamResultByExamIdandUser(
            examResultReqDTO.getExamResultVO().getExamId(), examineeId).getSubmittedAt()
        .isAfter(LocalDateTime.of(1900, 1, 1, 0, 0, 0))) {
      throw new CustomAccessDeniedException("이미 시험이 제출되었습니다");
    }
    // 몽고DB에서 기존 제출 데이터 조회
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
    List<AnswerVO> updatedAnswers = new ArrayList<>(answerMap.values());

    // RDB 업데이트 (시험 제출 상태)
    ExamResultVO examResultVO = examResultReqDTO.getExamResultVO();
    examResultVO.setResultId(resultId);
    examResultVO.setSubmittedAt(LocalDateTime.now());
    examResultVO.setReviewed(false);
    examResultMapper.updateExamResult(examResultVO);

    // 📌 시험 채점 (내부에서 총점 + resultDetail RDB 업데이트 됨)
    updatedAnswers = gradingExam(updatedAnswers, examResultVO, resultId,
        examResultReqDTO.getExamResultVO().getExamId());

    // MongoDB 업데이트  (실제 제출에는 제출 시간 표기)
    Update update = new Update()
        .set("answers", updatedAnswers)
        .set("submittedAt", LocalDateTime.now());

    mongoTemplate.updateFirst(query, update, ExamResultMongoVO.class,
        "examResults");

    return updatedAnswers;
  }

  @Override
  @Transactional
  public ExamJoinResDTO joinExam(int examId, String examCode, int examineeId, String entreeCode) {
    ExamVO examVO = examMapper.selectExamById(examId);

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

    // 재접속일 경우인 ResultId가 존재하는지 확인
    ExamResultVO existingResult = examResultMapper.selectExamResultByExamIdandUser(examId,
        examineeId);
    if (existingResult != null) {
      // 이미 참여한 경우 기존 resultId 반환 (새 result 생성 안함)
      System.out.println("기존 examResult 존재함 : " + existingResult.getResultId());
      return new ExamJoinResDTO(
          examId,
          existingResult.getResultId(),
          examCode,
          examineeId,
          URI.create(String.format("/api/exams/%d/exam-data", examId)).toString()
      );
    }

    // RDB에 새로운 resultId 생성 및 저장
    ExamResultVO examResultVO = new ExamResultVO();
    examResultVO.setExamId(examId);
    examResultVO.setExamineeId(examineeId);
    examResultVO.setScore(0);
    examResultVO.setSubmittedAt(LocalDateTime.of(1900, 1, 1, 0, 0, 0)); //기본값 설정
    examResultVO.setReviewed(false);
    examResultMapper.insertExamResult(examResultVO);
    int generatedResultId = examResultMapper.selectExamResultByExamIdandUser(examId, examineeId)
        .getResultId();

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


  //답변 데이터 전체만 몽고
  @Override
  public Map<String, Object> getExamResultData(int examId, int examineeId) {
    // MongoDB에서 해당 시험의 응시 데이터 가져오기
    Query query = Query.query(Criteria.where("examId").is(examId)
        .and("examineeId").is(examineeId));
    ExamResultMongoVO examResultMongo = mongoTemplate.findOne(query, ExamResultMongoVO.class,
        "examResults");

    int resultId = examResultMapper.selectExamResultByExamIdandUser(examId, examineeId)
        .getResultId();
    // 기존 응답 데이터 가져오기 (혹시 몰라 디폴트 빈 답변들 생성)
    List<AnswerVO> answers = (examResultMongo != null && examResultMongo.getAnswers() != null)
        ? examResultMongo.getAnswers()
        : new ArrayList<>();

    // JSON 응답 구조 구성
    Map<String, Object> resultData = new HashMap<>();
    resultData.put("examId", examId);
    resultData.put("resultId", resultId); // (나중에 제출 시 필요)
    resultData.put("examineeId", examineeId);
    resultData.put("answers", answers);
    return resultData;
  }


  // 시험 문제 전체 + 답변 데이터 전체
  @Override
  public ExamDataResDTO getExamData(int examId, int examineeId) {
    // 시험 문제 가져오기
    List<QuestionVO> questions = examService.getExamQuestions(examId);

    // 응시자가 제출한 (몽고)데이터 가져오기
    Map<String, Object> examResultData = getExamResultData(examId, examineeId);

    int resultId = examResultMapper.selectExamResultByExamIdandUser(examId, examineeId)
        .getResultId();
    // 📌 빈 answers 최초 생성 지점 (추후 resultDetail 입력시 쓰임)
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


  // 시험 채점 메서드
  @Override
  @Transactional
  public List<AnswerVO> gradingExam(List<AnswerVO> answers, ExamResultVO examResultVO, int resultId,
      int examId) {

    int totalScore = 0;

    // NPE 방지: resultDetailVOList가 null이면 초기화
    if (examResultVO.getResultDetails() == null) {
      examResultVO.setResultDetails(new ArrayList<>());
    }
    List<ResultDetailVO> resultDetailVOList = examResultVO.getResultDetails();

    // 해당 시험에서 정답 리스트 조회
    Query query = Query.query(Criteria.where("examId").is(examId));
    ExamMongoVO examMongoVO = mongoTemplate.findOne(query, ExamMongoVO.class, "exams");

    List<QuestionVO> questions = examMongoVO.getQuestions();

    // 문제 ID를 키로 하는 Map생성 (기존 제출된 답변 매칭)
    Map<Integer, AnswerVO> answerMap = answers.stream()
        .collect(Collectors.toMap(AnswerVO::getQuestionId, a -> a));

    List<AnswerVO> updatedAnswers = new ArrayList<>();

    // 채점 로직
    for (QuestionVO question : questions) {
      int questionId = question.getQuestionId();

      // 제출되지 않은 문제는 자동으로 "미응답" 처리
      AnswerVO answer = answerMap.getOrDefault(questionId, new AnswerVO());
      answer.setQuestionId(questionId);

      if (answer.getAnswer() == null) {
        answer.setAnswer("");  // 미응답
        answer.setPointsEarned(0);
        answer.setCorrect(false);
        answer.setObjection(false);

      }

      // 채점
      if (answer.getAnswer().equals(question.getCorrectAnswer())) {
        answer.setCorrect(true);
        answer.setPointsEarned(question.getPointsAllocation());
      }

      totalScore += answer.getPointsEarned();
      updatedAnswers.add(answer);

      // result_detail에도 저장할 데이터 추가
      ResultDetailVO resultDetail = new ResultDetailVO();
      resultDetail.setExamId(examId);
      resultDetail.setResultId(resultId);
      resultDetail.setQuestionId(questionId);
      resultDetail.setCorrect(answer.isCorrect());
      resultDetailVOList.add(resultDetail);
    }

    // 총점 업데이트
    examResultVO.setScore(totalScore);
    examResultMapper.updateExamResult(examResultVO);

    // result_detail 저장
    if (!resultDetailVOList.isEmpty()) {
      examResultMapper.insertResultDetail(resultDetailVOList);
    }

    return updatedAnswers; // 모든 문제(미응답 포함) 반환
  }


  // 채점 상태 조회
  @Override
  public ExamResultVO getResultDetail(int examineeId, int examId, int resultId) {

    ExamResultVO examResult = examResultMapper.selectExamResultByExamIdandUser(examId, examineeId);
    List<ResultDetailVO> resultDetails = examResultMapper.selectResultDetailByResultId(resultId);
    examResult.setResultDetails(resultDetails);

    return examResult;
  }


  @Override
  public List<Map<String, Object>> getQuestionsState(int examId, int examineeId) {

    int resultId = examResultMapper.selectExamResultByExamIdandUser(examId, examineeId)
        .getResultId();
    Query query = Query.query(Criteria.where("resultId").is(resultId));
    ExamResultMongoVO examResult = mongoTemplate.findOne(query, ExamResultMongoVO.class,
        "examResults");

    if (examResult == null) {
      return Collections.emptyList(); // todo 없는 경우 빈 리스트 반환  or 빈 결과 예외처리
    }

    // 필드 추출하여 리스트로 반환
    return examResult.getAnswers().stream()
        .map(answer -> {
          Map<String, Object> result = new HashMap<>();
          result.put("questionId", answer.getQuestionId());
          result.put("isCorrect", Boolean.TRUE.equals(answer.isCorrect()));
          result.put("isObjection", Boolean.TRUE.equals(answer.isObjection()));
          return result;
        })
        .collect(Collectors.toList());
  }


  @Override
  public ExamineeInfoResDTO getExamineeInfo(int examId, int examineeId) {
    return examResultMapper.selectExamineeInfo(examId, examineeId);

  }


  @Override
  @Transactional
  public boolean submitObjection(int examId, int examineeId, int questionId, String Comments) {
    // RDB에서 resultId 가져오기
    Integer resultId = examResultMapper.selectExamResultByExamIdandUser(examId, examineeId)
        .getResultId();
    if (resultId == null) {
      return false; // 예외처리
    }
    // MongoDB에서 resultId로 검색하여 기존 데이터 가져오기
    Query query = Query.query(
        Criteria.where("resultId").is(resultId)
            .and("answers").elemMatch(Criteria.where("questionId").is(questionId))
    );
    // questionId가 존재하는지 먼저 확인 (전체 answers 배열 조회)
    Query checkQuery = Query.query(
        Criteria.where("resultId").is(resultId)
            .and("answers.questionId").is(questionId)
    );

    ExamResultMongoVO existingExamResult = mongoTemplate.findOne(checkQuery,
        ExamResultMongoVO.class, "examResults");

    if (existingExamResult == null) {
      System.out.println("존재하지 않는 questionId");
      throw new IllegalArgumentException("해당 questionId가 존재하지 않습니다.");
    }

    Update update = new Update()
        .set("answers.$.isObjection", true)
        .set("answers.$.objectionComments", Comments);
    mongoTemplate.updateFirst(query, update, "examResults");
    return true;
  }


  @Override
  @Transactional
  public boolean submitObjectionReply(int examId, int examineeId, int questionId,
      String objectionReply) {
    // RDB에서 resultId 가져오기
    Integer resultId = examResultMapper.selectExamResultByExamIdandUser(examId, examineeId)
        .getResultId();
    if (resultId == null) {
      return false; // 예외 처리 (시험 응시 기록 없음)
    }

    // MongoDB에서 해당 문제(`questionId`)에 대한 이의제기 여부 확인
    Query query = Query.query(
        Criteria.where("resultId").is(resultId)
            .and("answers.questionId").is(questionId)
            .and("answers.isObjection").is(true));  // 이의제기된 문제만 업데이트 가능

    ExamResultMongoVO existingExamResult = mongoTemplate.findOne(query, ExamResultMongoVO.class,
        "examResults");
    if (existingExamResult == null) {
      throw new IllegalArgumentException("해당 questionId에 대한 이의제기 정보가 존재하지 않습니다.");
    }

    // 해당 문제가 존재하면 `objectionReply` 추가
    Update update = new Update().set("answers.$.objectionReply", objectionReply);
    UpdateResult updateResult = mongoTemplate.updateFirst(query, update, "examResults");

    return true;
  }


  @Override
  @Transactional
  public boolean updateQuestionScore(int resultId, int questionId, boolean isCorrected) {

    //Answers 꺼내기 위한 ExamResult
    Query query = Query.query(Criteria.where("resultId").is(resultId));
    ExamResultMongoVO examResultVO = mongoTemplate.findOne(query, ExamResultMongoVO.class,
        "examResults");
    //Questions 꺼내기 위한 Exam
    ExamVO examVO = examMapper.selectExamByResultId(resultId);
    Query query1 = Query.query(Criteria.where("examId").is(examVO.getExamId()));
    ExamMongoVO examMongoVO = mongoTemplate.findOne(query1, ExamMongoVO.class, "exams");

    List<AnswerVO> answers = examResultVO.getAnswers();
    List<QuestionVO> questions = examMongoVO.getQuestions(); //todo 없는 문제, 없는 결과, 같은 corrected 예외처리

    int score = 0;
    for (int i = 0; i < answers.size(); i++) {
      if (answers.get(i).getQuestionId() == questionId) {
        score = questions.get(i).getPointsAllocation();
        answers.get(i).setPointsEarned(score); // 획득점수 수정
        answers.get(i).setCorrect(isCorrected);// 정답여부 수정
      }
    }

    // 수정 내용 RDB 업데이트 (점수 + 정답 여부 처리)
    Map<String, Object> params = new HashMap<>();
    params.put("resultId", resultId);
    params.put("questionId", questionId);
    params.put("score", isCorrected ? score : -score);
    params.put("isCorrect", isCorrected);

    examResultMapper.updateScoreAndIsCorrect(params);

    //몽고에도 변화 적용
    Query updateQuery = Query.query(
        Criteria.where("resultId").is(resultId).and("answers.questionId").is(questionId));
    Update update = new Update()
        .set("answers.$.pointsEarned", score)
        .set("answers.$.isCorrect", isCorrected);
    mongoTemplate.updateFirst(updateQuery, update, "examResults");

    return true;

  }


  @Override
  @Transactional
  public boolean updateShortAnswerAndScore(int resultId, int questionId, boolean isCorrected,
      String correctedAnswer, Integer newScore) {

    // 기존 채점 결과 가져오기
    Query query = Query.query(
        Criteria.where("resultId").is(resultId)
            .and("answers.questionId").is(questionId)
    );
    ExamResultMongoVO existingExamResult = mongoTemplate.findOne(query, ExamResultMongoVO.class,
        "examResults");

    if (existingExamResult == null) {
      throw new IllegalArgumentException("해당 문제에 대한 기존 채점 데이터가 없습니다.");
    }

    // 기존 점수 조회
    AnswerVO existingAnswer = existingExamResult.getAnswers().stream()
        .filter(a -> a.getQuestionId() == questionId)
        .findFirst()
        .orElseThrow(() -> new IllegalArgumentException("해당 문제의 답변이 존재하지 않습니다."));

    int oldScore = existingAnswer.getPointsEarned();
    int scoreDifference = newScore - oldScore; //총점 교체용

    // MongoDB 업데이트
    Update update = new Update()
        .set("answers.$.isCorrect", isCorrected)
        .set("answers.$.pointsEarned", newScore);
    mongoTemplate.updateFirst(query, update, "examResults");

    // RDB 업데이트
    Map<String, Object> params = new HashMap<>();
    params.put("resultId", resultId);
    params.put("questionId", questionId);
    params.put("isCorrect", isCorrected);
    params.put("scoreDifference", scoreDifference);

    // result_detail 테이블 업데이트 (is_correct 변경)
    examResultMapper.updateIsCorrect(params);

    // exam_result 테이블 총점 업데이트 (score 변경)
    examResultMapper.updateExamTotalScore(params);

    return true;
  }


}

