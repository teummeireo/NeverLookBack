<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/my_exam_detail.css">
  <title>시험 응시</title>
  <style>
    .modal {
      display: none;
      position: fixed;
      z-index: 1000;
      left: 50%;
      top: 50%;
      transform: translate(-50%, -50%);
      width: 40%;
      max-width: 500px;
      background-color: #fff;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
      border-radius: 8px;
      overflow: hidden;
    }

    .modal-content {
      padding: 20px;
      text-align: center;
    }

    .modal-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 10px 20px;
      background-color: #f8f9fa;
      border-bottom: 1px solid #ddd;
    }

    .modal-header h3 {
      margin: 0;
      font-size: 1.2em;
    }

    .close {
      font-size: 24px;
      cursor: pointer;
      transition: color 0.2s;
    }

    .close:hover {
      color: red;
    }

    .modal-body {
      padding: 20px;
    }

    .modal-body textarea {
      width: 100%;
      height: 100px;
      padding: 10px;
      border-radius: 5px;
      border: 1px solid #ccc;
      font-size: 1em;
      resize: none;
    }

    .modal-footer {
      padding: 15px;
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      background-color: #f8f9fa;
      border-top: 1px solid #ddd;
    }

    .modal-footer button {
      padding: 8px 15px;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      font-size: 1em;
      transition: background-color 0.2s;
    }

    .modal-footer .cancel {
      background-color: #ccc;
    }

    .modal-footer .cancel:hover {
      background-color: #bbb;
    }

    .modal-footer .submit {
      background-color: #007bff;
      color: white;
    }

    .modal-footer .submit:hover {
      background-color: #0056b3;
    }

    .dispute-section {
      background-color: #f8d7da;
      border-left: 5px solid red;
      padding: 10px;
      margin-top: 10px;
      border-radius: 5px;
    }

    .dispute-comment {
      font-size: 1em;
      color: #721c24;
      font-weight: bold;
    }

    .admin-reply {
      font-size: 0.9em;
      color: blue;
      margin-top: 5px;
      margin-left: 15px;
    }

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

  <div id="dispute-modal" class="modal">
    <div class="modal-content">
      <span class="close" onclick="closeDisputeModal()">&times;</span>
      <h3>이의 제기</h3>
      <textarea id="dispute-text" placeholder="이의 제기 내용을 입력하세요..."></textarea>
      <button onclick="submitDispute()">제출</button>
    </div>
  </div>
  <div id="reply-modal" class="modal">
    <div class="modal-content">
      <span class="close" onclick="closeReplyModal()">&times;</span>
      <h3>답변 추가</h3>
      <textarea id="reply-text" placeholder="답변을 입력하세요..."></textarea>
      <button onclick="submitReply()">제출</button>
    </div>
  </div>


</div>

