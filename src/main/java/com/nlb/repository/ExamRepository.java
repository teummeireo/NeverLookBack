package com.nlb.repository;

import com.nlb.vo.ExamMongoVO;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface ExamRepository extends MongoRepository<ExamMongoVO, Integer> {

}
