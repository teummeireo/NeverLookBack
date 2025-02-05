package com.nlb.controller;

import com.nlb.service.*;
import com.nlb.vo.SearchHistoryMongoVO.SearchRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/search-history")
public class SearchHistoryController {

  @Autowired
  private SearchHistoryService searchHistoryService;

  // 검색어 저장 API
  @PostMapping("/save")
  public ResponseEntity<Void> saveSearchTerm(@RequestParam int userId, @RequestParam String searchTerm) {
    searchHistoryService.saveSearchTerm(userId, searchTerm);
    return ResponseEntity.ok().build();
  }

  // 최근 검색어 조회 API
  @GetMapping("/recent")
  public ResponseEntity<List<SearchRecord>> getRecentSearches(@RequestParam int userId) {
    return ResponseEntity.ok(searchHistoryService.getRecentSearches(userId));
  }

  // 특정 검색어 삭제 API
  @PostMapping("/delete")
  public ResponseEntity<List<SearchRecord>> deleteRecentSearch(@RequestParam int userId, @RequestParam String searchTerm) {
    return ResponseEntity.ok(searchHistoryService.deleteRecentSearch(userId, searchTerm));
  }

  // 모든 검색어 삭제 API
  @PostMapping("/clear")
  public ResponseEntity<Void> clearRecentSearches(@RequestParam int userId) {
    searchHistoryService.clearRecentSearches(userId);
    return ResponseEntity.ok().build();
  }


}
