document.on('ready',function() {
    const GENDER_SELECT = document.querySelector('select[name="gender"]');
    const RACE_SELECT = document.querySelector('select[name="race"]');
    const CLASS_SELECT = document.querySelector('select[name="class"]');
    const BACK_BUTTON = document.getElementById('new_character_cancel');
    const THROW_DICES_BUTTON = document.getElementById('new_character_throw_dices');
    const CREATE_BUTTON = document.getElementById('new_character_create');

    let charGender = -1;
    let charRace = -1;
    let charClass = -1;

    function raceBonus(race) {
        const stats = document.querySelectorAll('.dices span');
        const classesToRemove = ['plus', 'minus'];
        const raceModifiers = {
            0: { STR: 'plus', AGI: 'plus', CON: 'plus' }, // Human
            1: { STR: 'minus', AGI: 'plus', INT: 'plus', CHR: 'plus', CON: 'plus' }, // Elf
            2: { STR: 'plus', AGI: 'plus', INT: 'plus', CHR: 'minus' }, // Dark Elf
            3: { STR: 'plus', AGI: 'minus', INT: 'minus', CHR: 'minus', CON: 'plus' }, // Dwarf
            4: { STR: 'minus', AGI: 'plus', INT: 'plus', CHR: 'plus' } // Gnome
        };
    
        // Remove all plus and minus classes
        stats.forEach(stat => {
            classesToRemove.forEach(cls => stat.classList.remove(cls));
        });
    
        // Add appropriate classes based on the race
        const selectedModifiers = raceModifiers[race] || {};
        Object.keys(selectedModifiers).forEach((stat, index) => {
            if (selectedModifiers[stat]) {
                stats[index].classList.add(selectedModifiers[stat]);
            }
        });
    }

    // Gender selection change action
    // Why click? because we want to be able to select the first auto-selected option
    GENDER_SELECT.addEventListener('input', function() {
        charGender = parseInt(this.value);
    });

    // Race selection change action
    // Why click? because we want to be able to select the first auto-selected option
    RACE_SELECT.addEventListener('input', function() {
        charRace = parseInt(this.value);

        raceBonus(charRace);
    });

    raceBonus(RACE_SELECT.value); // Auto-run the function for the first selection

    // Class selection change action
    // Why click? because we want to be able to select the first auto-selected option
    CLASS_SELECT.addEventListener('input', function() {
        charClass = parseInt(this.value);
    });
    
    // Back button action
    BACK_BUTTON.addEventListener('click', function() {
        // Window.this.xcall('');
    });

    // Throw dices action
    THROW_DICES_BUTTON.addEventListener('click', function() {
        // Window.this.xcall('');
    });

    // Create character button action
    CREATE_BUTTON.addEventListener('click', function() {
        const charName = document.$('input[name="newchar_name"]').value;
        const charEmail = document.$('input[name="newchar_email"]').value;
        const charPwd = document.$('input[name="newchar_pwd"]').value;

        document.$('.char .box .system').classList.remove('error');
        document.$('.char .box .system p').textContent = '';

        if (charName.length === 0 || charEmail.length === 0 || charPwd.length === 0) {
            globalShowError(document, '.char .box .system', 'character_create_error_empty_fields');
            return;
        }

        if (!isEmail(charEmail)) {
            globalShowError(document, '.char .box .system', 'character_create_error_invalid_email');
            return;
        }

        /*
        if (EMAIL_ALREADY_IN_USE) {
            globalShowError(document, '.char .box .system', 'character_create_error_email_already_used');
            return;
        }

        if (NICKNAME_ALREADY_IN_USE) {
            globalShowError(document, '.char .box .system', 'character_create_error_name_already_used');
            return;
        }
        */

        if (charGender < 0) {
            globalShowError(document, '.char .box .system', 'character_create_empty_gender');
            return;
        }

        if (charRace < 0) {
            globalShowError(document, '.char .box .system', 'character_create_empty_race');
            return;
        }

        if (charClass < 0) {
            globalShowError(document, '.char .box .system', 'character_create_empty_class');
            return;
        }

        // Insert more verifications here (?)

        // Window.this.xcall('');
    });

});