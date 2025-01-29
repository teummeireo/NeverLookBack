package com.nlb.service;


import com.mongodb.client.result.UpdateResult;
import com.nlb.dto.request.ExamReqDTO;
import com.nlb.exception.DuplicatedQuestionException;
import com.nlb.exception.ErrorCode;
import com.nlb.mapper.ExamMapper;
import com.nlb.mapper.ExamResultMapper;
import com.nlb.mapper.ResultDetailMapper;
import com.nlb.vo.ExamMongoVO;
import com.nlb.vo.ExamVO;
import com.nlb.vo.QuestionVO;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
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
  public int createExam(ExamReqDTO examReqDTO) {
    //RDB 에 먼저 저장
    ExamVO examVO = examReqDTO.getExamVO();
    examVO.setCreaterId(1); //todo 로그인 생기면 세션에서 가져오는 로직으로 변경

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
        .set("finishedAt", examVO.getFinishedAt());
//        .set("questionCount",
//            examMongoVO.getQuestions() != null ? examMongoVO.getQuestions().size() : 0)
//        .set("questions", examMongoVO.getQuestions());
    mongoTemplate.upsert(query, update, ExamMongoVO.class, "exams");

    return generatedId;
  }

  @Override
  @Transactional
  public boolean updateExam(int examId, ExamReqDTO examReqDTO) {
    // RDB 업데이트 (ExamVO)
    ExamVO examVO = examReqDTO.getExamVO();
    examVO.setExamId(examId);  // examId 설정
    int rowsUpdated = examMapper.updateExamById(examVO);  // RDB에 기본 정보 업데이트

    // MongoDB 업데이트 (ExamMongoVO)
    ExamMongoVO examMongoVO = examReqDTO.getExamMongoVO();
    Query query = Query.query(Criteria.where("examId").is(examId));  // examId로 MongoDB에서 찾기
    Update update = new Update()
        .set("title", examVO.getTitle())
        .set("category", examVO.getCategory())
        .set("entreeCode", examVO.getEntreeCode())
        .set("examTime", examVO.getExamTime())
        .set("startedAt", examVO.getStartedAt())
        .set("finishedAt", examVO.getFinishedAt())
        .set("questionCount",
            examMongoVO.getQuestions() != null ? examMongoVO.getQuestions().size() : 0)  // 문제 개수
        .set("questions", examMongoVO.getQuestions());
    UpdateResult mongoResult = mongoTemplate.updateFirst(query, update, ExamMongoVO.class,
        "exams");  // MongoDB 업데이트

    // RDB의 question_count 업데이트
    if (examMongoVO.getQuestions() != null) {
      int questionCount = examMongoVO.getQuestions().size();  // MongoDB의 questions 리스트 크기
      examMapper.updateQuestionCount(examId, questionCount);  // RDB의 question_count 업데이트
    }

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

    return (int) result.getMatchedCount();
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
}
