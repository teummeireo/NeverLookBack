package com.nlb.controller;

import com.nlb.service.NlbUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;

@RestController
public class NlbUserRestController {

    @Autowired
    private NlbUserService nlbUserService;

    @PostMapping("/check-id/{id}")
    public ResponseEntity<HashMap<String, Object>> checkId(@PathVariable("id") String id) {
        boolean isUnique = nlbUserService.isUniqueId(id);
        HashMap<String, Object> response = new HashMap<>();
        response.put("isUnique", isUnique);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}
