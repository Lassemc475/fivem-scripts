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
      $.post('http://lmc_bugreport/close', JSON.stringify({}));
    }
  };


  $(".sendReport").click(function () {
    var discord = document.getElementById("discord").value;
    var id = document.getElementById("id").value;
    var description = document.getElementById("description").value;
    var bug = document.getElementById("bug").value;
    if (discord == "" || id == "" || description == "" || bug == "") {
      console.log("fejl")
    }
    else {
      data = [discord,id,description,bug];
      $.post('http://lmc_bugreport/sendReport', JSON.stringify({data}));
    }
  });

});




function openHome() {
  $("body").css("display", "block");
}

function close() {
  $("body").css("display", "none");
}