<script>
  var urlParams = new URLSearchParams(window.location.search);
  var examId = Number(urlParams.get("examId")) || "75";  // examId 가져오기
  var examineeId = Number(urlParams.get("examineeId")) ||30;
  if(examId ==0 || examineeId==0 ){
    var examId = "${examId}";
    var examineeId = "${examineeId}";
  }
  var resultId;   // 불러올 시험 결과 ID
  var questions = [];
  var isCorrect = [];
  var answers = [];
  // 이전 제출 답변 저장 (키: questionId, 값: 사용자의 답변)
  console.log("ExamineeID 체크@@  = " + examineeId);

  // 시험 데이터 불러오기
  function loadExamData() {
    var baseUrl = window.location.origin;
    var examUrl = baseUrl+ "/api/exams/results/" + examId + "/exam-data/" + examineeId;
    console.log("시험 데이터 요청 URL:", examUrl);

    fetch(examUrl)
            .then(response => response.json())
            .then(examData => {
              if (examData.code == 200) {
                console.log(examData); // 각 문항별 정답 : examData.questions[i].correctAnswer
                questions = examData.data.questions;
                resultId = examData.data.resultId;
                examineeId = examData.data.examineeID !== undefined ? examData.data.examineeID : examineeId;
                renderExam(examData.data);
                examData.data.answers.forEach(answer => {
                  answers.push(answer.answer);
                });

                answers = examData.data.answers;  // 객체 배열 그대로 저장 !!
                console.log("변환 후 answers:", answers);

                var answersUrl = baseUrl+ "/api/exams/results/" + examId + "/" + resultId + "/details";
                console.log("사용자 제출 답변 요청 URL:", answersUrl);

                return fetch(answersUrl);
              } else {
                throw new Error("시험 데이터를 불러오는 중 오류 발생");
              }
            })
            .then(response => response.json())
            .then(answerData => {
              if (answerData.code == 200) {
                answerData.data.resultDetails.forEach(detail => {
                  isCorrect[detail.questionId - 1] = detail.correct ? "정답" : "오답"; // 정답 여부를 저장
                });
                console.log(isCorrect);
                console.log(answers);

                markAnswers(); // 기존 답변 자동 입력
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






  function createScrollHandler(questionId) {
    return function () {
      var questionElement = document.getElementById("question-" + questionId);
      if (questionElement) {
        questionElement.scrollIntoView({ behavior: "smooth" });
      }
    };
  }

  function renderMultipleChoiceOptions(question, container) {
    question.options.forEach(option => {
      var label = document.createElement("label");
      var radio = document.createElement("input");
      radio.type = "radio";
      radio.name = "answer-" + question.questionId; // 같은 문제의 라디오 버튼은 같은 name 속성
      radio.value = option;
      radio.disabled = true;  // 기존 답변이므로 수정 불가

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
    input.disabled = true; // 수정 불가

    container.appendChild(input);
  }

  document.getElementById("submit-exam").addEventListener("click", function() {
    console.log("시험 결과 확인 완료");
    this.disabled = true;
  });

  loadExamData();

  // // // // // // // //

  function markAnswers() {
    var numberOfQuestions = questions.length;

    for (var i = 0; i < numberOfQuestions; i++) {
      var questionId = i + 1;

      var input = document.getElementById("answer-" + questionId);
      if (input) {
        input.value = answers[i].answer || "";
        input.disabled = true;
      }

      var questionDiv = document.getElementById("question-" + questionId);
      if (questionDiv) {
        var statusIcon = document.createElement("span");
        statusIcon.style.marginLeft = "10px";
        statusIcon.style.fontWeight = "bold";
        statusIcon.style.color = isCorrect[i] === "정답" ? "green" : "red";
        statusIcon.textContent = isCorrect[i] === "정답" ? "✔" : "✘";
        questionDiv.appendChild(statusIcon);

        if (isCorrect[i] === "오답") {
          var correctAnswerInput = document.createElement("input");
          correctAnswerInput.type = "text";
          correctAnswerInput.value = questions[i].correctAnswer;
          correctAnswerInput.disabled = true;
          correctAnswerInput.style.backgroundColor = "#f8d7da";
          correctAnswerInput.style.color = "red";
          correctAnswerInput.style.width = "600px";
          questionDiv.appendChild(correctAnswerInput);

          // "이의 제기" 버튼 추가
          var disputeButton = document.createElement("button");
          disputeButton.textContent = "이의 제기";
          disputeButton.className = "dispute-btn";
          disputeButton.onclick = (function(qId) {  // 눌린 번호가 이의 제기 되도록 모달로 들고가야함!!!
            return function() {
              openDisputeModal(qId);
            };
          })(questionId);
          questionDiv.appendChild(disputeButton);
        }

        // 이의제기 및 답변 표시 로직 추가
        if (answers[i] && answers[i].isObjection) {
          var disputeSection = document.createElement("div");
          disputeSection.className = "dispute-section";

          // 이의제기 내용 표시
          var disputeComment = document.createElement("p");
          disputeComment.className = "dispute-comment";
          disputeComment.textContent = "이의제기: " + answers[i].objectionComments;
          disputeSection.appendChild(disputeComment);

          // 관리자 답변이 있는 경우 표시
          if (answers[i].objectionReply) {
            var adminReply = document.createElement("p");
            adminReply.className = "admin-reply";
            adminReply.textContent = "관리자 답변: " + answers[i].objectionReply;
            disputeSection.appendChild(adminReply);
          }

          questionDiv.appendChild(disputeSection);
        }
      }

      // 객관식 문제 자동 체크
      var selectedOption = answers[i].answer;
      var radioButtons = document.getElementsByName("answer-" + questionId);
      if (radioButtons) {
        radioButtons.forEach(radio => {
          if (radio.value === selectedOption) {
            radio.checked = true;
            radio.disabled = true;
          }
        });

      }
    }
  }

  var selectedQuestionId;

  function openDisputeModal(questionId) {
    // 모달 열기 전에 입력값 초기화
    document.getElementById("dispute-text").value = "";
    // questionId를 기반으로 배열에서 index 찾기
    console.log("questionID 는 " + questionId);
    var questionIndex = questions.findIndex(q => q.questionId === questionId);
    console.log("quesetionIndex는"+questionIndex);
    // questionIndex를 통해 MongoDB의 실제 questionId 가져오기
    selectedQuestionId = questionId;
    console.log("그냥 questionID" + selectedQuestionId);
    selectedQuestionId = questions[questionIndex].questionId;
    console.log("questions[questionIndex].,questionID" + selectedQuestionId);
    document.getElementById("dispute-modal").style.display = "block";
  }

  function closeDisputeModal() {
    document.getElementById("dispute-modal").style.display = "none";
  }

  function submitDispute() {
    var questionIndex = selectedQuestionId - 1;  // 문제 순서는 1부터 시작, 배열 인덱스는 0부터 시작
    var mongoQuestionId = questions[questionIndex].questionId; // MongoDB의 실제 questionId 가져오기

    var disputeText = document.getElementById("dispute-text").value;
    if (!disputeText) {
      alert("이의 제기 내용을 입력하세요.");
      return;
    }

    var baseUrl = window.location.origin;
    var disputeUrl = baseUrl + "/api/exams/results/" + examId + "/dispute?questionId=" + mongoQuestionId;

    console.log("ExamineeID 체크 in submitDisputre  = " + examineeId);

    fetch(disputeUrl, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json"
      },

      body: JSON.stringify({
        examineeId: examineeId,
        questionId: mongoQuestionId,
        objection: disputeText})
    })
            .then(response => response.json())
            .then(data => {
              if (data.code === 200) {
                alert("이의 제기가 성공적으로 제출되었습니다.");
                // 화면 업데이트 - answers 배열 업데이트
                let answer = answers.find(a => a.questionId === mongoQuestionId);
                if (answer) {
                  answer.isObjection = true;
                  answer.objectionComments = disputeText;
                }
                // 즉시 화면 갱신
                renderDisputeSection(document.getElementById("question-" + mongoQuestionId), mongoQuestionId, disputeText, []);
                updateDisputeSection(mongoQuestionId, disputeText);
                loadExamData();  // 데이터 다시 불러와서 즉시 반영
                closeDisputeModal();
              } else {
                alert("이의 제기 실패: " + data.msg);
              }
            })
            .catch(error => console.error("이의 제기 요청 실패:", error));
  }



  function renderDisputeSection(questionDiv, questionId, disputeText, replies) {
    var disputeSection = document.createElement("div");
    disputeSection.className = "dispute-section";

    var disputeComment = document.createElement("p");
    disputeComment.textContent = "이의 제기: " + disputeText;
    disputeSection.appendChild(disputeComment);

    // 기존 이의제기 버튼을 생성해야 참조할 수 있음
    var disputeButton = document.createElement("button");
    disputeButton.textContent = "답변 추가";
    disputeButton.onclick = function() {
      openReplyModal(questionId);
    };

    disputeSection.appendChild(disputeButton);


    replies.forEach(reply => {
      var replyComment = document.createElement("p");
      replyComment.textContent = "답변: " + reply;
      replyComment.style.marginLeft = "20px";
      replyComment.style.color = "blue";
      disputeSection.appendChild(replyComment);
    });

    var replyButton = document.createElement("button");
    replyButton.textContent = "답변 추가";
    disputeButton.onclick = (function(qId) {  // 눌린 번호가 이의 제기 되도록 모달로 들고가야함!!!
      return function() {
        openDisputeModal(qId);
      };
    })(questionId);
    disputeSection.appendChild(replyButton);

    questionDiv.appendChild(disputeSection);
  }

  function updateDisputeSection(questionId, disputeText) {
    var questionDiv = document.getElementById("question-" + questionId);
    if (!questionDiv) return;

    // 기존 이의제기 섹션이 있다면 삭제
    var existingDisputeSection = questionDiv.querySelector(".dispute-section");
    if (existingDisputeSection) {
      existingDisputeSection.remove();
    }

    // 새 이의제기 섹션 추가
    var disputeSection = document.createElement("div");
    disputeSection.className = "dispute-section";

    var disputeComment = document.createElement("p");
    disputeComment.className = "dispute-comment";
    disputeComment.textContent = "이의제기: " + disputeText;
    disputeSection.appendChild(disputeComment);

    questionDiv.appendChild(disputeSection);
  }


  var selectedQuestionIdForReply;

  function openReplyModal(questionId) {
    selectedQuestionIdForReply = questionId;
    document.getElementById("reply-modal").style.display = "block";
  }

  function closeReplyModal() {
    document.getElementById("reply-modal").style.display = "none";
  }

  function submitReply() {
    var questionIndex = selectedQuestionId - 1;  // 문제 순서는 1부터 시작, 배열 인덱스는 0부터 시작
    var mongoQuestionId = questions[questionIndex].questionId; // MongoDB의 실제 questionId 가져오기

    var replyText = document.getElementById("reply-text").value;
    if (!replyText) {
      alert("답변 내용을 입력하세요.");
      return;
    }

    var baseUrl = window.location.origin;
    var replyUrl = baseUrl + "/api/exams/results/" + examId + "/dispute-reply?questionId=" + mongoQuestionId;

    fetch(replyUrl, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        examineeId: examineeId,
        questionId: mongoQuestionId,
        objection: replyText })
    })
            .then(response => response.json())
            .then(data => {
              if (data.code === 200) {
                alert("답변이 성공적으로 추가되었습니다.");
                closeReplyModal();
              } else {
                alert("답변 추가 실패: " + data.msg);
              }
            })
            .catch(error => console.error("답변 추가 요청 실패:", error));
  }



</script>

</body>
</html>
