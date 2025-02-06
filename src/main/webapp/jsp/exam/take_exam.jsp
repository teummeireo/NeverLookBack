<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>시험 응시</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
      * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
        font-family: Arial, sans-serif;
      }

      body {
        display: flex;
        flex-direction: column;
        height: 100vh;
      }

      .exam-header {
        display: flex;
        justify-content: space-between;
        padding: 15px;
        background: #007BFF;
        color: white;
      }

      .exam-info {
        display: flex;
        gap: 20px;
      }

      .timer {
        font-weight: bold;
      }

      .exam-container {
        display: flex;
        flex: 1;
      }

      .sidebar {
        width: 250px;
        background: #f4f4f4;
        padding: 20px;
        overflow-y: auto;
      }

      .sidebar button {
        display: block;
        width: 100%;
        padding: 10px;
        margin: 5px 0;
        border: none;
        background: #ddd;
        cursor: pointer;
        text-align: left;
      }

      .sidebar button:hover {
        background: #bbb;
      }

      .content {
        flex: 1;
        padding: 20px;
        position: relative;
      }

      .question-box {
        border: 1px solid #ccc;
        padding: 15px;
        margin-bottom: 15px;
      }

      .question-content {
        font-size: 16px;
        font-weight: bold;
        margin-bottom: 10px;
      }

      .options label {
        display: block;
        margin: 5px 0;
      }

      .answer-input {
        width: 100%;
        padding: 8px;
        margin-top: 5px;
        border: 1px solid #ccc;
      }

      .submit-btn {
        background: #28a745;
        color: white;
        padding: 10px;
        width: 200px;
        border: none;
        cursor: pointer;
        font-weight: bold;
        display: block;
        margin: 20px auto;
      }

      .submit-btn:disabled {
        background: #aaa;
        cursor: not-allowed;
      }
    </style>
</head>
<body>

<!-- 헤더 영역 -->
<div class="exam-header">
    <div class="exam-info">
        <span>시험명: <strong id="exam-title"></strong></span>
        <span>출제자: <strong id="exam-creator"></strong></span>
        <span>총점: <strong id="total-score"></strong></span>
        <span>카테고리: <strong id="exam-category"></strong></span>
        <span>시간: <strong id="exam-time"></strong></span>
    </div>
    <!-- 타이머 표시 -->
    <div class="timer">
        남은 시간: <strong id="remaining-time">00:00</strong>
    </div>
</div>

<!-- 시험 본문 -->
<div class="exam-container">
    <!-- 문제 목록 사이드바 -->
    <div class="sidebar" id="question-list">
        <h3>문제 목록</h3>
    </div>

    <!-- 문제 표시 영역 -->
    <div class="content">
        <div id="exam-questions"></div>
        <button class="submit-btn" id="submit-exam" disabled>시험 제출</button>
    </div>
</div>

