package com.nlb.handler;

import com.nlb.command.RollbackExamCommand;
import com.nlb.command.SaveExamToMongoCommand;
import com.nlb.command.StartCreateExamCommand;
import com.nlb.event.CreateExamMongoFailedEvent;
import com.nlb.event.CreateExamRdbFailedEvent;
import com.nlb.event.ExamCreatedEvent;
import com.nlb.event.ExamSavedToMongoEvent;
import com.nlb.mapper.ExamMapper;
import com.nlb.vo.ExamMongoVO;
import com.nlb.vo.ExamVO;
import org.axonframework.commandhandling.CommandHandler;
import org.axonframework.commandhandling.gateway.CommandGateway;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Component;

@Component
public class ExamCommandHandler {

    @Autowired
    private transient CommandGateway commandGateway;

    @Autowired
    private ExamMapper examMapper;

    @Autowired
    private MongoTemplate mongoTemplate;

    @CommandHandler
    public int handle(StartCreateExamCommand command) {
        try {
            // RDB 저장
            ExamVO examVO = command.getExamReqDTO().getExamVO();
            examMapper.insertExam(examVO);
            int generatedId = examVO.getExamId();
            ExamMongoVO examMongoVO = command.getExamReqDTO().getExamMongoVO();
            examMongoVO.setExamId(generatedId);

            // 성공 이벤트 발송
            commandGateway.sendAndWait(new ExamCreatedEvent(generatedId, examMongoVO));
            return generatedId; // 성공 시 examId 반환
        } catch (Exception e) {
            // 실패 이벤트 발송
            commandGateway.sendAndWait(new CreateExamRdbFailedEvent("RDB 저장 실패: " + e.getMessage()));
            throw e; // 예외 다시 던짐
        }
    }

    @CommandHandler
    public void handle(SaveExamToMongoCommand command) {
        try {
            // MongoDB 저장
            mongoTemplate.save(command.getExamMongoVO(), "exams");

            // 성공 이벤트 발송
            commandGateway.sendAndWait(new ExamSavedToMongoEvent(command.getExamMongoVO().getExamId()));
        } catch (Exception e) {
            // MongoDB 실패 이벤트 발송
            commandGateway.sendAndWait(new CreateExamMongoFailedEvent(command.getExamMongoVO().getExamId(), "MongoDB 저장 실패: " + e.getMessage()));
        }
    }

    @CommandHandler
    public void handle(RollbackExamCommand command) {
        try {
            // RDB 데이터 롤백
            examMapper.deleteExamByExamId(command.getExamId());
            System.out.println("RDB 롤백 성공: ExamId = " + command.getExamId());
        } catch (Exception e) {
            System.err.println("RDB 롤백 실패: ExamId = " + command.getExamId() + ", 이유: " + e.getMessage());
        }
    }
}


