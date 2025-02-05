package com.nlb.service;

import com.nlb.vo.SearchHistoryMongoVO;
import com.nlb.vo.SearchHistoryMongoVO.SearchRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class SearchHistoryServiceImpl implements SearchHistoryService {

    @Autowired
    private MongoTemplate mongoTemplate;

    // 검색어 저장
    public void saveSearchTerm(int userId, String searchTerm) {
        Query query = new Query(Criteria.where("userId").is(userId));
        SearchHistoryMongoVO history = mongoTemplate.findOne(query, SearchHistoryMongoVO.class);

        if (history == null) {
            history = new SearchHistoryMongoVO();
            history.setUserId(userId);
            history.setSearchHistory(new ArrayList<>());
        }

        // 중복 검색어 제거 후 추가
        history.getSearchHistory().removeIf(record -> record.getSearchTerm().equalsIgnoreCase(searchTerm));
        history.getSearchHistory().add(new SearchRecord(searchTerm, LocalDateTime.now()));

        // MongoDB에 업데이트
        mongoTemplate.save(history);
    }

    // 최근 검색어 목록 조회
    public List<SearchRecord> getRecentSearches(int userId) {
        Query query = new Query(Criteria.where("userId").is(userId));
        SearchHistoryMongoVO history = mongoTemplate.findOne(query, SearchHistoryMongoVO.class);
        return Optional.ofNullable(history)
            .map(SearchHistoryMongoVO::getSearchHistory)
            .orElse(new ArrayList<>());
    }

    // 특정 검색어 삭제 (삭제할 검색어 1개만 전달)
    public List<SearchRecord> deleteRecentSearch(int userId, String searchTerm) {
        Query query = new Query(Criteria.where("userId").is(userId));
        SearchHistoryMongoVO history = mongoTemplate.findOne(query, SearchHistoryMongoVO.class);

        if (history != null) {
            history.getSearchHistory().removeIf(record -> record.getSearchTerm().equalsIgnoreCase(searchTerm));
            mongoTemplate.save(history); // 삭제된 후 저장
        }

        return getRecentSearches(userId);
    }

    // 전체 검색어 삭제
    public void clearRecentSearches(int userId) {
        Query query = new Query(Criteria.where("userId").is(userId));
        mongoTemplate.remove(query, SearchHistoryMongoVO.class);
    }
}
