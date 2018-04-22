<%@ page import="utils.AlertManager" %>
<%@ page import="utils.FileManager" %>
<%@ page import="java.io.File" %>

<%
    int slideCount = 10;
    int halfSlide = 5;

    String email = (String) session.getAttribute("email");
    String userUpload = null;
    File imagesDir = null;
    File[] images = null;

    try {
        userUpload = FileManager.getDirPath_UserUpload(email);
        imagesDir = new File(userUpload);
        images = imagesDir.listFiles();
    } catch (Exception e) {
        AlertManager.alert(response.getWriter(), request, response, "Oops", "Failed to access user directory!", "error", "welcome.jsp");
    }
%>
<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="java">
<head>
    <link href="css/login.css" type="text/css" rel="stylesheet">
    <link href="css/cinzeldecorative.css" rel="stylesheet">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Image Slider</title>

    <style>
        div {
            position: relative;
        }

        .image {
            display: none;
            position: relative;
        }

        .canvas {
            position: absolute;
            left: 0;
            top: 0;
        }

        .slide1 {
            width: <%=(100 / halfSlide) - 1%>%;
        }

        .slide2 {
            width: <%=(100 / slideCount) - 2%>%;
        }
    </style>
    <script src="js/jquery-1.10.2.js"></script>
</head>

