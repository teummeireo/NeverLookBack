<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시험 응시</title>
    <style>
      * { box-sizing: border-box; margin: 0; padding: 0; font-family: Arial, sans-serif; }
      body { display: flex; flex-direction: column; height: 100vh; }

      .exam-header { display: flex; justify-content: space-between; padding: 15px; background: #007BFF; color: white; }
      .exam-info { display: flex; gap: 20px; }
      .timer { font-weight: bold; }

      .exam-container { display: flex; flex: 1; }
      .sidebar { width: 250px; background: #f4f4f4; padding: 20px; overflow-y: auto; }
      .sidebar button { display: block; width: 100%; padding: 10px; margin: 5px 0; border: none; background: #ddd; cursor: pointer; text-align: left; }
      .sidebar button:hover { background: #bbb; }
      .content { flex: 1; padding: 20px; position: relative; }

      .question-box { border: 1px solid #ccc; padding: 15px; margin-bottom: 15px; }
      .question-content { font-size: 16px; font-weight: bold; margin-bottom: 10px; }
      .options label { display: block; margin: 5px 0; }
      .answer-input { width: 100%; padding: 8px; margin-top: 5px; border: 1px solid #ccc; }

      .submit-btn { background: #28a745; color: white; padding: 10px; width: 200px; border: none; cursor: pointer; font-weight: bold; display: block; margin: 20px auto; }
      .submit-btn:disabled { background: #aaa; cursor: not-allowed; }
    </style>
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
    <div class="timer">
        남은 시간: <strong id="remaining-time">00:00</strong>
    </div>
</div>

<!-- 시험 본문 -->
<div class="exam-container">
    <!-- 문제 목록 -->
    <div class="sidebar" id="question-list">
        <h3>문제 목록</h3>
    </div>

    <!-- 문제 응시 폼 -->
    <div class="content">
        <div id="exam-questions"></div>
        <button class="submit-btn" id="submit-exam" disabled>시험 제출</button>
    </div>
</div>

<script>
  var urlParams = new URLSearchParams(window.location.search);
  var examId = urlParams.get("examId") || "44";

  var questions = [];
  var answers = {};
  var remainingTime = 0;
  var timerInterval;

  function loadExamData() {
    var url = "${pageContext.request.contextPath}/api/exams/results/" + examId + "/exam-data";

    console.log("시험 데이터 요청 URL:", url);

    fetch(url)
    .then(function(response) {
      console.log("API 응답 상태 코드:", response.status);
      if (!response.ok) {
        throw new Error("서버 응답 오류: " + response.status);
      }
      return response.json();
    })
    .then(function(data) {
      console.log("받은 시험 데이터:", data);
      if (data.code == 200) {
        renderExam(data.data);
      } else {
        alert("시험 데이터를 불러오는 중 오류 발생.");
      }
    })
    .catch(function(error) {
      console.error("시험 데이터 불러오기 실패:", error);
    });
  }

  function getTotalScore(questions) {
    return questions.reduce((total, question) => total + (question.pointsAllocation || 0), 0);
  }

  function renderExam(examData) {
    console.log("렌더링할 시험 데이터:", examData);

    if (!examData || !examData.questions || examData.questions.length === 0) {
      console.error("시험 데이터가 없습니다!");
      return;
    }

    // 제목, 카테고리, 출제자, 시간 추가
    document.getElementById("exam-title").textContent = examData.title;
    document.getElementById("exam-creator").textContent = "출제자: " + examData.createrId;
    document.getElementById("total-score").textContent = getTotalScore(examData.questions);
    document.getElementById("exam-category").textContent = "카테고리: " + examData.category;
    document.getElementById("exam-time").textContent = "시간: " + examData.examTime + "분";

    var questionList = document.getElementById("question-list");
    var examQuestions = document.getElementById("exam-questions");

    questionList.innerHTML = "<h3>문제 목록</h3>";
    examQuestions.innerHTML = "";

    for (var i = 0; i < examData.questions.length; i++) {
      var q = examData.questions[i];

      console.log("렌더링할 문제:", q);

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

      if (q.type == "multiple_choice") {
        renderMultipleChoiceOptions(q, optionsDiv);
      } else {
        renderShortAnswerInput(q, optionsDiv);
      }

      questionDiv.appendChild(optionsDiv);
      examQuestions.appendChild(questionDiv);
    }

    // 시험 시간 설정
    remainingTime = examData.examTime * 60;
    startTimer();

    document.getElementById("submit-exam").disabled = false;
  }


  function createScrollHandler(questionId) {
    return function() {
      var questionElement = document.getElementById("question-" + questionId);
      if (questionElement) {
        questionElement.scrollIntoView({ behavior: "smooth" });
      }
    };
  }

  function renderMultipleChoiceOptions(question, container) {
    for (var i = 0; i < question.options.length; i++) {
      var option = question.options[i];

      var label = document.createElement("label");
      var radio = document.createElement("input");
      radio.type = "radio";
      radio.name = "answer-" + question.questionId;
      radio.value = option;
      radio.onchange = createSaveAnswerHandler(question.questionId, option);

      label.appendChild(radio);
      label.appendChild(document.createTextNode(option));
      container.appendChild(label);
    }
  }

  function renderShortAnswerInput(question, container) {
    var input = document.createElement("input");
    input.type = "text";
    input.className = "answer-input";
    input.id = "answer-" + question.questionId;
    input.oninput = createSaveAnswerHandler(question.questionId, input);

    container.appendChild(input);
  }

  function createSaveAnswerHandler(questionId, value) {
    return function() {
      answers[questionId] = value;
    };
  }

  function startTimer() {
    updateTimerDisplay();
    timerInterval = setInterval(function() {
      remainingTime--;
      updateTimerDisplay();

      if (remainingTime <= 0) {
        clearInterval(timerInterval);
        alert("시험 시간이 종료되었습니다. 자동 제출합니다.");
        submitExam();
      }
    }, 1000);
  }

  function updateTimerDisplay() {
    var minutes = Math.floor(remainingTime / 60);
    var seconds = remainingTime % 60;
    document.getElementById("remaining-time").textContent =
        (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
  }

  document.getElementById("submit-exam").addEventListener("click", submitExam);

  loadExamData();

  window.onload = function () {
    console.log("페이지 로드 완료. 이벤트 등록 시작");
    document.getElementById("submit-exam").addEventListener("click", submitExam);
    loadExamData();
  };

  function submitExam() { //todo 마저 완성해야함
    console.log("시험 제출 버튼 클릭됨.");
  }



</script>
</body>
</html>
