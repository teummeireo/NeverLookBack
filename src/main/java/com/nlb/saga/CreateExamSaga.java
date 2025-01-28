package com.nlb.saga;

import com.nlb.command.RollbackExamCommand;
import com.nlb.command.SaveExamToMongoCommand;
import com.nlb.command.StartCreateExamCommand;
import com.nlb.event.CreateExamMongoFailedEvent;
import com.nlb.event.CreateExamRdbFailedEvent;
import com.nlb.event.ExamCreatedEvent;
import com.nlb.event.ExamSavedToMongoEvent;
import org.axonframework.commandhandling.gateway.CommandGateway;
import org.axonframework.modelling.saga.SagaEventHandler;
import org.axonframework.spring.stereotype.Saga;
import org.springframework.beans.factory.annotation.Autowired;

@Saga
public class CreateExamSaga {

    @Autowired
    private transient CommandGateway commandGateway;

    @SagaEventHandler(associationProperty = "examReqDTO")
    public void handle(StartCreateExamCommand command) {
        // Step 1: RDB에 데이터 저장 요청
        commandGateway.send(new StartCreateExamCommand(command.getExamReqDTO()));
    }

    @SagaEventHandler(associationProperty = "examId")
    public void handle(ExamCreatedEvent event) {
        // Step 2: MongoDB에 데이터 저장 요청
        commandGateway.send(new SaveExamToMongoCommand(event.getExamMongoVO()));
    }

    @SagaEventHandler(associationProperty = "examId")
    public void handle(ExamSavedToMongoEvent event) {
        // SAGA 완료
        System.out.println("시험 생성 완료: " + event.getExamId());
    }

    @SagaEventHandler(associationProperty = "examId")
    public void handle(CreateExamRdbFailedEvent event) {
        // RDB 실패 처리 (MongoDB 요청 없이 종료)
        System.err.println("SAGA 실패 처리 - RDB 저장 실패: " + event.getReason());
    }

    @SagaEventHandler(associationProperty = "examId")
    public void handle(CreateExamMongoFailedEvent event) {
        // MongoDB 실패 처리 -> RDB 롤백 요청
        System.err.println("SAGA 실패 처리 - MongoDB 저장 실패: " + event.getReason());
        commandGateway.send(new RollbackExamCommand(event.getExamId()));
    }
}

