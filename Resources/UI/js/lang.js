import * as sciter from "@sciter";

export let translation = {};
const translations = {};
let lang;

export function setLang(langName) {
    let update = !!lang;

    if(!(langName in translations)) {
       let t = sciter.import(`../langs/${langName}.js`)?.default;
       translations[langName] = t;
       translation = t;
    } else {
       translation = translations[langName];
    }

    document.attributes["lang"] = lang = langName;

    if(update) {
        for(let element of document.$$(".x"))
            element.translate();
    }
}

export function translate() {
    function translateElement(element) {
        let key = element.innerText;

        element.translate = () => {
            const newText = translation[key];
            if (newText) element.innerText = newText;
        };

        element.translate();
    }

    function translateAll() {
        const elements = document.querySelectorAll('.x');
        elements.forEach(translateElement);
    }

    if (this.classList.contains('x')) {
        translateElement(this);
    }

    translateAll();
}

setLang(document.attributes["lang"] || "spanish");