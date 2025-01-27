package com.nlb.service;


import com.mongodb.client.result.UpdateResult;
import com.nlb.mapper.ExamMapper;
import com.nlb.mapper.ExamResultMapper;
import com.nlb.mapper.ResultDetailMapper;
import com.nlb.repository.ExamRepository;
import com.nlb.vo.ExamMongoVO;
import com.nlb.vo.ExamVO;
import com.nlb.vo.QuestionVO;
import java.util.Map;
import java.util.stream.Collectors;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
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
  public int createExam(ExamMongoVO examMongoVO) {

    //RDB 에 먼저 저장
    ExamVO examVO = converToExamVO(examMongoVO);
    examMapper.insertExam(examVO);

    //RDB에 저장하고 생성된 ID 값과 같은 examId 값으로 몽고db에 저장 (_id랑 별개 ㅠㅠ)
    int generatedId = examVO.getExamId();
    System.out.println("getExamId 테스트 입니다 +" + generatedId);
    examMongoVO.setExamId(generatedId);

    //examRepository.save(examMongoVO); //둘중 원하는 방식으로 사용
    mongoTemplate.save(examMongoVO, "exams");  //todo 컬렉션네이밍 픽스해야함(템플릿은)

    return generatedId;
  }

  @Override
  @Transactional
  public boolean updateExam(int examId, ExamMongoVO updatedExamVO) {

    Query query = new Query(Criteria.where("examId").is(examId));
    Update update = new Update();

    update.set("title", updatedExamVO.getTitle());
    update.set("category", updatedExamVO.getCategory());
    update.set("entreeCode", updatedExamVO.getEntreeCode());
    update.set("examTime", updatedExamVO.getExamTime());
    update.set("startedAt", updatedExamVO.getStartedAt());
    update.set("finishedAt", updatedExamVO.getFinishedAt());

    // MongoDB 업데이트 수행
    UpdateResult result = mongoTemplate.updateFirst(query, update, ExamMongoVO.class, "exams");

    //RDB 업데이트: 전체 VO 변환 후 업데이트 수행
    ExamMongoVO examMongVO = findExamByExamId(examId);

    ExamVO examVO = converToExamVO(examMongVO);
    int rowsUpdated = examMapper.updateExamById(examVO);

    return result.getMatchedCount() > 0 && rowsUpdated > 0;

  }

  @Override
  @Transactional
  public boolean updateQuestions(int examId, List<QuestionVO> Questions) {
    Query query = new Query();
    query.addCriteria(Criteria.where("examId").is(examId)); // 조건: examId로 검색

    Update update = new Update();
    update.set("questions", Questions); // 질문 리스트 통째로 업데이트
    // 프론트에서 전달받은 질문 리스트로 업데이트

    // MongoDB에 업데이트
    UpdateResult result = mongoTemplate.updateFirst(query, update, ExamMongoVO.class, "exams");

    if (result.getMatchedCount() > 0) {
      // RDB에 question_count 필드에도 업데이트
      int questionCount = Questions.size();
      examMapper.updateQuestionCount(examId, questionCount);
      return true;
    }
    return false;
  }


  //RDB 동시 저장목적 nosql용VO -> RDB용VO 변환 메서드
  private ExamVO converToExamVO(ExamMongoVO examMongoVO) {
    ExamVO examVO = new ExamVO();
    examVO.setExamId(examMongoVO.getExamId());
    //examVO.setCreatorId((int)session.getAttribute("userId")); //todo 로그인 컨트롤러에서 저장로직 필요! or 토큰쓴다면 토큰에서 꺼내는 로직 논의 필요
    examVO.setCreaterId(1);
    examVO.setExamCode(examMongoVO.getExamCode());
    examVO.setTitle(examMongoVO.getTitle());
    examVO.setCategory(examMongoVO.getCategory());
    examVO.setEntreeCode(examMongoVO.getEntreeCode());
    examVO.setQuestionCount(examMongoVO.getQuestionCount());
    examVO.setExamTime(examMongoVO.getExamTime());
    examVO.setStartedAt(examMongoVO.getStartedAt());
    examVO.setFinishedAt(examMongoVO.getFinishedAt());
    examVO.setActivationStatus("not-started"); // 기본값
    return examVO;
  }

  //고유 _id 가 없어서 examId를 찾을때 query 객체로 찾아야하는 용도 메서드
  public ExamMongoVO findExamByExamId(int examId) {
    Query query = new Query();
    query.addCriteria(Criteria.where("examId").is(examId));
    return mongoTemplate.findOne(query, ExamMongoVO.class, "exams");
  }
}
