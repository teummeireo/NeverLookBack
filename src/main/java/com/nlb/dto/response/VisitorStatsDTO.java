package com.nlb.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class VisitorStatsDTO {
    private String dateKey;      // 예) "2025-02-09" or "2025-06"(주차)
    private int visitorCount;    // 방문(응시)자 수
}
