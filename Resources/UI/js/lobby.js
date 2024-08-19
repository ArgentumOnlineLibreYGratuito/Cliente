document.on('ready', function() {

    function enableButtons() {
        document.$('#connect_character').state.disabled = false;
        document.$('#delete_character').state.disabled = false;
    }

    function disableButtons() {
        document.$('#connect_character').state.disabled = true;
        document.$('#delete_character').state.disabled = true;
    }

    // Mark character as selected
    document.on('click', '.char', function(e, t) {
        let allChars = document.querySelectorAll('.char');

        allChars.forEach(function(char) {
            char.classList.remove('selected');
        });

        t.classList.add('selected');
        enableButtons();
    });

    // Open delete character modal
    document.on('click', '#delete_character', function() {
        let currentChar = document.querySelector('.selected');
        
        if(currentChar !== null) {
            let currentCharName = currentChar.firstElementChild.nextElementSibling.innerHTML;

            document.$('.modal .del-char p b').textContent = currentCharName;
            document.$('.modal .del-char').classList.add('active');
            document.$('.modal').classList.add('active');
        } else {
            return;
        }
    });

    // Close delete character modal
    document.$('.modal .del-char .wrapper .header .mini-button').on('click', function() {
        document.$('.modal .del-char input[name="password"]').value = '';

        document.$('.modal .del-char .system').classList.remove('error');
        document.$('.modal .del-char .system p').textContent = '';
    
        document.$('.del-char').classList.remove('active');
        document.$('.modal').classList.remove('active');
    });

    // Delete character button action
    document.$('#delete_character_confirm').on('click', function() {
        const charId = document.$('.char.selected input[name="char_id"]').value;
        const password = document.$('.modal .del-char input[name="password"]').value;
        
        if (password.length === 0) {
            globalShowError(document, '.modal .del-char .wrapper .system', 'account_error_empty_fields');
            return;
        }

        // Missing: check if the password is the real account password or not
    
        // Window.this.xcall('', username, email, password, token);
    });

    // Logout button action
    document.$('#logout').on('click', function() {
        Window.this.xcall('onLobbyExit');
    });



});