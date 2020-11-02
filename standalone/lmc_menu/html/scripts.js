$(document).ready(function () {
  window.addEventListener('message', function (event) {
    var item = event.data;
    if (item.show == true) {
      openHome();
    }
    if (item.show == false) {
      close();
    }

  });
  document.onkeyup = function (data) {
    if (data.which == 27) {
      $.post('http://lmc_menu/close', JSON.stringify({}));
    }
  };


  $(".button1").click(function () {
    $.post('http://lmc_menu/button1', JSON.stringify({}));
  });

  $(".button2").click(function () {
    $.post('http://lmc_menu/button2', JSON.stringify({}));
  });

  $(".button3").click(function () {
    $.post('http://lmc_menu/button3', JSON.stringify({}));
  });

  $(".button4").click(function () {
    $.post('http://lmc_menu/button4', JSON.stringify({}));
  });

});

function openHome() {
  $("body").css("display", "block");
}

function close() {
  $("body").css("display", "none");
}
