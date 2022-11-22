var main = {
    hWrap: null, // HTML main container
    option: null, // HTML answers wrapper


    init: () => {
        main.hWrap = document.getElementById("quizWrap");

        main.option = document.createElement("div");
        main.option.id = "quizAns";
        main.hWrap.appendChild(main.option);

        main.draw();
    },

    draw: () => {
        main.hQn.innerHTML = main.data[main.now].q;

        main.option.innerHTML = "";
        let radio = document.createElement("input");
            radio.type = "radio";
            radio.name = "quiz";
            radio.id = "quizo" + i;
        let label = document.createElement("label");
            label.innerHTML = quiz.data[quiz.now].o[i];
            label.setAttribute("for", "quizo" + i);
            label.dataset.idx = i;
            label.addEventListener("click", () => {
                window.location.replace("/quiz");;
            });
            quiz.hAns.appendChild(label);
    },

    reset: () => {
        main.now = 0;
        main.score = 0;
        main.draw();
    }
};

window.addEventListener("load", main.init);