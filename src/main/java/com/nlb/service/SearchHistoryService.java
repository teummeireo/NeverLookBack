package com.nlb.service;

import com.nlb.vo.SearchHistoryMongoVO.*;
import java.util.List;

public interface SearchHistoryService {

    // 검색어 저장 메서드
    void saveSearchTerm(int userId, String searchTerm);

    // 최근 검색어 가져오기
    List<SearchRecord> getRecentSearches(int userId);

    // 특정 검색어 삭제 (삭제할 검색어 1개만 전달)
    List<SearchRecord> deleteRecentSearch(int userId, String searchTerm);

    // 전체 검색어 삭제
    void clearRecentSearches(int userId);
}
