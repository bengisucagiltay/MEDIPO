<%@ page import="utils.AlertManager" %>
<%@ page import="utils.FileManager" %>
<%@ page import="java.io.File" %>

<%
    int slideCount = 10;

    String email = null;
    String userUpload = null;
    File imagesDir = null;
    File[] images = null;

    try {
        email = (String) session.getAttribute("email");
        userUpload = FileManager.getDirPath_UserUpload(email);
        imagesDir = new File(userUpload);
        images = imagesDir.listFiles();
    } catch (Exception e) {
        AlertManager.alert(response.getWriter(), request, response, "Oops", "Failed to access user directory!", "error", "welcome.jsp");
        return;
    }
%>

<html>

<head>
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

        .slide {
            width: <%=(100 / slideCount) - 1%>%;
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

<div>
    <button onclick="buttonUpdateIndex(-1)">&#10094;</button>
    <button onclick="buttonUpdateIndex(1)">&#10095;</button>
</div>

<p id="test">here</p>

<div>
    <%
        for (int i = 0; i < images.length; i++) {
    %>
    <img id="image<%=i%>" class="image"
         src="<%=request.getContextPath() + FileManager.convertPathForJSP(userUpload)%>/<%=i + extension%>">
    <%
        }
    %>

    <canvas id="canvas1" class="canvas"></canvas>
    <canvas id="canvas0" class="canvas" onclick="clickOnCanvas(event)"></canvas>
</div>

<div>
    <button onclick="buttonUpdateIndex(-10)">&#10094;</button>
    <button onclick="buttonUpdateIndex(10)">&#10095;</button>
</div>

<div>
    <%
        for (int i = 0; i < images.length; i++) {
    %>
    <img id="slide<%=i%>" class="slide"
         src="<%=request.getContextPath() + FileManager.convertPathForJSP(userUpload)%>/<%=i%><%=extension%>"
         onclick="slideUpdateIndex(this)">
    <%
        }
    %>
</div>

<button onclick="updateThreshold(-0.001)">&#10094;-</button>
<button onclick="updateThreshold(0.001)">&#10095;+</button>
<button onclick="semiAutomate(1)">MAHMUT</button>
<button onclick="clearSelection()">MEHMET</button>

<p id="index">index: 0</p>
<p id="threshold">0.02</p>

<script>
    let index = 0;
    let threshold = [];
    threshold[0] = 0.02;
    let clickX, clickY;
</script>

<script>

    var selectionArray = [];
    var boundryArray = [];
    var averageArray = [];
    var centerXArray = [];
    var centerYArray = [];

</script>

<script>
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

    function refresh() {
        if (typeof threshold[index] === 'undefined')
            threshold[index] = 0.02;

        document.getElementById("threshold").innerText = threshold[index];
        document.getElementById("index").innerText = "index: " + index;

        refreshImage();
        refreshSlides();
        clearCanvases();
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
        const slides = document.getElementsByClassName("slide");
        const divResult = Math.floor(index / <%=slideCount%>);

        for (let i = 0; i < slides.length; i++) {
            if (Math.floor(i / <%=slideCount%>) === divResult)
                slides[i].style.display = "inline-block";
            else
                slides[i].style.display = "none";
        }
    }

    function clearCanvases() {
        const canvas0 = document.getElementById("canvas0");
        const context0 = canvas0.getContext("2d");
        context0.clearRect(0, 0, canvas0.width, canvas0.height);

        const canvas1 = document.getElementById("canvas1");
        const context1 = canvas1.getContext("2d");
        context1.clearRect(0, 0, canvas1.width, canvas1.height);
    }

    function setCanvases() {
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
        clearCanvases();

        $.get("MagicWand?imageID=" + index + "&x=" + clickX + "&y=" + clickY + "&tolerance=" + threshold[index] + "&average=-1", function (responseText) {
            const buffer = responseText.split('|');
            selectionArray[index] = buffer[0].split(',');
            boundryArray[index] = buffer[1].split(',');
            averageArray[index] = buffer[2];

            centerXArray[index] = clickX;
            centerYArray[index] = clickY;

            drawOnCanvas();
        });
    }

    function drawOnCanvas() {
        var selectionText = selectionArray[index];
        var borderText = boundryArray[index];


        const canvas0 = document.getElementById("canvas0");
        const context0 = canvas0.getContext("2d");

        const canvas1 = document.getElementById("canvas1");
        const context1 = canvas1.getContext("2d");

        context0.fillStyle = "#FF0000";
        context1.fillStyle = "#0000FF";


        for (let i = 0; i < selectionText.length; i = i + 2) {
            context0.fillRect(selectionText[i], selectionText[i + 1], 1, 1);
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
        semiAutomateRight(count);
        semiAutomateLeft(count);
    }

    function semiAutomateRight(count) {

        if (count < 5) {
            $.get("MagicWand?imageID=" + (index + count) + "&x=" + centerXArray[index + count - 1] + "&y=" + centerYArray[index + count - 1] + "&tolerance=" + threshold[index] + "&average=" + averageArray[index + count - 1], function (responseText) {
                const buffer = responseText.split('|');
                selectionArray[index + count] = buffer[0].split(',');
                boundryArray[index + count] = buffer[1].split(',');
                averageArray[index + count] = buffer[2];

                var center = buffer[3].split(",");
                centerXArray[index + count] = center[0];
                centerYArray[index + count] = center[1];

                threshold[index + count] = threshold[index];

                if (averageArray[index + count] != -1)
                    semiAutomate(count + 1);
            });
        }
    }

    function semiAutomateLeft(count) {

        if (count < 5) {
            $.get("MagicWand?imageID=" + (index - count) + "&x=" + centerXArray[index - count + 1] + "&y=" + centerYArray[index - count + 1] + "&tolerance=" + threshold[index] + "&average=" + averageArray[index - count + 1], function (responseText) {
                const buffer = responseText.split('|');
                selectionArray[index - count] = buffer[0].split(',');
                boundryArray[index - count] = buffer[1].split(',');
                averageArray[index - count] = buffer[2];
                var center = buffer[3].split(",");

                centerXArray[index - count] = center[0];
                centerYArray[index - count] = center[1];

                threshold[index - count] = threshold[index];

                if (averageArray[index - count] != -1)
                    semiAutomateLeft(count + 1);
            });
        }
    }

    function clearSelection() {
        selectionArray[index] = [];
        boundryArray[index] = [];
        averageArray[index] = -1;

        clearCanvases();
    }

</script>

<script>
    setCanvases();
    refresh();
</script>

</body>
<%}%>

</html>
