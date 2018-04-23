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

<button onclick="updateThreshold(-1)">&#10094;-</button>
<button onclick="updateThreshold(1)">&#10095;+</button>
<button onclick="semiAutomate(1)">MAHMUT</button>
<button onclick="clearSelection()">MEHMET</button>

<p id="index">index: 0</p>
<p id="superPixelSize">10</p>

<script>
    let index = 0;
    let superPixelSize = [];
    let clickX, clickY;
</script>

<script>

    var selectionArray = [];
    var boundryArray = [];
    var averageArray = [];
    var centerArray = [];
    var pixelArray = [];
    var clickedArray = [];

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
        if (typeof superPixelSize[index] === 'undefined')
            superPixelSize[index] = 10.0;

        document.getElementById("superPixelSize").innerText = superPixelSize[index];
        document.getElementById("index").innerText = "index: " + index;


        refreshImage();
        refreshSlides();
        clearCanvases();
        if (typeof boundryArray[index] === 'undefined') {
            superPixelize();
        }

        if (!(typeof clickedArray[index] === 'undefined')) {
            //alert('index: ' + index + '  girdik');
            for (var i = 0; i < clickedArray[index].length; i++)
                if (clickedArray[index][i] === 1)
                    fillSuperPixel(i);
        }

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
        context0.globalAlpha = 0.1;
        context0.fillStyle = "#0000FF";

        canvas1.width = 512;
        canvas1.height = 512;
        context1.globalAlpha = 0.1;
        context1.fillStyle = "#FF00FF";
    }
</script>

