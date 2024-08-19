document.on('ready', function() {

    let barText = document.querySelector('.window .wrapper .centered .bar-wrapper .description');
    let loadingBar = document.querySelector('.window .wrapper .centered .bar-wrapper .bar');

    barText.textContent = 'Now its changed'; // Example on how to change the text
    loadingBar.style.width = '100%'; // Example on how to change the % value of the bar

});