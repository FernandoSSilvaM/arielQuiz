var main = {
    hWrap: null,
    option: null, 


    init: () => {
        main.hWrap = document.getElementById("quizWrap");

        main.option = document.createElement("div");
        main.option.id = "quizAns";
        main.hWrap.appendChild(main.option);

        main.draw();
    },

    draw: () => {
        main.option.innerHTML = "";

        let number = document.createElement('output');
            number.id = "sliderVal";
            number.innerHTML = "Cantidad de pregutas: " + 5;



        let slider = document.createElement('input');
            slider.id = "questions";
            slider.class = "sliders"
            slider.type = 'range';

            slider.min = 1;
            slider.max = 10;
            slider.value = 5;
            slider.step = 1;
            slider.oninput = function() {
                  number.innerHTML = "Cantidad de pregutas: " + this.value;
                }

        main.option.appendChild(slider);
        main.option.appendChild(number);


        let radio = document.createElement("input");
            radio.type = "radio";
            radio.name = "quiz";
            radio.id = "quizo";
            main.option.appendChild(radio);
        let label = document.createElement("label");
            label.innerHTML = "QUIZ";
            label.setAttribute("for", "quizo");
            label.addEventListener("click", () => {
                window.location.replace("/quiz/" + slider.value);
            });


        main.option.appendChild(label);

        let radio2 = document.createElement("input");
            radio2.type = "radio";
            radio2.name = "scores";
            radio2.id = "scoreso";
            main.option.appendChild(radio2);
        let label2 = document.createElement("label");
            label2.innerHTML = "PUNTAJES";
            label2.setAttribute("for", "quizo");
            label2.addEventListener("click", () => {
                window.location.replace("/scores");;
            });
        main.option.appendChild(label2);

    },

    reset: () => {
        main.draw();
    }
};

window.addEventListener("load", main.init);