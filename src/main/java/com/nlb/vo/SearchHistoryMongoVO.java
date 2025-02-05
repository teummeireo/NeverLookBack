package com.nlb.vo;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Document(collection = "search_history")
public class SearchHistoryMongoVO {

  @Id
  private String id;  // MongoDB의 ObjectId

  private int userId; // RDB의 nlbuser.user_id와 매핑

  private List<SearchRecord> searchHistory; // 검색 기록 리스트

  @Getter
  @Setter
  @NoArgsConstructor
  @AllArgsConstructor
  @ToString
  public static class SearchRecord {
    private String searchTerm;  // 검색어
    private LocalDateTime searchedAt; // 검색 시간
  }
}
