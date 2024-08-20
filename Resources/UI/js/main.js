document.on('ready', function() {

    let frameElement = document.$('#submain'); // Frame where you're going to load all the sub-main windows like options, worldmap, etc

    document.addEventListener('keydown', function(event) {
        // Show / hide console
        if (event.code === 'Enter') {
            if (Window.WINDOW_SHOWN == 1 || Window.WINDOW_FULL_SCREEN == 1) {
                let chat = document.$('input[name="chat"]');

                // Enables the chat
                if (chat.disabled === true) {
                    chat.disabled = false;
                    chat.state.focus = true;
                    
                } else {
                // Disables the chat
                    chat.disabled = true;
                    
                    // Missing: call to send the text to the server

                    chat.value = null; // clean the chat
                }
            }
        }
    });

    document.$('body').addEventListener('click', function(event) {
        // Switch between inventory / spells
        if (event.target.id === 'inv_inventory' || event.target.id === 'sp_inventory') {
            let inventory = document.$('.inventory .items');
            let spells = document.$('.inventory .spells');

            if (spells.classList.contains('active')) {
                spells.classList.remove('active');
                inventory.classList.add('active');
            }
        }

        if (event.target.id === 'inv_spells' || event.target.id === 'sp_spells') {
            let inventory = document.$('.inventory .items');
            let spells = document.$('.inventory .spells');

            if (inventory.classList.contains('active')) {
                inventory.classList.remove('active');
                spells.classList.add('active');
            }
        }
    });

    // Commented because worldmap.html doesn't exist
    // document.$('#map').on('click', function() {
    //     // Worldmap modal window load
    //     frameElement.classList.add('active');

    //     changeView('#submain', 'worldmap.html');
    // });

    // Commented because options.html doesn't exist
    // document.$('#options').on('click', function() {
    //     // Options modal window load
    //     frameElement.classList.add('active');

    //     changeView('#submain', 'options.html');
    // });

    // Trying to imitate spell control of vb6 - Start
    let isMouseDown = false;
    let isScrolling = false;
    let scrollDirection = 0; // 0: no scroll, 1: scroll up, -1: scroll down
    let selectedElement = null;
    let shouldMarkOnMouseUp = false;

    const spellList = document.querySelector('.spell-list');

    spellList.addEventListener('mousedown', (event) => {
        isMouseDown = true;
        selectedElement = event.target.closest('li');
        handleLiClick(selectedElement);
        shouldMarkOnMouseUp = true;
    });

    document.addEventListener('mouseup', (event) => {
        isMouseDown = false;
        isScrolling = false;
        scrollDirection = 0;

        shouldMarkOnMouseUp = false;

        selectedElement = null;
    });

    function throttle(func, delay) {
        let lastTime = 0;

        return function (...args) {
            const now = new Date();

            if (now - lastTime >= delay) {
                func(...args);
                lastTime = now;
            }
        };
    }

    // Throttle the mousemove event
    document.addEventListener('mousemove', throttle((event) => {
        if (isMouseDown) {
            const list = spellList;
            const mouseY = event.clientY;
            const listRect = list.getBoundingClientRect();
    
            if (mouseY < listRect.top + 15) {
                // Scroll up
                scrollDirection = 1;
            } else if (mouseY > listRect.bottom - 15) {
                // Scroll down
                scrollDirection = -1;
            } else {
                // Not scrolling if the mouse is within the list
                scrollDirection = 0;
            }
    
            if (scrollDirection !== 0) {
                isScrolling = true;
                scrollList(list, scrollDirection);
            }

            // Mark the nearest element as selected only when moving the mouse with the click
            const listItems = document.querySelectorAll('.spell-list li');
            const nearestElement = findNearestElement(listItems, event.clientY);
            handleLiClick(nearestElement);
            selectedElement = nearestElement;
        }
    }, 16));

    function findNearestElement(elements, mouseY) {
        let nearestElement = null;
        let minDistance = Infinity;
    
        elements.forEach((item) => {
            const rect = item.getBoundingClientRect();
            const distance = Math.abs(rect.top + rect.height / 2 - mouseY);
    
            if (distance < minDistance) {
                minDistance = distance;
                nearestElement = item;
            }
        });
    
        return nearestElement;
    }

    function scrollList(list, direction) {
        const scrollAmount = 1;
    
        function scroll() {
            if (direction === 1 && list.scrollTop > 0) {
                list.scrollTop -= scrollAmount;
            } else if (direction === -1 && list.scrollTop < list.scrollHeight - list.clientHeight) {
                list.scrollTop += scrollAmount;
            }
    
            if (isScrolling) {
                requestAnimationFrame(scroll);
            } else {
                markFirstOrLast();
            }
        }
    
        requestAnimationFrame(scroll);
    }

    function markFirstOrLast() {
        const listItems = document.querySelectorAll('.spell-list li');
    
        if (!listItems.length) {
            return;
        }
    
        const observer = new IntersectionObserver(
            (entries) => {
                const visibleEntries = entries.filter((entry) => entry.isIntersecting);
                if (visibleEntries.length > 0) {
                    // Mark the first visible element as selected
                    handleLiClick(visibleEntries[0].target);
                }
            },
            { threshold: 0.5 }
        );
    
        listItems.forEach((item) => {
            observer.observe(item);
        });
    }

    function handleLiClick(target) {
        const selectedElement = document.querySelector('.spell-list li.selected');

        if (selectedElement) {
            selectedElement.classList.remove('selected');
        }

        if (target) {
            target.classList.add('selected');
        }
    }
    // Trying to imitate spell control of vb6 - End

});