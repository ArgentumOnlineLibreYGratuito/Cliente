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
    // Checks for child elements and translate them
    if (this.children.length > 0) {
        for(let child of this.children) {
            let childKey = child.innerText;

            child.translate = () => {
                let childNewText = translation[childKey];
                if(childNewText) child.innerText = childNewText;
            }

            child.translate();
        }

        this.children[0].click(); // Hack to re-paint the translated child
    }

    let key = this.innerText;

    this.translate = () => {
        const newText = translation[key];
        if(newText) this.innerText = newText;
    }

    this.translate();
}

setLang(document.attributes["lang"] || "spanish");