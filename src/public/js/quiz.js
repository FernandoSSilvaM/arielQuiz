// Final Project: Quiz Application with Microservices
// Date: 28-Nov-2022
// Authors:
//          A01746925 Fernando Sebastian Silva Miramontes
//          A01377205 Jose Luis Mata Lomelí

// [{
//     q: "What is the standard distance between t|he target and archer in Olympics?",
//     o: [
//         "50 meters",
//         "correct",
//         "100 meters",
//         "120 meters"
//     ],

//     a: 1
// }]



var quiz = {

    data: [],
    quests: [],

    hWrap: null, // HTML quiz container
    hQn: null, // HTML question wrapper
    hAns: null, // HTML answers wrapper

    now: 0, // current question
    score: 0, // current score

    init: () => {
        quiz.hWrap = document.getElementById("quizWrap");

        quiz.hQn = document.createElement("div");
        quiz.hQn.id = "quizQn";
        quiz.hWrap.appendChild(quiz.hQn);

        quiz.hAns = document.createElement("div");
        quiz.hAns.id = "quizAns";
        quiz.hWrap.appendChild(quiz.hAns);
        quiz.quests = getQuests(quiz.data)

        quiz.draw();
        x = 0/0
    },

    draw: () => {

        quiz.hQn.innerHTML = quiz.quests[quiz.now].q;

        quiz.hAns.innerHTML = "";
        for (let i in quiz.quests[quiz.now].o) {
            let radio = document.createElement("input");
            radio.type = "radio";
            radio.name = "quiz";
            radio.id = "quizo" + i;
            quiz.hAns.appendChild(radio);
            let label = document.createElement("label");
            label.innerHTML = quiz.quests[quiz.now].o[i];
            label.setAttribute("for", "quizo" + i);
            label.dataset.idx = i;
            label.addEventListener("click", () => {
                quiz.select(label);
            });
            quiz.hAns.appendChild(label);
        }
    },

    select: option => {
        let all = quiz.hAns.getElementsByTagName("label");
        for (let label of all) {
            label.removeEventListener("click", quiz.select);
        }

        let correct = option.dataset.idx == quiz.quests[quiz.now].a;
        if (correct) {
            quiz.score++;
            option.classList.add("correct");
        } else {
            option.classList.add("wrong");
        }

        quiz.now++;
        setTimeout(() => {
            if (quiz.now < quiz.quests.length) {
                quiz.draw();
            } else {
                quiz.hQn.innerHTML = `You have answered ${quiz.score} of ${quiz.quests.length} correctly.`;
                quiz.hAns.innerHTML = "";

                let text = document.createElement("input");
                    text.type = "text";
                    text.name = "menu";
                    text.id = "menu";
                    text.placeholder = "nickname"
                quiz.hAns.appendChild(text);

                let radio2 = document.createElement("input");
                radio2.type = "radio";
                radio2.name = "quiz";
                radio2.id = "quizo";
                quiz.hAns.appendChild(radio2);
                let label2 = document.createElement("label");
                label2.innerHTML = 'Ver Puntajes';
                label2.setAttribute("for", "quizo");
                label2.addEventListener("click", () => {
                    let origin = window.location.origin;
                    console.log(origin)
                    fetch(origin + '/scores', {
                        method: "POST",
                        headers: { "Content-Type": "application/json" },
                        body: JSON.stringify({ "nombre": "fer", "score": quiz.score })
                    }).then(raw => raw.json)
                      .then(data => console.log(data));
                    //window.location.replace("/scores");
                });
                quiz.hAns.appendChild(label2);
            }
        }, 1000);
    },
    reset: () => {
        quiz.now = 0;
        quiz.score = 0;
        quiz.draw();
    }
};

fetch("/js/questions.json")
            .then(response => response.json())
            .then(data => quiz.data = data)
            .catch(err => {
                console.log("Error Reading data " + err);

            });

function getRandomInt(max) {
    return Math.floor(Math.random() * max);
}

function getQuests(data){
    //length sabado = 9
    let path = window.location.pathname;
    var parm = parseInt(path.slice(6))
    var seed = []
    var ret = []

    for (let i = 0; i < parm; i++) {
        let isAdded = false
        while(!isAdded){
            let n = getRandomInt(50)
            if(!seed.includes(n)) {
                seed.push(n)
                isAdded = true
            }
        }
    }
    seed.forEach(i => {
        ret.push(data[i])
    });

    return ret
}


window.addEventListener("load", quiz.init);