<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시험 문제 생성</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/create_exam.css">
</head>
<body>
<!--
    /**
     * 주요 스크립트 개요:
     * 1) 문제 관리
     *    - addQuestion(): 새 문제 추가
     *    - deleteQuestion(): 문제 삭제
     *    - renderQuestionList(): 문제 목록을 사이드바에 표시
     *    - loadQuestion(): 선택된 문제를 오른쪽 폼에 로드
     *    - clearForm(): 폼 초기화
     *    - updateCurrentQuestion(): 현재 편집 중인 문제를 업데이트
     *
     * 2) 객관식 보기 관리
     *    - addOption(): 객관식 보기 추가
     *    - renderOptions(): 기존 보기를 폼에 렌더링
     *
     * 3) 데이터 저장 및 불러오기
     *    - saveToLocalStorage(): LocalStorage에 저장
     *    - loadQuestionsFromStorage(): LocalStorage에서 문제 불러오기
     *    - saveExamSheet(): 시험 문제를 서버(DB)에 저장
     *    - loadMultipleExams(): 여러 시험(examId)의 문제를 서버에서 불러오기
     *
     * 4) 기타 UI 기능
     *    - toggleOptions(): 문제 유형에 따른 UI 토글 (객관식/주관식)
     *    - enableDragAndDrop(): Sortable.js를 이용한 드래그 앤 드롭 활성화
     *    - initializeEventListeners(): 이벤트 리스너 초기화
     */
-->

<!-- 왼쪽: 문제 리스트 -->
<div class="sidebar" id="question-list">
    <h3>문제 목록</h3>
    <button onclick="addQuestion()">+ 문제 추가</button>
</div>
<!-- 오른쪽: 문제 생성 폼 -->
<div class="content">
    <h2>시험 문제 입력</h2>
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
    <div class="exam-actions">
        <button class="exam-btn load-exam-btn">기존 시험 불러오기</button>
        <button class="exam-btn create-exam-btn" onclick="saveExamSheet()">데이터 입력</button>
    </div>
