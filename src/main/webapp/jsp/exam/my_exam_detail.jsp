<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/my_exam_detail.css">
  <title>시험 응시</title>
</head>
<body>

<!-- 헤더 -->
<div class="exam-header">
  <div class="exam-info">
    <span>시험명: <strong id="exam-title"></strong></span>
    <span>출제자: <strong id="exam-creator"></strong></span>
    <span>총점: <strong id="total-score"></strong></span>
    <span>카테고리: <strong id="exam-category"></strong></span>
    <span>시간: <strong id="exam-time"></strong></span>
  </div>
</div>

<!-- 시험 본문 -->
<div class="exam-container">
  <div class="sidebar" id="question-list">
    <h3>문제 목록</h3>
  </div>

  <div class="content">
    <div id="exam-questions"></div>
    <button class="submit-btn" id="submit-exam">시험 결과 확인 완료</button>
  </div>
</div>

<script>
  var urlParams = new URLSearchParams(window.location.search);
  var examId = urlParams.get("examId") || "44";
  var examineeId = "1"; // 세션에서 가져올 수도 있음
  var resultId = "21"; // 불러올 시험 결과 ID
  var questions = [];
  var answers = []; // 이전 제출 답변 저장
  var remainingTime = 0;

  function loadExamData() {
    var examUrl = "http://localhost:8088/api/exams/results/" + examId + "/exam-data";
    var answersUrl = "http://localhost:8088/api/exams/results/" + examId + "/" + resultId + "/details";

    console.log("시험 데이터 요청 URL:", examUrl);
    console.log("사용자 제출 답변 요청 URL:", answersUrl);

    fetch(examUrl)
            .then(response => response.json())
            .then(examData => {
              if (examData.code == 200) {
                questions = examData.data.questions;
                renderExam(examData.data);

                // ✅ resultId = 21에 해당하는 응답 데이터를 가져옴
                return fetch(answersUrl);
              } else {
                throw new Error("시험 데이터를 불러오는 중 오류 발생");
              }
            })
            .then(response => response.json())
            .then(answerData => {
              if (answerData.code == 200) {
                answers = answerData.data.answers;  // ✅ resultId = 21 의 데이터 저장
                fillPreviousAnswers();
              }
            })
            .catch(error => console.error("데이터 불러오기 실패:", error));
  }

  function getTotalScore(questions) {
    return questions.reduce((total, question) => total + (question.pointsAllocation || 0), 0);
  }

  function renderExam(examData) {
    document.getElementById("exam-title").textContent = examData.title;
    document.getElementById("exam-creator").textContent = examData.createrId;
    document.getElementById("total-score").textContent = getTotalScore(examData.questions);
    document.getElementById("exam-category").textContent = examData.category;
    document.getElementById("exam-time").textContent = examData.examTime + "분";

    var questionList = document.getElementById("question-list");
    var examQuestions = document.getElementById("exam-questions");

    questionList.innerHTML = "<h3>문제 목록</h3>";
    examQuestions.innerHTML = "";

    for (var i = 0; i < examData.questions.length; i++) {
      var q = examData.questions[i];

      var questionBtn = document.createElement("button");
      questionBtn.textContent = "문제 " + (i + 1);
      questionBtn.onclick = createScrollHandler(q.questionId);
      questionList.appendChild(questionBtn);

      var questionDiv = document.createElement("div");
      questionDiv.className = "question-box";
      questionDiv.id = "question-" + q.questionId;

      var contentDiv = document.createElement("div");
      contentDiv.className = "question-content";
      contentDiv.textContent = (i + 1) + ". " + q.content + " (" + q.pointsAllocation + "점)";

      questionDiv.appendChild(contentDiv);

      var optionsDiv = document.createElement("div");
      optionsDiv.className = "options";

      if (q.type === "multiple_choice") {
        renderMultipleChoiceOptions(q, optionsDiv);
      } else {
        renderShortAnswerInput(q, optionsDiv);
      }

      questionDiv.appendChild(optionsDiv);
      examQuestions.appendChild(questionDiv);
    }
    document.getElementById("submit-exam").disabled = false;
  }

  function fillPreviousAnswers() {
    for (var questionId in answers) {
      var answer = answers[questionId];
      var question = questions.find(q => q.questionId == questionId);

      if (!question) continue;

      if (question.type === "multiple_choice") {
        var radios = document.getElementsByName("answer-" + questionId);
        radios.forEach(radio => {
          if (radio.value == answer) {
            radio.checked = true;
          }
        });
      } else {
        var input = document.getElementById("answer-" + questionId);
        if (input) {
          input.value = answer;
        }
      }
    }
  }

  function createScrollHandler(questionId) {
    return function () {
      var questionElement = document.getElementById("question-" + questionId);
      if (questionElement) {
        questionElement.scrollIntoView({ behavior: "smooth" });
      }
    };
  }

  // 사용자의 응답을 저장하는 핸들러 함수 추가
  function createSaveAnswerHandler(questionId, value) {
    return function() {
      answers[questionId] = value;
    };
  }

  function renderMultipleChoiceOptions(question, container) {
    question.options.forEach(option => {
      var label = document.createElement("label");
      var radio = document.createElement("input");
      radio.type = "radio";
      radio.name = "answer-" + question.questionId;
      radio.value = option;
      radio.onchange = createSaveAnswerHandler(question.questionId, option); // 여기에 적용됨!

      label.appendChild(radio);
      label.appendChild(document.createTextNode(option));
      container.appendChild(label);
    });
  }

  function renderShortAnswerInput(question, container) {
    var input = document.createElement("input");
    input.type = "text";
    input.className = "answer-input";
    input.id = "answer-" + question.questionId;
    input.oninput = function() {
      answers[question.questionId] = input.value;
    };

    container.appendChild(input);
  }

  document.getElementById("submit-exam").addEventListener("click", () => console.log("시험 제출"));


  // 시험 결과 확인 완료 버튼 변경 및 기능 추가
  document.getElementById("submit-exam").textContent = "시험 결과 확인 완료";
  document.getElementById("submit-exam").addEventListener("click", function() {
    console.log("시험 결과 확인 완료");
    this.disabled = true; // 버튼 클릭 후 비활성화
  });
  loadExamData();
</script>
</body>
</html>
