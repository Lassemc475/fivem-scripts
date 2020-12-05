var historyOpen = false;
var reports = [];
var currentID = false;
window.addEventListener("message", function (event) {
    let action = event.data.action;
    let data = event.data.data;

    if (action == 'new') {
        AddReport(data)
    } else if (action == 'history') {
        ShowHistory()
    } else if (action == 'error') {
        AddError(data);
    } else if (action == 'info') {
        AddInfo(data);
    } else if (action == 'delete') {
        reports[data] = undefined;
    } else if (action == 'open') {
        if (reports[data]) {
            MoreInfo(data);
        } else {
            AddError("Ugyldigt case nummer.");
        }
    }


})

function HideHistory() {
    historyOpen = false;
    $('#reports').fadeIn(500);
    $('#history').fadeOut(500);

    $.post("http://vrp_reports/closeNUI"); 
}

function ShowHistory() {
    $('#history').html("<div class='title' style='background-color: rgba(0, 0, 30, 0.40); padding-right: 15px;  padding-left: 15px; font-size: 18px; color: white;'>Case History</div>");

    for (i = reports.length; i != 0; i--) {
        var $history = $(document.createElement('div'));
        var data = reports[i];

        if(data && data.report) {
            var msg = data.text.length < 40 ? data.text : data.text.slice(0, 40) + '...';

            $history.html("<div class='report'><div class='title'>Case #" + data.report + " - " + data.name + " (" + data.id + ")</div>\
            <p class='info'>" + msg + "</h1>\
            <div class='options'>\
            <i class='fas fa-backward' style='color: white; position: relative; margin-left: 5px;' onclick='BringPlayer(" + data.id + ")'></i>\
            <i class='fas fa-forward' style='color: white; position: relative; margin-left: 5px;' class='option' onclick='GotoPlayer(" + data.id + ")'></i>\
            <i class='fas fa-info-circle' style='color: white; position: relative; margin-left: 5px;' class='option' onclick='MoreInfo(" + data.report + ")'></i>\
            </div></div>");
    
            $('#history').append($history);
        }
    }

    if(reports.length == 0) {
        var $history = $(document.createElement('div'));
        $history.html("<div class='report'><div class='title'>Info</div>\<p class='info'>Der er ingen cases</h1>\</div>");
        $('#history').append($history);
    }

    historyOpen = true;
    $('#reports').fadeOut(500);
    $('#history').fadeIn(500);
}

window.addEventListener("keyup", function (key) {
    if (key.which === 27) {
        if (historyOpen == true) {
            HideHistory();
        }

        if (currentID != false) {
            CloseInfo();
        }
    }
})

function AddInfo(msg) {
    var $error = $(document.createElement('div'));

    $error.html("<div class='report'><div class='title''>Cases</div>\
    <p class='info'>" + msg + "</h1>\
    </div></div>");

    $('#reports').append($error);

    setTimeout(() => {
        $error.fadeOut(500);
    }, 8000)
}

function AddError(msg) {
    var $error = $(document.createElement('div'));

    $error.html("<div class='report'><div class='title' style='color: red;'>Cases</div>\
    <p class='info'>" + msg + "</h1>\
    </div></div>");

    $('#reports').append($error);

    setTimeout(() => {
        $error.fadeOut(500);
    }, 8000)
}

function AddReport(data) {
    reports[data.report] = data;
    var $report = $(document.createElement('div'));
    var msg = data.text.length < 40 ? data.text : data.text.slice(0, 40) + '...';

    var html = "<div class='report'><div class='title'>Case #" + data.report + " - " + data.name + " (" + data.id + ")</div>\
    <p class='info'>" + msg + "</h1>\
    <div class='options'>\
    <i class='fas fa-backward' style='color: white; position: relative; margin-left: 5px;' onclick='BringPlayer(" + data.id + ")'></i>\
    <i class='fas fa-forward' style='color: white; position: relative; margin-left: 5px;' class='option' onclick='GotoPlayer(" + data.id + ")'></i>\
    <i class='fas fa-info-circle' style='color: white; position: relative; margin-left: 5px;' class='option' onclick='MoreInfo(" + data.report + ")'></i>\
    </div></div>"

    $report.html(html);

    $('#reports').append($report);

    console.log(reports.length);
    setTimeout(() => {
        $report.fadeOut(500);
    }, 8000)
}

function BringPlayer(id) {
    $.post('http://vrp_reports/bring', JSON.stringify({
        player: id
    }));
}

function GotoPlayer(id) {
    $.post('http://vrp_reports/goto', JSON.stringify({
     player: id
    }));
}

function MoreInfo(reportID) {
    $.post("http://vrp_reports/openNUI");

    dragElement('info');
    currentID = reportID;
    var report = reports[currentID];
    $.post('http://vrp_reports/GetInfo', JSON.stringify({
        player: report.id,
        timer: report.timer,
    }), function(data) {
        var html = "<div class='title2'>Case #" + currentID + "</div>\
        <div class='info-options'>\
            <button type='button' class='info-option' onclick='BringPlayer(" + report.id + ")'>Bring</button>\
            <button type='button' class='info-option' onclick='GotoPlayer(" + report.id + ")'>TP til</button>\
            <button type='button' class='info-option' style='color:red;' onclick='DeleteReport(" + report.report + ")'>Slet</button>\
        </div><div class='info-player'>\
        <i class='far fa-clock'></i><i> " + report.time + " (" + data[3] + ")</i></br>\
        <i class='fas fa-file-signature'></i><i> " + report.name + " (" + report.userid + ")</i></br>\
        <i class='fab fa-discord'></i><i> " + report.discord + "</i></br>\
        <i class='far fa-comment-dots'></i><i> " + report.text + "</i></br>\
        <i class='fas fa-road'></i><i> " + data[2] + "</i></br>\
        <i class='" + data[0][0] + "'></i><i> " + data[0][1] + "</i></br>\
        </div></div>"
    
    
        $('#info').html(html);
        $('#info').fadeIn(500);
        
        $('#reports').fadeOut(500);
        $('#history').fadeOut(500);
    
        historyOpen = false;
    });
}

function DeleteReport(reportID) {
    $.post('http://vrp_reports/delete', JSON.stringify({
        report: reportID
    }));

    CloseInfo();
}

function CloseInfo() {

    $('#info').fadeOut(500);

    $('#reports').fadeIn(500);
    $('#history').fadeOut(500);

    currentID = false;

    $.post("http://vrp_reports/closeNUI");
}

function dragElement(id) {
    var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
    var elmnt = document.getElementById(id);
    elmnt.onmousedown = dragMouseDown;
  
    function dragMouseDown(e) {
      e = e || window.event;
      e.preventDefault();
      pos3 = e.clientX;
      pos4 = e.clientY;
      document.onmouseup = closeDragElement;
      document.onmousemove = elementDrag;
    }
  
    function elementDrag(e) {
      e = e || window.event;
      e.preventDefault();
      pos1 = pos3 - e.clientX;
      pos2 = pos4 - e.clientY;
      pos3 = e.clientX;
      pos4 = e.clientY;
      elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
      elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
    }

    function closeDragElement() {
        // stop moving when mouse button is released:
        document.onmouseup = null;
        document.onmousemove = null;
      }
}
