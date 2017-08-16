window.onload = function(){
    fetch("https://p76q6sy9r5.execute-api.ap-northeast-1.amazonaws.com/api/status", {
        method: "get",
        mode: 'cors'
    }).then(function (response) {
        if (response.status === 200) {
            console.log(response.statusText); // => "OK"
        } else {
            console.log(response.statusText); // => Error Message
        }
        return response.json();
    }).then(function (json){
        console.log(json);
        status = json.state.reported.status;
        var t = document.getElementById(status);
        if (t) {
            var statusWithColor = {IN: '#FF0000', OUT: '#00FF00'};
            t.style.display = 'inherit';
            document.getElementById("loading").style.display = 'none';
            document.body.style.backgroundColor = statusWithColor[status];
            document.getElementById("updated_at").textContent = "最終更新 : " + new Date(json.timestamp * 1000);
        }
    }).catch(function (response) {
        console.log(response); // => "TypeError: ~"
    });
}