<!-- SockJS, Stomp JS 라이브러리 -->
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.6.1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<script>
  // 세션에서 가져온 examId, examineeId
  var examId = ${sessionScope.examId};
  var examineeId = ${sessionScope.examineeId};


  // ========================
  // 1) WebSocket 연결 + 시험별 채널 구독
  // ========================
  var stompClient = null;
  // 서버 vs 클라이언트 시간차(밀리초)
  var timeOffset = 0;
  var timerInterval = null;
  var autoSaveInterval = null;  // 3분마다 자동 저장 타이머
  var isExamSubmitted = false;  // 시험 제출 여부 플래그

  function connectWebSocket() {
    var socket = new SockJS('/stomp-endpoint');
    stompClient = Stomp.over(socket);

    stompClient.connect({}, function (frame) {
      console.log("STOMP 연결 성공:", frame);

      // (A) 시험별 서버 시간 구독: /topic/exam/{examId}/serverTime
      stompClient.subscribe("/topic/exam/" + examId + "/serverTime", function (msg) {
        var serverTime = parseInt(msg.body);
        var clientTime = new Date().getTime();
        // 서버와 클라이언트 시간차
        timeOffset = serverTime - clientTime;
      });

      // (B) 시험 알림 구독: /topic/exam/{examId}/notifications
      stompClient.subscribe("/topic/exam/" + examId + "/notifications", function (msg) {
        alert("[시험공지] " + msg.body);
      });
    });
  }

  // ========================
  // 2) 시험 데이터 로딩 + 문제 렌더링
  // ========================

  var questions = [];
  var answers = [];
  var examData = null;

  function loadExamData() {
    var baseUrl = window.location.origin;
    var url = baseUrl + "/api/exams/results/" + examId + "/exam-data";

    fetch(url)
    .then(function (response) {
      if (!response.ok) {
        throw new Error("서버 응답 오류: " + response.status);
      }
      return response.json();
    })
    .then(function (data) {
      console.log("🔥 [시험 데이터 로드] 응답 데이터:", data);

      if (data.code == 200) {
        examData = data.data;
        console.log("🔥 [시험 데이터] answers =", examData.answers);

        renderExam(examData);
      } else {
        alert("시험 데이터를 불러오는 중 오류 발생.");
      }
    })
    .catch(function (error) {
      console.error("시험 데이터 불러오기 실패:", error);
      alert("시험 데이터 로딩 오류");
    });
  }

  function renderExam(examData) {
    if (!examData || !examData.questions || examData.questions.length === 0) {
      console.error("시험 데이터가 없습니다!");
      return;
    }

    // 헤더 정보 표시
    document.getElementById("exam-title").textContent = examData.title;
    document.getElementById("exam-creator").textContent = "출제자: " + examData.createrId;
    document.getElementById("total-score").textContent = getTotalScore(examData.questions);
    document.getElementById("exam-category").textContent = "카테고리: " + examData.category;
    document.getElementById("exam-time").textContent = "시간: " + examData.examTime + "분";

    // 사이드바와 문제영역
    var questionList = document.getElementById("question-list");
    var examQuestions = document.getElementById("exam-questions");

    questionList.innerHTML = "<h3>문제 목록</h3>";
    examQuestions.innerHTML = "";

    for (var i = 0; i < examData.questions.length; i++) {
      var q = examData.questions[i];

      // 사이드바 버튼
      var questionBtn = document.createElement("button");
      questionBtn.textContent = "문제 " + (i + 1);
      questionBtn.onclick = createScrollHandler(q.questionId);
      questionList.appendChild(questionBtn);

      // 실제 문제 표시
      var questionDiv = document.createElement("div");
      questionDiv.className = "question-box";
      questionDiv.id = "question-" + q.questionId;

      var contentDiv = document.createElement("div");
      contentDiv.className = "question-content";
      contentDiv.textContent = (i + 1) + ". " + q.content + " (" + q.pointsAllocation + "점)";

      questionDiv.appendChild(contentDiv);

      var optionsDiv = document.createElement("div");
      optionsDiv.className = "options";

      var existingAnswer = examData.answers.find(a => a.questionId === q.questionId);
      var savedAnswer = existingAnswer ? existingAnswer.answer : null;


      if (q.type === "multiple_choice") {
        renderMultipleChoiceOptions(q, optionsDiv);
      } else {
        renderShortAnswerInput(q, optionsDiv);
      }

      questionDiv.appendChild(optionsDiv);
      examQuestions.appendChild(questionDiv);
    }

    // 시험 시간(초) 설정 후 타이머 시작
    remainingTime = examData.examTime * 60;
    startTimer();

    // 제출 버튼 활성화
    document.getElementById("submit-exam").disabled = false;
  }

  function createScrollHandler(questionId) {
    return function () {
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
    return function (event) {
      var answerValue = event.target.type === "text" ? event.target.value : value;
      console.log(`🔥 [사용자 입력] questionId=${questionId}, answer="${answerValue}"`);

      // 이미 answers에 존재하면 업데이트, 없으면 새로 push
      var existing = answers.findIndex(a => a.questionId === questionId);
      if (existing !== -1) {
        answers[existing].answer = answerValue;
      } else {
        answers.push({ questionId: questionId, answer: answerValue });
      }
      console.log("🔥 [현재 저장된 답안 목록] answers =", JSON.stringify(answers, null, 2));

    };
  }

  function getTotalScore(questions) {
    return questions.reduce(function (total, q) {
      return total + (q.pointsAllocation || 0);
    }, 0);
  }

  // ========================
  // 3) 시험 타이머(remainingTime) + 서버 시간 보정 가능
  // ========================
  var remainingTime = 0;
  var timerInterval = null;

  function startTimer() {
    updateTimerDisplay();
    timerInterval = setInterval(function () {
      // 만약 서버와 동기화를 원한다면 아래 같이 할 수도 있음:
      // var serverNow = new Date().getTime() + timeOffset;
      // (ex: 남은 시간을 serverNow와 finishedAt 차이로도 계산)
      // 여기서는 단순 remainingTime-- 로직
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

  // ========================
  // 4) 시험 제출 로직
  // ========================
  document.getElementById("submit-exam").addEventListener("click", submitExam);

  function submitExam() {
    console.log("🔥 [시험 제출] API 요청 시작");

    if (answers.length === 0) {
      alert("답안을 제출하기 전에 문제를 확인하세요.");
      return;
    }

    var baseUrl = window.location.origin;
    var url = baseUrl+ "/api/exams/results/submit";

    var examResultReqDTO = {
      examResultVO: {
        resultId: examData.resultId,
        examId: examId,
        examineeId: examineeId
      },
      examResultMongoVO: {
        resultId: examData.resultId,
        answers: answers
      }
    };
    console.log("🔥 [시험 제출 데이터] 백엔드로 전송 직전 데이터:", JSON.stringify(examResultReqDTO, null, 2));


    fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(examResultReqDTO),
      credentials: "include"
    })
    .then(function (response) {
      if (!response.ok) {
        throw new Error("시험 제출 실패: " + response.status);
      }
      return response.json();
    })
    .then(function (data) {
      if (data.code === 200) {
        alert("시험이 성공적으로 제출되었습니다.");
        isExamSubmitted = true;
        clearInterval(autoSaveInterval); // 자동 저장 중단
        // 시험 제출 후 이동할 페이지
        window.location.href = "/";
      } else {
        alert("시험 제출 중 오류 발생.");
      }
    })
    .catch(function (error) {
      console.error("시험 제출 오류:", error);
      alert("시험 제출 중 에러가 발생했습니다.");
    });
  }

  function saveAnswers() {
    if (isExamSubmitted) {
      console.log("시험이 이미 제출됨. 자동 저장 중단.");
      return;
    }

    var url = window.location.origin + "/api/exams/results/answers";
    var examResultReqDTO = {
      examResultVO: {
        resultId: examData.resultId,
        examId: examId,
        examineeId: examineeId
      },
      examResultMongoVO: {
        resultId: examData.resultId,
        answers: answers  // 현재까지 입력한 답안들
      }
    };
    console.log("🔥 [시험 저장 데이터] 백엔드로 전송 직전 데이터:", JSON.stringify(examResultReqDTO, null, 2));

    fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(examResultReqDTO),
      credentials: "include"
    })
    .then(response => {
      if (!response.ok) throw new Error("답안 저장 실패: " + response.status);
      return response.json();
    })
    .then(data => {
      if (data.code === 200) {
        console.log("답안이 자동 저장되었습니다.");
      } else {
        console.warn("자동 저장 중 오류 발생.");
      }
    })
    .catch(error => {
      console.error("자동 저장 오류:", error);
    });
  }

  //3분마다 자동 저장
  function startAutoSave() {
    autoSaveInterval = setInterval(function () {
      console.log("[자동 저장] 3분마다 실행 중...");
      if (!isExamSubmitted) {
        saveAnswers();
      }
    }, 180000); // 3분마다 실행 (180,000ms)
  }

  // ========================
  // 5) onload 시점에 WebSocket 연결 + 시험 데이터 로딩
  // ========================
  window.onload = function () {
    connectWebSocket();  // STOMP 연결 + 구독
    loadExamData();      // 문제/시험 데이터 로딩
    startAutoSave();     // 3분마다 자동 저장 시작
  };

  // (B) 시험 알림 구독 추가
  stompClient.subscribe("/topic/exam/" + examId + "/notifications", function (msg) {
    var message = msg.body;
    var baseUrl = window.location.origin;

    alert("[시험공지] " + message);

    // 시험 종료 감지
    if (message.includes("시험이 종료되었습니다")) {
      alert("시험이 종료되었습니다. 자동 제출 후 메인 페이지로 이동합니다.");
      submitExam();
      setTimeout(() => {
        window.location.href = "/";
      }, 3000);
    }
  });

</script>
</body>
</html>
