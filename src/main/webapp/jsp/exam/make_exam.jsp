<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시험 문제 생성</title>
    <style>
      * { box-sizing: border-box; margin: 0; padding: 0; font-family: Arial, sans-serif; }
      body { display: flex; height: 100vh; }
      .sidebar { width: 250px; background: #f4f4f4; padding: 20px; overflow-y: auto; }
      .sidebar button { display: block; width: 85%; padding: 10px; margin: 5px 0; border: none; background: #ddd; cursor: pointer; text-align: left; }
      .sidebar button:hover { background: #bbb; }
      .delete-btn { background: red; color: white; border: none; cursor: pointer; padding: 5px 10px; float: right; }
      .content { flex: 1; padding: 20px; position: relative; }
      .load-exam-btn { position: absolute; top: 10px; right: 10px; padding: 8px 12px; background: #4CAF50; color: white; border: none; cursor: pointer; }
      .load-exam-btn:hover { background: #45a049; }
      label { display: block; margin: 10px 0 5px; }
      input, select, textarea { width: 100%; padding: 8px; margin-bottom: 10px; border: 1px solid #ccc; }
      .options-container { margin-bottom: 10px; }
      .option-input { display: flex; align-items: center; }
      .option-input input { flex: 1; margin-right: 5px; }
      .remove-btn { background: red; color: white; border: none; cursor: pointer; padding: 5px 10px; }
      .save-btn { background: blue; color: white; border: none; padding: 10px; width: 100%; margin-top: 10px; cursor: pointer; }
    </style>
</head>
<body>

<!-- 왼쪽: 문제 리스트 -->
<div class="sidebar" id="question-list">
    <h3>문제 목록</h3>
    <button onclick="addQuestion()">+ 문제 추가</button>
</div>

<!-- 오른쪽: 문제 생성 폼 -->
<div class="content">
    <h2>시험 문제 입력</h2>
    <button class="load-exam-btn" >기존 시험 불러오기</button>

    <label>문제 유형</label>

    <select id="question-type" onchange="toggleOptions()">
        <option value="multiple_choice">객관식</option>
        <option value="short_answer">주관식</option>
    </select>

    <label>문제 내용</label>
    <textarea id="question-content"></textarea>

    <label>점수</label>
    <input type="number" id="question-points" min="1">

    <label>정답</label>
    <input type="text" id="question-answer">

    <div id="options-section">
        <label>최대 보기 개수</label>
        <input type="number" id="max-options" min="2" max="10" value="4">
        <button onclick="addOption()">보기 추가</button>

        <div class="options-container" id="options-container"></div>
    </div>

    <button class="save-btn" onclick="saveQuestionsToStorage()">문제 저장</button>
    <button class="create-exam-btn" onclick="createExam()"> 시험 생성</button>

</div>

<script>
  // 기존 문제 유지
  let questions = [];
  let currentQuestionIndex = null;


  // 문제 추가
  function addQuestion() {
    let maxQuestionId = questions.length > 0 ? Math.max(...questions.map(q => q.questionId)) : 0;  // 기존 문제의 최대 questionId 찾기

    const newQuestion = {
      questionId: questions.length + 1,
      content: "",
      type: "multiple_choice",
      options: [],
      correctAnswer: "",
      pointsAllocation: 5,
      maxOptionsNum: 4
    };
    questions.push(newQuestion);
    renderQuestionList();
    loadQuestion(questions.length - 1);
  }

  // 문제 목록 표시 (삭제 버튼 포함)
  function renderQuestionList() {
    const questionList = document.getElementById("question-list");
    questionList.innerHTML = `<h3>문제 목록</h3><button onclick="addQuestion()">+ 문제 추가</button>`;

    questions.forEach((q, index) => {
      let item = document.createElement("div");
      item.className = "question-item";
      item.setAttribute("data-id", q.questionId); // 드래그 인식용 ID 추가

      let btn = document.createElement("button");
      btn.textContent = "문제 " + q.questionId;
      btn.onclick = () => loadQuestion(index);

      let deleteBtn = document.createElement("button");
      deleteBtn.textContent = "X";
      deleteBtn.className = "delete-btn";
      deleteBtn.onclick = (event) => {
        event.stopPropagation();
        deleteQuestion(index);
      };

      item.appendChild(btn);
      btn.appendChild(deleteBtn);
      questionList.appendChild(item);
    });
  }

  // 문제 삭제
  function deleteQuestion(index) {
    if (!confirm("정말 이 문제를 삭제하시겠습니까?")) return;
    questions.splice(index, 1);
    questions = questions.map((q, i) => ({ ...q, questionId: i + 1 })); // 다시 정렬
    renderQuestionList();
    if (questions.length > 0) {
      loadQuestion(0);
    } else {
      currentQuestionIndex = null;
      clearForm();
    }
  }

  // 선택한 문제 로드
  function loadQuestion(index) {
    if (currentQuestionIndex !== null) {  // ★ 현재 보고 있는 문제가 있다면 로컬로 담아두고(현재 작업 저장용)
      const currentQ = questions[currentQuestionIndex];
      currentQ.type = document.getElementById("question-type").value;
      currentQ.content = document.getElementById("question-content").value;
      currentQ.pointsAllocation = document.getElementById("question-points").value;
      currentQ.correctAnswer = document.getElementById("question-answer").value;

      // 객관식인 경우 보기와 최대 보기 수도 저장
      if (currentQ.type === "multiple_choice") {
        currentQ.maxOptionsNum = document.getElementById("max-options").value;
        // 모든 보기 input의 값을 배열로 저장
        currentQ.options = Array.from(document.getElementById("options-container").children)
        .map(div => div.querySelector('input').value)
        .filter(value => value.trim() !== ""); // 빈 값은 제외
      }
    }
    // 본격적으로 새로운 문제로 진입
    currentQuestionIndex = index;
    let q = questions[index];

    document.getElementById("question-type").value = q.type;
    document.getElementById("question-content").value = q.content;
    document.getElementById("question-points").value = q.pointsAllocation;
    document.getElementById("question-answer").value = q.correctAnswer;

    if (q.type === "multiple_choice") {
      document.getElementById("options-section").style.display = "block";
      document.getElementById("max-options").value = q.maxOptionsNum;
      renderOptions(q.options);
    } else {
      document.getElementById("options-section").style.display = "none";
    }
  }

  // 보기 추가 렌더링
  function renderOptions(options) {
    const container = document.getElementById("options-container");
    container.innerHTML = "";

    options.forEach(option => {
      let div = document.createElement("div");
      div.className = "option-input";

      let input = document.createElement("input");
      input.type = "text";
      input.value = option;  // 기존 보기 값 적용

      let btn = document.createElement("button");
      btn.textContent = "X";
      btn.className = "remove-btn";
      btn.onclick = () => container.removeChild(div);

      div.appendChild(input);
      div.appendChild(btn);
      container.appendChild(div);
    });
  }

  // 보기 추가
  function addOption() {
    const container = document.getElementById("options-container");
    const maxOptions = parseInt(document.getElementById("max-options").value, 10) || 4;

    if (container.children.length >= maxOptions) {
      alert(`최대 ${maxOptions}개의 보기만 추가할 수 있습니다.`);
      return;
    }

    let div = document.createElement("div");
    div.className = "option-input";
    let input = document.createElement("input");
    input.type = "text";
    let btn = document.createElement("button");
    btn.textContent = "X";
    btn.className = "remove-btn";
    btn.onclick = () => container.removeChild(div);

    div.appendChild(input);
    div.appendChild(btn);
    container.appendChild(div);
  }

  // LocalStorage 저장
  function saveToLocalStorage() {
    localStorage.setItem("questions", JSON.stringify(questions));
  }

  // 시험 문제 저장 (DB에 저장)
  function saveExamSheet() {
    let apiUrl = "/api/exams/questions?examId=" + examId;
    fetch(apiUrl , {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(questions)
    })
    .then(() => alert("시험지가 저장되었습니다!"))
    .catch(error => console.error("시험지 저장 오류:", error));
  }



  function loadMultipleExams(examIds) {
    if (!Array.isArray(examIds)) {
      examIds = [examIds]; // 단일 examId도 배열로 변환
    }


    let newQuestions = [...questions];
    let maxQuestionId = newQuestions.length > 0 ? Math.max(...newQuestions.map(q => q.questionId)) : 0;

    examIds.forEach(examId => {
      let apiUrl = "/api/exams/questions?examId=" + examId;

      fetch(apiUrl)
      .then(response => response.json())
      .then(data => {
        console.log("서버 응답 데이터:", data);

        if (data.code === 200 && data.data) {
          data.data.forEach(question => {
            maxQuestionId++;
            // 객관식 문제일 경우 `options` 처리 (빈 배열 초기화)
            let optionsArray = Array.isArray(question.options) ? question.options : [];

            newQuestions.push({
              questionId: maxQuestionId,
              content: question.content,
              type: question.type,
              options: optionsArray,
              correctAnswer: question.correctAnswer,
              pointsAllocation: question.pointsAllocation
            });
          });
          questions = newQuestions; // 문제 리스트 업데이트
          renderQuestionList();
        } else {
          throw new Error("데이터가 없습니다. 응답 확인 필요:", data);
        }
      })
      .catch(error => console.error(`시험 ${examId} 불러오기 오류:`, error));
    });
  }


  function enableDragAndDrop() {
    new Sortable(document.getElementById("question-list"), {
      animation: 150,
      onEnd: function (event) {
        console.log("변경 전 questions:", JSON.parse(JSON.stringify(questions)));
        let sortedItems = [...document.getElementById("question-list").querySelectorAll(".question-item")];
        console.log("정렬된 순서의 ID들:", sortedItems.map(item => item.getAttribute("data-id")));
        questions = sortedItems.map((item, index) => {
          let id = parseInt(item.getAttribute("data-id"), 10);
          let question = questions.find(q => q.questionId === id);
          return { ...question, questionId: index + 1 }; // ID 재정렬
        });
        console.log("변경 후 questions:", JSON.parse(JSON.stringify(questions)));
        renderQuestionList(); // 여기서 다시 정리하므로 복제되는 문제 해결
      }
    });
  }

  // SessionStorage에 저장 (브라우저 닫으면 삭제됨)
  function saveToSessionStorage() {
    sessionStorage.setItem('examQuestions', JSON.stringify(questions));
  }


  // 객관식 선택 시 보기 개수 제한 설정
  function toggleOptions() {
    let questionType = document.getElementById("question-type").value;
    let optionsSection = document.getElementById("options-section");

    if (questionType === "multiple_choice") {
      optionsSection.style.display = "block";
    } else {
      optionsSection.style.display = "none";
    }
  }

  // 문제를 LocalStorage에 저장
  function saveQuestionsToStorage() {
    localStorage.setItem("examQuestions", JSON.stringify(questions));
    console.log(" 문제 임시 저장됨 (LocalStorage)");
  }

  // 문제 불러오기 (LocalStorage에서 가져옴)
  function loadQuestionsFromStorage() {
    let storedQuestions = JSON.parse(localStorage.getItem("examQuestions")) || [];
    if (storedQuestions.length > 0) {
      console.log("저장된 문제 불러옴");
      questions = storedQuestions;
      renderQuestionList();
    }
  }

  // 페이지 벗어날 때 LocalStorage 데이터 삭제
  window.addEventListener("beforeunload", function () {
    console.log("페이지 나감 → 문제 데이터 삭제");
    localStorage.removeItem("examQuestions");
  });




  // 시험 불러오기 버튼
  document.querySelector(".load-exam-btn").addEventListener("click", function () {
    let examId = prompt("불러올 시험 ID를 입력하세요:");

    if (!examId || isNaN(examId)) {
      alert("올바른 시험 ID를 입력하세요.");
      return;
    }

    loadMultipleExams([parseInt(examId)]);
  });

  // 페이지 로드 시 초기화
  document.addEventListener("DOMContentLoaded", function () {
    const urlParams = new URLSearchParams(window.location.search);
    let examId = urlParams.get("examId");

    if (!examId) {
      examId = 40; // todo URL에 없을 때만 테스트용 (지워야함)
    }
    if (examId) {
      loadMultipleExams([parseInt(examId)]);
    }

    loadQuestionsFromStorage()
    enableDragAndDrop();
    toggleOptions();
  });



</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Sortable/1.14.0/Sortable.min.js"></script>


</body>
</html>