</div>
<script>
    // 전역 배열: 모든 문제를 담아두는 리스트
    // currentQuestionIndex: 현재 오른쪽 폼에 로드된 문제의 인덱스
    let questions = [];
    let currentQuestionIndex = null;
    // 문제 추가
    function addQuestion() {
        // questionId를 1부터 시작, 기존 questions 배열에서 최대 questionId를 찾거나 0
        let maxQuestionId = questions.length > 0 ? Math.max(...questions.map(q => q.questionId)) : 0;  // 기존 문제의 최대 questionId 찾기
        // 새 문제 객체 생성
        // 기본으로 객관식으로 설정 (type: multiple_choice), 점수 5점, 보기 최대 4개
        const newQuestion = {
            questionId: questions.length + 1,
            content: "",
            type: "multiple_choice",
            options: [],
            correctAnswer: "",
            pointsAllocation: 5,
            maxOptionsNum: 4
        };
        // 배열에 추가
        questions.push(newQuestion);
        // 문제 목록 다시 그려주기
        renderQuestionList();
        // 방금 추가한 문제를 로드하여 즉시 편집할 수 있게 함
        loadQuestion(questions.length - 1);
    }

    // 문제 목록을 sidebar에 표시
    function renderQuestionList() {
        // question-list 영역을 가져와서 내부를 초기화
        const questionList = document.getElementById("question-list");
        questionList.innerHTML = `<h3>문제 목록</h3><button onclick="addQuestion()">+ 문제 추가</button>`;
        // questions 배열을 순회하며 문제 버튼 생성
        questions.forEach((q, index) => {
            let item = document.createElement("div");
            item.className = "question-item";
            item.setAttribute("data-id", q.questionId);
            // drag & drop 시에 문제 ID를 식별하기 위해 data-id 속성을 추가

            // 문제 제목을 표시하는 버튼
            let btn = document.createElement("button");
            btn.textContent = "문제 " + q.questionId;
            btn.onclick = () => loadQuestion(index);
            // 버튼 클릭하면 해당 문제를 오른쪽 폼에 로드

            // 문제 삭제 버튼 (빨간 X 표시)
            let deleteBtn = document.createElement("button");
            deleteBtn.textContent = "X";
            deleteBtn.className = "delete-btn";
            deleteBtn.onclick = (event) => {
            // 삭제 버튼 누르면 문제 삭제 실행
                // 이벤트 전파 막기 (문제 로드 클릭 방지)
                event.stopPropagation();
                deleteQuestion(index);
            };
            // 삭제 버튼을 문제 버튼에 끼워넣고, 문제 item을 리스트에 추가
            item.appendChild(btn);
            btn.appendChild(deleteBtn);
            questionList.appendChild(item);
        });
    }
    function deleteQuestion(index) {
        if (!confirm("정말 이 문제를 삭제하시겠습니까?")) return;

        console.log("삭제 전 currentQuestionIndex:", currentQuestionIndex);
        console.log("삭제하려는 index:", index);

        // 현재 편집 중인 문제의 변경사항을 저장
        if (currentQuestionIndex !== null) {
            updateCurrentQuestion();
        }
        // 문제 삭제
        questions.splice(index, 1);
        // 문제 ID 재할당
        questions.forEach((q, i) => {
            q.questionId = i + 1;
        });
        console.log("questions 배열 길이:", questions.length);
        // 삭제 후 적절한 인덱스 선택
        if (questions.length > 0) {
            // 삭제한 인덱스가 배열 길이보다 크거나 같으면 마지막 인덱스로 설정
            let newIndex = index >= questions.length ? questions.length - 1 : index;
            console.log("새로 선택된 인덱스:", newIndex);
            // currentQuestionIndex 업데이트 전에 폼 초기화
            //clearForm();
            // 새 인덱스로 currentQuestionIndex 업데이트
            currentQuestionIndex = newIndex;
            // 새로운 문제 로드
            loadQuestion(newIndex);
        } else {
            // 문제가 없는 경우
            currentQuestionIndex = null;
            clearForm();
        }

        // 문제 목록 다시 렌더링
        renderQuestionList();

        console.log("삭제 후 currentQuestionIndex:", currentQuestionIndex);
    }

    // 폼초기화
    function clearForm() {
        document.getElementById("question-type").value = "short_answer";
        document.getElementById("question-content").value = "";
        document.getElementById("question-points").value = "";
        document.getElementById("question-answer").value = "";
        document.getElementById("max-options").value = 4;
        document.getElementById("options-container").innerHTML = "";
        document.getElementById("options-section").style.display = "none";
    }

    function updateCurrentQuestion() {
        if (currentQuestionIndex === null) return;

        const currentQ = questions[currentQuestionIndex];

        // 🔹 현재 폼 데이터를 가져와서 questions 배열에 저장
        currentQ.type = document.getElementById("question-type").value;
        currentQ.content = document.getElementById("question-content").value.trim();
        currentQ.pointsAllocation = parseInt(document.getElementById("question-points").value, 10) || 0;
        currentQ.correctAnswer = document.getElementById("question-answer").value.trim();

        if (currentQ.type === "multiple_choice") {
            currentQ.maxOptionsNum = parseInt(document.getElementById("max-options").value, 10) || 4;
            currentQ.options = Array.from(document.getElementById("options-container").children)
                .map(div => div.querySelector('input').value.trim())
                .filter(value => value !== ""); // 빈 값 제거
        }
    }


    // 선택된 문제를 폼에 불러오기
    function loadQuestion(index) {
        console.log("loadQuestion 호출됨 - index:", index);
        console.log("현재 questions 배열 길이:", questions.length);

        // 유효하지 않은 인덱스 체크
        if (index === null || index < 0 || index >= questions.length) {
            console.warn("유효하지 않은 인덱스:", index);
            clearForm();
            currentQuestionIndex = null;
            return;
        }
        // 문제 데이터 가져오기
        let q = questions[index];
        if (!q) {
            console.error("문제를 찾을 수 없음:", index);
            clearForm();
            currentQuestionIndex = null;
            return;
        }
        // currentQuestionIndex 업데이트
        currentQuestionIndex = index;
        // 폼에 데이터 설정
        document.getElementById("question-type").value = q.type || "multiple_choice";
        document.getElementById("question-content").value = q.content || "";
        document.getElementById("question-points").value = q.pointsAllocation || "";
        document.getElementById("question-answer").value = q.correctAnswer || "";
        // 객관식 문제 처리
        if (q.type === "multiple_choice") {
            document.getElementById("options-section").style.display = "block";
            document.getElementById("max-options").value = q.maxOptionsNum || 4;
            renderOptions(Array.isArray(q.options) ? q.options : []);
        } else {
            document.getElementById("options-section").style.display = "none";
        }

        console.log("문제 로드 완료 - ID:", q.questionId);
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
            // 보기 삭제 버튼
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
        // 최대보기제한
        if (container.children.length >= maxOptions) {
            alert(`최대 ${maxOptions}개의 보기만 추가할 수 있습니다.`);
            return;
        }
        let div = document.createElement("div");  //새 보기 생성
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
        if (currentQuestionIndex === null) return;  // 선택된 문제 없으면 리턴

        const currentQ = questions[currentQuestionIndex];
        currentQ.type = document.getElementById("question-type").value;
        currentQ.content = document.getElementById("question-content").value.trim();
        currentQ.pointsAllocation = parseInt(document.getElementById("question-points").value, 10) || 0;
        currentQ.correctAnswer = document.getElementById("question-answer").value.trim();

        // 객관식 문제 처리
        if (currentQ.type === "multiple_choice") {
            currentQ.maxOptionsNum = parseInt(document.getElementById("max-options").value, 10) || 4;
            currentQ.options = Array.from(document.getElementById("options-container").children)
                .map(div => div.querySelector('input').value.trim())
                .filter(value => value !== ""); // 빈 값 제거
        }

        // URL에서 examId 가져오기 //todo 지금은 테스트로 40
        const urlParams = new URLSearchParams(window.location.search);
        //let examId = urlParams.get("examId") || 40;
        let examId = ${examId};
        if (!examId || isNaN(examId)) {
            alert("시험 ID가 올바르지 않습니다.");
            return;
        }

        // 서버에 저장할 데이터 구조 점검
        const sanitizedQuestions = questions.map(q => ({
            questionId: q.questionId,
            content: q.content.trim(),
            type: q.type,
            options: Array.isArray(q.options) ? q.options.filter(opt => opt.trim() !== "") : [],
            correctAnswer: q.correctAnswer.trim(),
            pointsAllocation: parseInt(q.pointsAllocation, 10) || 0,
            maxOptionsNum: parseInt(q.maxOptionsNum, 10) || 4,
            maxAnswerLength: 0
        }));

        let apiUrl = "/api/exams/questions?examId=" + examId;

        fetch(apiUrl, {
            method: "PUT",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(sanitizedQuestions)
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP 오류! 상태 코드: ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                if (data.code === 200) {
                    alert(`시험지가 성공적으로 저장되었습니다! (업데이트된 개수: ${data.data})`);
                    location.href = '/exams/created';
                } else {
                    throw new Error("서버 응답 오류: " + JSON.stringify(data));
                }
            })
            .catch(error => {
                console.error("시험지 저장 오류:", error);
                alert("시험지 저장 중 오류가 발생했습니다: " + error.message);
            });
    }

    // 여러 시험(examId)의 문제를 불러오는 함수
    function loadMultipleExams(examIds) {
        if (!Array.isArray(examIds)) {
            examIds = [examIds]; // 단일 examId도 배열로 변환
        }
        // 기존 questions를 카피, 이전 최대 인덱스 밑으로 추가하게 인덱스 수정
        let newQuestions = [...questions];
        let maxQuestionId = newQuestions.length > 0 ? Math.max(...newQuestions.map(q => q.questionId)) : 0;
        // examIds 배열을 순회하며 각 시험의 문제를 불러옴
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
                        // 불러온 전체 리스트를 questions에 반영 후, 목록 재렌더링
                        questions = newQuestions;
                        renderQuestionList();
                    } else {
                        throw new Error("데이터가 없습니다. 응답 확인 필요:", data);
                    }
                })
                .catch(error => console.error(`시험 ${examId} 불러오기 오류:`, error));
        });
    }

    // 문제 순서 변경 드래그 함수
    function enableDragAndDrop() {
        new Sortable(document.getElementById("question-list"), {
            animation: 150,
            group: {
                name: 'questionGroup',
                pull: 'move',  // clone이 아닌 실제 이동
                put: 'move'
            },
            onEnd: function (event) {
                // 1. 기존 문제 배열을 깊은 복사 (완전히 새로운 객체 생성)
                let oldQuestions = questions.map(q => ({...q,
                    options: [...q.options] // 객관식 문제의 선택지 배열까지 복사
                }));
                // 현재 DOM에서 정렬된 문제 목록을 읽어옴
                const sortedItems = [...document.getElementById("question-list").querySelectorAll(".question-item")];
                // 새 배열을 생성하여 순서 변경
                let reordered = sortedItems.map((item, index) => {
                    let id = parseInt(item.getAttribute("data-id"), 10);
                    let foundIndex = oldQuestions.findIndex(q => q.questionId === id);
                    if (foundIndex === -1) {console.error(`문제 ID ${id}를 찾을 수 없음`);
                        return null;}
                    // 새로운 문제 객체를 생성하여 ID를 변경 (기존 참조 유지 X)
                    return {...oldQuestions[foundIndex], questionId: index + 1};
                }).filter(q => q !== null); // 존재하지 않는 문제 제거

                // 새로 정렬된 문제 배열을 기존 questions에 반영
                questions = reordered;
                // 현재 편집 인덱스 무효화, 폼 클리어
                currentQuestionIndex = null;
                clearForm();
                // 문제 목록을 다시 렌더링
                renderQuestionList();
            }
        });
    }
    // 객관식 선택 시에만 보기 개수 표기
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

    // 페이지 로드 시 초기화에 추가 (DOMContentLoaded 이벤트 핸들러 내부에)
    function initializeEventListeners() {
        // 문제 내용
        document.getElementById("question-content").addEventListener("input", () => {
            updateCurrentQuestion();
            saveToLocalStorage();
        });

        // 문제 유형
        document.getElementById("question-type").addEventListener("change", () => {
            updateCurrentQuestion();
            saveToLocalStorage();
            toggleOptions();
        });

        // 점수
        document.getElementById("question-points").addEventListener("input", () => {
            updateCurrentQuestion();
            saveToLocalStorage();
        });

        // 정답
        document.getElementById("question-answer").addEventListener("input", () => {
            updateCurrentQuestion();
            saveToLocalStorage();
        });

        // 최대 보기 개수
        document.getElementById("max-options").addEventListener("input", () => {
            updateCurrentQuestion();
            saveToLocalStorage();
        });

        // 객관식 보기들의 변경 감지를 위한 이벤트 위임
        document.getElementById("options-container").addEventListener("input", (e) => {
            if (e.target.tagName === "INPUT") {
                updateCurrentQuestion();
                saveToLocalStorage();
            }
        });
    }

    // 페이지가 닫히거나 새로 고침하기 직전에 저장된 examQuestions를 제거
    // 의도적으로 임시 저장 데이터만 유지하고자
    window.addEventListener("beforeunload", function () {
        console.log("페이지 나감 → 문제 데이터 삭제");
        localStorage.removeItem("examQuestions");
    });
    // 시험 불러오기 버튼 이벤트 리스너
    document.querySelector(".load-exam-btn").addEventListener("click", function () {
        let examId = prompt("불러올 시험 ID를 입력하세요:");
        if (!examId || isNaN(examId)) {
            alert("올바른 시험 ID를 입력하세요.");
            return;}
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
        initializeEventListeners();
        loadQuestionsFromStorage()
        enableDragAndDrop();
        toggleOptions();
    });

    //입력하는 내용들 로컬 스토리지로 임시 저장
    document.getElementById("question-content").addEventListener("input", () => {
        updateCurrentQuestion();
        saveToLocalStorage();
    });

    window.addEventListener("beforeunload", function () {
        console.log("페이지 나감 → 문제 데이터 삭제");
        localStorage.removeItem("examQuestions");
    });

    // select 태그에 'change' 이벤트 리스너 추가
    document.getElementById("question-type").addEventListener("change", () => {
        updateCurrentQuestion();
        saveToLocalStorage();
        toggleOptions();
    });


</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Sortable/1.14.0/Sortable.min.js"></script>
</body>
</html>