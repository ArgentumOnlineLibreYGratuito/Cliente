import { translation } from "lang.js";

let frameElement = document.$('#main');
let subFrameElement;

// Load the sub-frame into the variable after the first frame finished to load
frameElement.on('complete', function() {
	subFrameElement = frameElement.frame.document.globalThis.document.$('#submain');
});

// Search translated messages from translation constant and returns them in the current loaded language
function getTranslatedMessage(key) {
    return translation[key] || key;
}

// Show's the error box
function globalShowError(frame, wrapper, messageKey) {
    const translatedMessage = getTranslatedMessage(messageKey);

    frame.$(wrapper).classList.add('error');
    frame.$(wrapper).firstElementChild.textContent = 'Error: ' + translatedMessage;
}

// MSGBOX - START
function showMsgbox(title, message) {
    let modalTitle = document.$('#msgbox_modal').firstElementChild.firstElementChild.firstElementChild;
    let modalDescription = document.$('#msgbox_modal').firstElementChild.firstElementChild.nextElementSibling;

    modalTitle.innerText = title;
    modalDescription.innerText = message;

    document.$('#msgbox_modal').classList.add('active');
    document.$('#master_modal').classList.add('active');
}

function closeMsgbox() {
    document.$('#msgbox_modal').classList.remove('active');
    document.$('#master_modal').classList.remove('active');
}
// MSGBOX - END

// Close the sub-frame globally
function closeSubmainBox() {
	subFrameElement.classList.remove('active');
}

// Change the window depending on the provided frame
function changeView(frame, view) {
	if (frame === '#submain') {
		subFrameElement.frame.loadFile(view);
	} else {
		frameElement.frame.loadFile(view);
	}
}

function setMainScreen(view) {
	changeView("#main", view);
}

function setAccountUsername(username) {
    frameElement.on('complete', function() {
	    frameElement.frame.document.$('.connect-wrapper .field input[name="account"]').value = username;
    });
}

function showAccountLoginError(message) {
    globalShowError(frameElement.frame.document, '.connect-wrapper .system', message);
    return;
}

function showAccountCreateError(message) {
    globalShowError(frameElement.frame.document, '.modal .create-account .wrapper .system', message);
    return;
}

function setLanguage(id) {
    setLang(id);
}

function setAttributesOnCharacterCreation(str, agi, int, chr, con) {
    // Change the attributes on the character creation Window
    frameElement.on('complete', function() {
        const STR = frameElement.frame.document.$('.dices span:nth-child(1)');
        const AGI = frameElement.frame.document.$('.dices span:nth-child(2)');
        const INT = frameElement.frame.document.$('.dices span:nth-child(3)');
        const CHR = frameElement.frame.document.$('.dices span:nth-child(4)');
        const CON = frameElement.frame.document.$('.dices span:nth-child(5)');

        STR.textContent = str;
        AGI.textContent = agi;
        INT.textContent = int;
        CHR.textContent = chr;
        CON.textContent = con;
    });
}

function isEmail(email) {
	return /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$/i.test(email);
}

// MAIN WINDOW - START
function getFP(number) {
    return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
}

function setExperience(current, total) {
    frameElement.on('complete', function() {
        const expPercentage = frameElement.frame.document.$('#exp_perc_value');
        const expText = frameElement.frame.document.$('#exp_value');
        const expBar = frameElement.frame.document.$('#exp_perc_bar');

        let currentExp = parseInt(current);
        let totalExp = parseInt(total);

        let barGraphWidth = 200;

        // Sets the text of the experience
        expText.textContent = `${getFP(currentExp)}/${getFP(totalExp)}`;

        // Sets the % of the graphic experience bar
        let finalCalc = ((currentExp / 100) / (totalExp / 100));
        let finalPercentage = (finalCalc * 100).toFixed(2);
        let finalBar = (finalCalc * barGraphWidth); // 200 is the width of the experience bar
        expPercentage.textContent = `[${finalPercentage}%]`;
        expBar.style.setProperty('width', finalBar);
    });
}

function setBar(current, total, barName) {
    frameElement.on('complete', function() {
        let currentVal = parseInt(current);
        let totalVal = parseInt(total);
        let currentBarGraph = frameElement.frame.document.$(`#${barName}_bar`);
        let currentBarText = frameElement.frame.document.$(`#${barName}_value`);

        let barGraphWidth = 110;

        let finalCalc = ((currentVal / 100) / (totalVal / 100));
        let finalBar = (finalCalc * barGraphWidth);

        currentBarText.textContent = `${getFP(currentVal)}/${getFP(totalVal)}`;
        currentBarGraph.style.setProperty('width', finalBar);
    });
}

function setCoords(map, x, y) {
    frameElement.on('complete', function() {
        let currentMap = parseInt(map);
        let currentX = parseInt(x);
        let currentY = parseInt(y);

        let coordinates = frameElement.frame.document.$('#coordinates');

        coordinates.textContent = `${currentMap} x: ${currentX} y: ${currentY}`;
    });
}

function setStr(amount) {
    frameElement.on('complete', function() {
        let currentAmount = parseInt(amount);

        const STR = frameElement.frame.document.$(`#str`);

        STR.textContent = currentAmount;
    });
}

function setAgi(amount) {
    frameElement.on('complete', function() {
        let currentAmount = parseInt(amount);

        const AGI = frameElement.frame.document.$(`#agi`);

        AGI.textContent = currentAmount;
    });
}

function setGold(amount) {
    frameElement.on('complete', function() {
        let currentAmount = parseInt(amount);

        const GOLD = frameElement.frame.document.$(`#gold_value`);

        GOLD.textContent = getFP(currentAmount);
    });
}

/*
    MISSING:
    -Set FPS
    -Set Nickname
    -Set Level
    -Set Macros On/Off (already made it with CSS but missing JS function)
*/

// Examples on how to use this functions
// setExperience(1130, 2000); // setExperience
// setBar(50, 100, 'stamina'); // setBar
// setCoords(1, 50, 50); // setCoords
// setStr(40); // setStr
// setAgi(40); // setAgi
// setGold(999999999); // setGold

// MAIN WINDOW - END

document.$('#msgbox_modal .msgbox .wrapper .header .mini-button').on('click', function() {
    closeMsgbox();
});

frameElement.on("document-created", function(event) {
    // Binds functions to the frame
    const newDocument = event.target;

	newDocument.globalThis.globalShowError = globalShowError;
    newDocument.globalThis.setAttributesOnCharacterCreation = setAttributesOnCharacterCreation;

    newDocument.globalThis.showMsgbox = showMsgbox;
    newDocument.globalThis.closeMsgbox = closeMsgbox;
	newDocument.globalThis.closeSubmainBox = closeSubmainBox;
    newDocument.globalThis.changeView = changeView;
    newDocument.globalThis.isEmail = isEmail;
});

globalThis.setMainScreen = setMainScreen;
globalThis.setAccountUsername = setAccountUsername;
globalThis.showAccountLoginError = showAccountLoginError;
globalThis.showAccountCreateError = showAccountCreateError;
globalThis.setLanguage = setLanguage;