<%
    if (images == null || images.length <= 0) {
        AlertManager.alert(response.getWriter(), request, response, "Oops", "There is no image history for this user..", "error", "upload.jsp");
    } else {
        String extension = images[0].getName().substring(images[0].getName().length() - 4);
%>
<body>
<div id="navbar1">
</div>
<script>
    $(function () {
        $("#navbar1").load("navigationbar.jsp");
    });
</script>

<div>
    <br>
    <h1 style="text-align: center;">MAGIC WAND</h1>
</div>
<div class="cBig">

    <div class="row">
        <div class="col-75" style="text-align: left;">
            <%
                for (int i = 0; i < images.length; i++) {
            %>
            <img id="image<%=i%>" class="image"
                 src="<%=request.getContextPath() + FileManager.convertPathForJSP(userUpload)%>/<%=i + extension%>">
            <%
                }
            %>

            <canvas id="canvas1" class="canvas" onclick="clickOnCanvas(event)"></canvas>
            <canvas id="canvas0" class="canvas" onclick="clickOnCanvas(event)"></canvas>

            <div class="container" style="background-color: #0094e2; left: 520px; top:0;height: 40%; width:25%;"></div>
        </div>
        <div class="col-25">
            <h2>Adjust Threshold:</h2><br>

            <!--rangeslider -->
            <div style="display: inline-block;">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css">
                <link rel='stylesheet prefetch'
                      href='http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/themes/smoothness/jquery-ui.css'>
                <br>
                <div class="cntr" id="range"></div>
                <script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
                <script src='http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/jquery-ui.min.js'></script>
                <script id="scroll" src="slider/index.js"></script>
                <br>
            </div>
            <!--rangeslider -->

            <link href="css/login.css" type="text/css" rel="stylesheet">
            <link href="css/cinzeldecorative.css" rel="stylesheet">
            <br>
            <br>
            <br>
            <button onclick="semiAutomate(1)">PAINT</button>
            <br>
            <button onclick="updateThreshold(-0.01)">DECREASE</button>
            <button onclick="updateThreshold(0.01)">INCREASE</button>
            <br>
            <button onclick="clearSelection()">CLEAR</button>
            <br>
            <p id="threshold">0.02</p>
            <div>
                <br>
                <h2 style="float: left;width: 20px;height: 20px;margin: 5px;  border: 1px solid rgba(0, 0, 0, .2); background-color: green"></h2>
                <h2> : Current Slice</h2><br>
                <h2 style="float: left;width: 20px;height: 20px;margin: 5px;  border: 1px solid rgba(0, 0, 0, .2); background-color: red"></h2>
                <h2> : Edited Slices</h2><br>
                <h2 style="float: left;width: 20px;height: 20px;margin: 5px;  border: 1px solid rgba(0, 0, 0, .2); background-color: whitesmoke"></h2>
                <h2> : Default Style</h2><br>
            </div>
            <br>
            <br>
            <a href="<%=request.getContextPath() + FileManager.convertPathForJSP(FileManager.getDirPath_User(email)) + "/" + session.getAttribute("firstname")%>.zip">download</a>
        </div>
    </div>
    <br>

    <div>
        <button onclick="buttonUpdateIndex(-1)">PREV</button>
        <button onclick="buttonUpdateIndex(1)">NEXT</button>
    </div>
    <br>
    <div>
        <%
            for (int i = 0; i < images.length; i++) {
        %>
        <img id="slide<%=i%>" class="slide1"
             src="<%=request.getContextPath() + FileManager.convertPathForJSP(userUpload)%>/<%=i%><%=extension%>"
             onclick="slideUpdateIndex(this)">
        <%
            }
        %>
        <link rel='stylesheet prefetch' href='https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.css'>
        <link rel='stylesheet prefetch' href='https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/svgs/fi-list.svg'>
        <div id="app"></div>
        <script src='https://cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react-with-addons.min.js'></script>
        <script src='https://cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react-dom.min.js'></script>
        <script type="text/javascript" src="carousel.js"></script>
    </div>
    <br>
    <link href="css/login.css" type="text/css" rel="stylesheet">
    <link href="css/cinzeldecorative.css" rel="stylesheet">
    <div>
        <button onclick="buttonUpdateIndex(-10)"> PREV 10</button>
        <button onclick="buttonUpdateIndex(10)">NEXT 10</button>
    </div>
    <br>
    <div>
        <%
            for (int i = 0; i < images.length; i++) {
        %>
        <img id="slide<%=i%>" class="slide2"
             src="<%=request.getContextPath() + FileManager.convertPathForJSP(userUpload)%>/<%=i%><%=extension%>"
             onclick="slideUpdateIndex(this)">
        <%
            }
        %>
    </div>
    <p id="index">0</p>
</div>

    <script>
        let index = 0;
        let threshold = [];
        threshold[0] = 0.02;
        let clickX, clickY;
    </script>

    <script>

        var fillArray = [];
        var boundryArray = [];
        var averageArray = [];
        var centerXArray = [];
        var centerYArray = [];

    </script>

    <script>
        function refresh() {
            if (typeof threshold[index] === 'undefined')
                threshold[index] = 0.02;

            document.getElementById("threshold").innerText = document.getElementById("scroll").innerHTML;
            document.getElementById("index").innerText = index;

            refreshImage();
            refreshSlides();
            clearCanvas();
            drawOnCanvas();
        }

        function refreshImage() {
            const images = document.getElementsByClassName("image");
            for (let i = 0; i < images.length; i++) {
                images[i].style.display = "none";
            }
            images[index].style.display = "inline-block";
        }

        function refreshSlides() {
            const slides1 = document.getElementsByClassName("slide1");
            const slides2 = document.getElementsByClassName("slide2");
            const divResult1 = Math.floor(index / <%=halfSlide%>);
            const divResult2 = Math.floor(index / <%=slideCount%>);

            for (let i = 0; i < slides1.length; i++) {
                if (Math.floor(i / <%=halfSlide%>) === divResult1)
                    slides1[i].style.display = "inline-block";
                else
                    slides1[i].style.display = "none";
            }

            for (let i = 0; i < slides2.length; i++) {
                if(i == index){
                    slides2[i].style.border ="5px solid blue";
                    slides2[i].style.display = "inline-block";

                }
                else if (i <= index + 5 && i>= index - 5){
                    slides2[i].style.display = "inline-block";
                    slides2[i].style.border ="5px";

                }
                else
                    slides2[i].style.display = "none";
            }
        }

        function buttonUpdateIndex(n) {
            const images = document.getElementsByClassName("image");
            index += n;
            if (index >= images.length)
                index = 0;
            else if (index < 0)
                index = images.length - 1;
            refresh();
        }

        function slideUpdateIndex(element) {
            const images = document.getElementsByClassName("image");
            for (let i = 0; i < images.length; i++) {
                if (element.src.localeCompare(images[i].src) === 0)
                    index = i;
            }
            refresh();
        }

        function clearCanvas() {
            const canvas0 = document.getElementById("canvas0");
            const context0 = canvas0.getContext("2d");
            context0.clearRect(0, 0, canvas0.width, canvas0.height);

            const canvas1 = document.getElementById("canvas1");
            const context1 = canvas1.getContext("2d");
            context1.clearRect(0, 0, canvas1.width, canvas1.height);
        }

        function setCanvasSize() {
            const canvas0 = document.getElementById("canvas0");
            const context0 = canvas0.getContext("2d");

            const canvas1 = document.getElementById("canvas1");
            const context1 = canvas1.getContext("2d");

            canvas0.width = 512;
            canvas0.height = 512;
            context0.globalAlpha = 0.25;

            canvas1.width = 512;
            canvas1.height = 512;
            context1.globalAlpha = 1;
        }
    </script>

    <script>

        function sendClickOp() {
            clearCanvas();

            if (typeof threshold[index] === 'undefined')
                threshold[index] = 0.02;

            $.get("MagicWand?imageID=" + index + "&x=" + clickX + "&y=" + clickY + "&tolerance=" + threshold[index] + "&average=-1", function (responseText) {
                const buffer = responseText.split('|');
                fillArray[index] = buffer[0].split(',');
                boundryArray[index] = buffer[1].split(',');
                averageArray[index] = buffer[2];

                centerXArray[index] = clickX;
                centerYArray[index] = clickY;

                drawOnCanvas();
            });
        }

        function drawOnCanvas() {
            var fillText = fillArray[index];
            var borderText = boundryArray[index];


            const canvas0 = document.getElementById("canvas0");
            const context0 = canvas0.getContext("2d");

            const canvas1 = document.getElementById("canvas1");
            const context1 = canvas1.getContext("2d");

            context0.fillStyle = "#FF0000";
            context1.fillStyle = "#0000FF";


            for (let i = 0; i < fillText.length; i = i + 2) {
                context0.fillRect(fillText[i], fillText[i + 1], 1, 1);
            }
            for (let i = 0; i < borderText.length; i = i + 2) {
                context1.fillRect(borderText[i], borderText[i + 1], 1, 1);
            }
        }

        function clickOnCanvas(event) {

            clickX = event.offsetX;
            clickY = event.offsetY;

            sendClickOp();
        }

        function updateThreshold(n) {
            threshold[index] += n;
            if (threshold[index] >= 0.2)
                threshold[index] = 0.2;
            else if (threshold[index] < 0)
                threshold[index] = 0;

            document.getElementById("threshold").innerText = threshold[index];
            sendClickOp()
        }

        function semiAutomate(count) {
            if (typeof threshold[index] === 'undefined')
                threshold[index] = 0.02;

            if (count < 5) {
                $.get("MagicWand?imageID=" + (index + count) + "&x=" + centerXArray[index + count - 1] + "&y=" + centerYArray[index + count - 1] + "&tolerance=" + threshold[index] + "&average=" + averageArray[index + count - 1], function (responseText) {
                    const buffer = responseText.split('|');
                    fillArray[index + count] = buffer[0].split(',');
                    boundryArray[index + count] = buffer[1].split(',');
                    averageArray[index + count] = buffer[2];
                    var center = buffer[3].split(",");

                    centerXArray[index + count] = center[0];
                    centerYArray[index + count] = center[1];

                    alert(centerXArray[index + count] + "," + centerYArray[index + count]);

                    threshold[index + count] = threshold[index];

                    if (averageArray[index + count] != -1)
                        semiAutomate(count + 1);
                    // else
                    //     alert('stop it');
                });
            }
        }

        function clearSelection() {
            fillArray[index] = [];
            boundryArray[index] = [];
            averageArray[index] = -1;

            clearCanvas();
        }

    </script>

    <script>
        setCanvasSize();
        refresh();
    </script>

</body>
<%}%>

</html>