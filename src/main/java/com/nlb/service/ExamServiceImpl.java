package com.nlb.service;


import com.mongodb.client.result.UpdateResult;
import com.nlb.dto.request.ExamReqDTO;
import com.nlb.exception.DuplicatedQuestionException;
import com.nlb.exception.ErrorCode;
import com.nlb.mapper.ExamMapper;
import com.nlb.mapper.ExamResultMapper;
import com.nlb.mapper.ResultDetailMapper;
import com.nlb.vo.ExamMongoVO;
import com.nlb.vo.ExamResultVO;
import com.nlb.vo.ExamVO;
import com.nlb.vo.QuestionVO;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ExamServiceImpl implements ExamService {

  @Autowired
  private ExamMapper examMapper;
  @Autowired
  private ExamResultMapper examResultMapper;
  @Autowired
  private ResultDetailMapper resultDetailMapper;
  @Autowired
  private HttpSession session;
  @Autowired
  private MongoTemplate mongoTemplate;


  @Override
  public List<ExamVO> getExamList(int userId, String sortBy, String order, String category) {
    return examMapper.selectExamListByCreaterId(userId, sortBy, order, category);
  }

  @Override
  public int setExamStatus(int examId, String status) {
    return examMapper.updateExamActivationStatus(examId, status);
  }

  @Override
  public List<Integer> deleteExam(int examId) {
    List<Integer> rows = new ArrayList<>();
    rows.add(resultDetailMapper.deleteResultDetailByExamId(examId));
    rows.add(examResultMapper.deleteExamResultByExamId(examId));
    rows.add(examMapper.deleteExamByExamId(examId));
    return rows;
  }

  @Override
  public int createExam(ExamReqDTO examReqDTO, int createrId) {
    //RDB 에 먼저 저장
    ExamVO examVO = examReqDTO.getExamVO();
    examVO.setCreaterId(createrId);

    //RDB에 저장하고 생성된 ID 값과 같은 examId 값으로 몽고db에 저장 (몽고의 _id랑 별개)
    examMapper.insertExam(examVO);
    int generatedId = examVO.getExamId();

    //몽고에 저장
    Query query = Query.query(Criteria.where("examId").is(generatedId));
    Update update = new Update()
        .set("examId", generatedId)
        .set("title", examVO.getTitle())
        .set("category", examVO.getCategory())
        .set("entreeCode", examVO.getEntreeCode())
        .set("examTime", examVO.getExamTime())
        .set("startedAt", examVO.getStartedAt())
        .set("finishedAt", examVO.getFinishedAt())
        .set("createrId", createrId);
//        .set("questionCount",
//            examMongoVO.getQuestions() != null ? examMongoVO.getQuestions().size() : 0)
//        .set("questions", examMongoVO.getQuestions());
    mongoTemplate.upsert(query, update, ExamMongoVO.class, "exams");

    return generatedId;
  }

  @Override
  @Transactional
  public boolean updateExam(int examId, ExamVO examVO) {

    // RDB 업데이트 (ExamVO)
    examVO.setExamId(examId);
    int rowsUpdated = examMapper.updateExam(
        examVO);  // RDB에 기본 정보 업데이트(mapperxml 에도 null아닐떄만 set 적용)

    // MongoDB 업데이트 (ExamMongoVO)
    Query query = Query.query(Criteria.where("examId").is(examId));  // examId로 MongoDB에서 찾기
    // 기존 값 유지하며 업데이트 할 데이터만 수정
    Map<String, Object> updateFields = new HashMap<>();
    Optional.ofNullable(examVO.getTitle()).ifPresent(value -> updateFields.put("title", value));
    Optional.ofNullable(examVO.getExamCode())
        .ifPresent(value -> updateFields.put("examCode", value));
    Optional.ofNullable(examVO.getCategory())
        .ifPresent(value -> updateFields.put("category", value));
    Optional.ofNullable(examVO.getEntreeCode())
        .ifPresent(value -> updateFields.put("entreeCode", value));
    Optional.ofNullable(examVO.getExamTime())
        .ifPresent(value -> updateFields.put("examTime", value));
    Optional.ofNullable(examVO.getStartedAt())
        .ifPresent(value -> updateFields.put("startedAt", value));
    Optional.ofNullable(examVO.getFinishedAt())
        .ifPresent(value -> updateFields.put("finishedAt", value));

    // 업데이트 된 값들만 수정하도록 매핑
    Update update = new Update();
    updateFields.forEach(update::set);
    UpdateResult mongoResult = mongoTemplate.updateFirst(query, update, ExamMongoVO.class, "exams");

    return rowsUpdated > 0 && mongoResult.getMatchedCount() > 0;
  }

  @Override
  @Transactional
  public int updateQuestions(int examId, List<QuestionVO> Questions) {

    Set<Integer> dupcheck = new HashSet<>();
    for (QuestionVO q : Questions) {
      if (!dupcheck.add(q.getQuestionId())) { // 중복 발견
        throw new DuplicatedQuestionException(ErrorCode.DUPLICATED_QUESTIONID_EXIST,
            "중복된 questionId가 포함되어 있습니다.");
      }
    }

    Query query = new Query();
    query.addCriteria(Criteria.where("examId").is(examId)); // 조건: examId로 검색

    Update update = new Update()
        .set("questionCount", Questions.size())
        .set("questions", Questions);

    UpdateResult result = mongoTemplate.updateFirst(query, update, ExamMongoVO.class, "exams");
    //까지 몽고DB 업데이트

    // RDB에 question_count 필드에도 업데이트
    int questionCount = Questions.size();
    examMapper.updateQuestionCount(examId, questionCount);

    return questionCount;
  }

  //고유 _id 가 없어서 examId를 찾을때 query 객체로 찾아야하는 용도 메서드
  public ExamMongoVO findExamByExamId(int examId) {
    Query query = new Query();
    query.addCriteria(Criteria.where("examId").is(examId));
    return mongoTemplate.findOne(query, ExamMongoVO.class, "exams");
  }


  @Override
  public List<QuestionVO> getExamQuestions(int examId) {
    ExamMongoVO examMongoVO = mongoTemplate.findOne(
        Query.query(Criteria.where("examId").is(examId)),
        ExamMongoVO.class, "exams");
    return examMongoVO != null ? examMongoVO.getQuestions() : new ArrayList<>();
  }


  @Override
  public String getExamStatus(int examId) {
    ExamVO examVO = examMapper.selectExamById(examId);
    return examVO != null ? examVO.getActivationStatus() : "null";
  }


  @Override
  public List<ExamVO> getAllExams(String sortBy, String order, String category) {
    return examMapper.selectExamList(sortBy, order, category);
  }


  // 시험 문제 전체만 (creator 기준으로)
  @Override
  public Map<String, Object> getExamDataCreated(int examId, int creatorId) {
    // MongoDB에서 해당 시험 데이터 직접 조회
    Query query = Query.query(Criteria.where("createrId").is(creatorId).and("examId").is(examId));
    Map<String, Object> examData = mongoTemplate.findOne(query, Map.class, "exams");

    if (examData == null) {
      return Collections.emptyMap();  // 비어있는 맵 반환하여 Null 방지
    }

    return examData;
  }

  // 시험명 검색
  @Override
  public List<ExamVO> searchExamsByName(String name) {
    return examMapper.findExamsByName(name);
  }

  // 시험 상세 검색 필터링
  @Override
  public List<ExamVO> filterExam(String name, String category, String creator, String createdAt, String activationStatus, Integer examTime) {
    return examMapper.searchExams(name, category, creator, createdAt, activationStatus, examTime);
  }

  // 시간 초과 여부 판정 함수
  @Override
  public boolean isTimeOver(int examId, LocalDateTime finishTime) {
    if (LocalDateTime.now().isAfter(finishTime) || LocalDateTime.now().isEqual(finishTime)) {return true;}return false;}


  // 모든 시험 조회
  @Override
  public List<ExamVO> getAllExams() {
    return examMapper.searchAllExams();
  }

}