<script>
    function superPixelize() {
        $.get("MagicSuperpixel?imageID=" + index + "&superPixelSize=" + superPixelSize[index] + "&clickIndex=-1" + "&tolerance=-1.0", function (responseText) {
            const buffer = responseText.split('|');
            boundryArray[index] = buffer[0].split(',');
            centerArray[index] = buffer[1].split(',');
            averageArray[index] = buffer[2].split(',');
            var pixelLists = buffer[3].split("$");

            pixelArray[index] = [];
            clickedArray[index] = [];
            for (var i = 0; i < pixelLists.length; i++) {
                pixelArray[index][i] = pixelLists[i].split(',');

                clickedArray[index][i] = 0;
            }

            drawOnCanvas();
        });
    }

    function magicSuperPixel(x, y) {
        var clickIndex = findSuperPixel(x, y);
        $.get("MagicSuperpixel?imageID=" + index + "&superPixelSize=" + superPixelSize[index] + "&clickIndex=" + clickIndex + "&tolerance=0.025", function (responseText) {
            const buffer = responseText.split('|');
            var tempClickArray = buffer[4].split(',');

            for (var i = 0; i < clickedArray[index].length; i++) {
                if(clickedArray[index][i] == 1){
                    clearSuperPixel(i);
                    clickedArray[index][i] = 0;
                }
            }

            for (var i = 0; i < tempClickArray.length; i++) {
                clickedArray[index][tempClickArray[i]] = 1;

                fillSuperPixel(tempClickArray[i]);
            }

            //drawOnCanvas();
        });
    }

    function drawOnCanvas() {
        var borderText = boundryArray[index];

        const canvas0 = document.getElementById("canvas0");
        const context0 = canvas0.getContext("2d");


        for (let i = 0; i < borderText.length; i = i + 2) {
            context0.fillRect(borderText[i], borderText[i + 1], 1, 1);
        }
    }

    function clickOnCanvas(event) {
        clickX = event.offsetX;
        clickY = event.offsetY;

        var isMagic = true;

        if(isMagic){
            magicSuperPixel(clickX, clickY)
        }
        else{
            floodFill(clickX, clickY);
        }
    }

    function updateThreshold(n) {
        superPixelSize[index] += n;
        if (superPixelSize[index] >= 100)
            superPixelSize[index] = 100;
        else if (superPixelSize[index] < 5)
            superPixelSize[index] = 5;

        document.getElementById("superPixelSize").innerText = superPixelSize[index];

        clearCanvases();
        superPixelize();
        //sendClickOp();
    }

    function semiAutomate(count) {
        semiAutomateRight(count);
        //semiAutomateLeft(count);
    }

    function semiAutomateRight(count) {
        if (count < 5) {

            // clickX and clickY are -1 since magic wand does not work for this call.
            $.get("MagicSuperpixel?imageID=" + (index + count) + "&superPixelSize=" + superPixelSize[index] + "&clickIndex=-1" + "&tolerance=-1.0", function (responseText) {
                const buffer = responseText.split('|');
                boundryArray[index + count] = buffer[0].split(',');
                centerArray[index + count] = buffer[1].split(',');
                averageArray[index + count] = buffer[2].split(',');
                var pixelLists = buffer[3].split("$");

                pixelArray[index + count] = [];
                clickedArray[index + count] = [];
                for (var i = 0; i < pixelLists.length; i++) {
                    pixelArray[index + count][i] = pixelLists[i].split(',');
                    clickedArray[index + count][i] = 0;
                }

                superPixelSize[index + count] = superPixelSize[index];

                castSuperPixels(count);

                if (averageArray[index + count] != -1)
                    semiAutomateRight(count + 1);
            });
        }
    }

    function semiAutomateLeft(count) {

        if (count < 5) {
            $.get("MagicWand?imageID=" + (index - count) + "&x=" + centerXArray[index - count + 1] + "&y=" + centerYArray[index - count + 1] + "&tolerance=" + superPixelSize[index] + "&average=" + averageArray[index - count + 1], function (responseText) {
                const buffer = responseText.split('|');
                selectionArray[index - count] = buffer[0].split(',');
                boundryArray[index - count] = buffer[1].split(',');
                averageArray[index - count] = buffer[2];
                var center = buffer[3].split(",");

                centerXArray[index - count] = center[0];
                centerYArray[index - count] = center[1];

                superPixelSize[index - count] = superPixelSize[index];

                if (averageArray[index - count] != -1)
                    semiAutomateLeft(count + 1);
            });
        }
    }

    function castSuperPixels(count) {
        for (var i = 0; i < clickedArray[index + count - 1].length; i++) {
            if (clickedArray[index + count - 1][i] == 1) {
                //alert('res: ' + (Math.abs(averageArray[index + count - 1][i] - averageArray[index + count][i]) / 255));
                if((Math.abs(averageArray[index + count - 1][i] - averageArray[index + count][i]) / 255) < 0.03
                &&
                    (Math.abs(centerArray[index + count - 1][i] - centerArray[index + count][i]) / 255) < 0.05)
                    clickedArray[index + count][i] = 1;
            }
        }
    }

    function clearSelection() {
        selectionArray[index] = [];
        boundryArray[index] = [];
        averageArray[index] = -1;

        clearCanvases();
    }

    function findSuperPixel(x, y) {
        var tempDistance = (x - centerArray[index][0]) * (x - centerArray[index][0]) + (y - centerArray[index][1]) * (y - centerArray[index][1]);
        var nearestIndex = 0;

        for (var i = 2; i < centerArray[index].length; i += 2) {
            var temp = (x - centerArray[index][i]) * (x - centerArray[index][i]) + (y - centerArray[index][i + 1]) * (y - centerArray[index][i + 1]);

            if (temp < tempDistance) {
                tempDistance = temp;
                nearestIndex = i / 2;
            }
        }

        return nearestIndex;
    }

    function floodFill(x, y) {
        var clickedIndex = findSuperPixel(x, y);
        if (clickedArray[index][clickedIndex] == 0) {
            fillSuperPixel(clickedIndex);
            clickedArray[index][clickedIndex] = 1
        }
        else {
            clearSuperPixel(clickedIndex);
            clickedArray[index][clickedIndex] = 0;
        }
    }

    function fillSuperPixel(superPixelIndex) {
        const canvas1 = document.getElementById("canvas1");
        const context1 = canvas1.getContext("2d");

        for (var i = 0; i < pixelArray[index][superPixelIndex].length; i += 2) {
            context1.fillRect(pixelArray[index][superPixelIndex][i], pixelArray[index][superPixelIndex][i + 1], 1, 1);
        }
    }

    function clearSuperPixel(superPixelIndex) {
        const canvas1 = document.getElementById("canvas1");
        const context1 = canvas1.getContext("2d");

        for (var i = 0; i < pixelArray[index][superPixelIndex].length; i += 2) {
            context1.clearRect(pixelArray[index][superPixelIndex][i], pixelArray[index][superPixelIndex][i + 1], 1, 1);
        }
    }

</script>

<script>
    setCanvases();
    refresh();
</script>

</body>
<%}%>

</html>
