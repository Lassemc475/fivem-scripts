$(document).ready(function () {
  window.addEventListener('message', function (event) {
    var item = event.data;
    if (item.open == true) {
      openMenu();
    }
    if (item.open == false) {
      closeMenu();
    }
  });
  document.onkeyup = function (data) {
    if (data.which == 27) {
      $.post('http://lmc_scratch/close', JSON.stringify({}));

    }
  };

});

function openMenu() {
  $(".container").fadeIn();
  openHome();

  var win = 'vinder.png';
  var lose = 'tab.png';
  randomNumber = Math.floor(Math.random() * 100);

  if (randomNumber < 1) {
    background = win
  } else {
    background = lose
  }

    $("#promo").remove();
    $('.scratch-container').append('<div id="promo" class="scratchpad"></div>');
  $('#promo').wScratchPad({
    size        : 50,
    bg:  background,
    realtime    : true,
    fg: 'overlay.png',

    scratchMove: function (e, percent) {
        if ((percent > 80) && (background == win)) {
          $.post('http://lmc_scratch/vinder', JSON.stringify({}));
        };
    }
  });

}
function closeMenu() {
  $(".container").fadeOut();
  $("#home").css("display", "none");
}

function openHome() {
  $("#home").css("display", "block");
}
