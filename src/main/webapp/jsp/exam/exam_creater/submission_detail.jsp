<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/submission_detail.css">
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
    var examId = ${examId};
    var examineeId = ${examineeId};
    var resultId = ${resultId};
    var questions = [];
    var isCorrect = [];
    var answers = [];
    // 이전 제출 답변 저장 (키: questionId, 값: 사용자의 답변)

    // 시험 데이터 불러오기
    function loadExamData() {
        var examUrl = "http://localhost:8088/api/exams/results/" + examId + "/exam-data" + examineeId;
        var answersUrl = "http://localhost:8088/api/exams/results/" + examId + "/" + resultId + "/details";

        console.log("시험 데이터 요청 URL:", examUrl);
        console.log("사용자 제출 답변 요청 URL:", answersUrl);

        fetch(examUrl)
            .then(response => response.json())
            .then(examData => {
                if (examData.code == 200) {
                    console.log(examData); // 각 문항별 정답 : examData.questions[i].correctAnswer
                    questions = examData.data.questions;
                    renderExam(examData.data);
                    examData.data.answers.forEach(answer => { // 오류 발생 가능 submittedAnswers -> answers
                        answers.push(answer.answer);
                    });


                    return fetch(answersUrl); // ✅ resultId = 21 응답 데이터 가져오기
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

                    markAnswers(); // ✅ 기존 답변 자동 입력
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

    function markAnswers() {
        // questions 배열의 길이를 가져옴
        var numberOfQuestions = questions.length;

        for (var i = 0; i < numberOfQuestions; i++) {
            var questionId = i + 1; // questionId는 1부터 시작하므로 i + 1

            var input = document.getElementById("answer-" + questionId);
            if (input) {
                input.value = answers[i] || ""; // 주관식: 사용자가 제출한 답변 표시
                input.disabled = true; // 수정 불가
            }

            var questionDiv = document.getElementById("question-" + questionId);
            if (questionDiv) {
                var statusIcon = document.createElement("span");
                statusIcon.style.marginLeft = "10px";
                statusIcon.style.fontWeight = "bold";
                statusIcon.style.color = isCorrect[i] === "정답" ? "green" : "red";
                statusIcon.textContent = isCorrect[i] === "정답" ? "✔" : "✘";
                questionDiv.appendChild(statusIcon);

                // 정답을 표시할 input 요소 추가
                if (isCorrect[i] === "오답") {
                    var correctAnswerInput = document.createElement("input");
                    correctAnswerInput.type = "text";
                    correctAnswerInput.value = questions[i].correctAnswer; // 정답 가져오기
                    correctAnswerInput.disabled = true; // 수정 불가
                    correctAnswerInput.style.backgroundColor = "#f8d7da"; // 틀린 문제 강조
                    correctAnswerInput.style.color = "red"; // 색상 설정
                    correctAnswerInput.style.width = "600px"; // 너비 조정 (300px로 설정, 필요에 따라 조정 가능)// 여백 추가 (선택 사항)

                    questionDiv.appendChild(correctAnswerInput); // 정답 input 추가
                }
            }

            // 객관식 문제 자동 체크
            var selectedOption = answers[i]; // 사용자가 제출한 값
            var radioButtons = document.getElementsByName("answer-" + questionId);
            if (radioButtons) {
                radioButtons.forEach(radio => {
                    if (radio.value === selectedOption) {
                        radio.checked = true; // 사용자가 제출한 값과 일치하는 라디오 버튼 체크
                    }
                });
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

    function renderMultipleChoiceOptions(question, container) {
        question.options.forEach(option => {
            var label = document.createElement("label");
            var radio = document.createElement("input");
            radio.type = "radio";
            radio.name = "answer-" + question.questionId; // ✅ 같은 문제의 라디오 버튼은 같은 name 속성
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
</script>
</body>
</html>
