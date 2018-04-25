<%@ page import="utils.AlertManager" %>
<%@ page import="utils.FileManager" %>
<%@ page import="java.io.File" %>


<%
    int slideCount = 10;

    String email;
    String userUpload = null;
    File imagesDir;
    File[] images = null;

    try {
        email = (String) session.getAttribute("email");
        userUpload = FileManager.getDirPath_UserUpload(email);
        imagesDir = new File(userUpload);
        images = imagesDir.listFiles();
    } catch (Exception e) {
        AlertManager.alert(response.getWriter(), request, response, "Oops", "Failed to access user directory!", "error", "welcome.jsp");
    }

    if (images == null || images.length <= 0) {
        AlertManager.alert(response.getWriter(), request, response, "Oops", "There is no image history for this user..", "error", "upload.jsp");
    } else {
        String extension = images[0].getName().substring(images[0].getName().length() - 4);
        session.setAttribute("extension", extension);
%>
<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="java">
<head>
    <link href="css/login.css" type="text/css" rel="stylesheet">
    <link href="css/cinzeldecorative.css" rel="stylesheet">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel='stylesheet prefetch' href='https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.css'>
    <link rel='stylesheet prefetch' href='https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/svgs/fi-list.svg'>


    <title>Superpixel</title>

    <style>
        div {
            position: relative;
        }

        .image {
            display: inline-block;
            position: relative;
        }

        .canvas {
            position: absolute;
            left: 0;
            top: 0;
        }


    </style>

    <script src="js/jquery-1.10.2.js"></script>
</head>

<body>
<div id="navbar1">
</div>
<script>
    $(function () {
        $("#navbar1").load("navigationbar.jsp");
    });

    var cnrdeneme = [];
</script>


<div class="cBig">

    <div class="row">
        <div class="col-75" style="text-align: left;width:512px;position: sticky;">
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
        </div>

        <div class="col-25">
            <h2>Adjust Threshold:</h2><br>
            <button onclick="updateThreshold(-1)">&#10094;-</button>
            <button onclick="updateThreshold(1)">&#10095;+</button>
            <br>


            <script>
                var ijk = 0;
                while (document.getElementById("image" + ijk) != null) {
                    var a = document.getElementById("image" + ijk).src;
                    cnrdeneme.push(a);
                    ijk++;
                }
                var slider = document.getElementById("rangeSlider");
                var output = document.getElementById("superPixelSize");
                output.innerHTML = slider.value;

                slider.oninput = function () {

                    //updateThreshold2(this.value);
                    output.innerHTML = slider.value;
                }

            </script>
            <button id="magic" onclick="changeTool()">Current Selection: Single Region</button>
            <button onclick="zoomOut()">Zoom OUT</button>
            <button onclick="zoomIn()">Zoom IN</button>
            <br>
            <button onclick="semiAutomate(1)">PAINT</button>
            <button onclick="clearSelection()">CLEAR</button>
            <br><br><br>

            <div>
                <h2 style="float: left;width: 20px;height: 20px;margin: 5px;  border: 1px solid rgba(0, 0, 0, .2); background-color: #0094e2"></h2>
                <h2 style="float: left"> : Current Slice</h2><br><br>
                <!--<h2 style="float: left;width: 20px;height: 20px;margin: 5px;  border: 1px solid rgba(0, 0, 0, .2); background-color: red"></h2>
                <h2 style="float: left"> : Edited Slices</h2><br>
                <h2 style="float: left;width: 20px;height: 20px;margin: 5px;  border: 1px solid rgba(0, 0, 0, .2);
                background-color: whitesmoke"></h2>
                <h2 style="float: left"> : Default Style</h2><br>-->
            </div>
        </div>

    </div>
    <h1 id="index">0</h1>
    <p id="superPixelSize" style="display: none">10</p>

    <div id="carouselSlider"></div>
    <script src='https://cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react-with-addons.min.js'></script>
    <script src='https://cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react-dom.min.js'></script>
    <script type="text/javascript" src="js/carousel.js"></script>
</div>

<script>
    //let index = 0;
    let index = <%=images.length/2%>;
    let superPixelSize = [];
    let clickX, clickY;
    let isMagic = false;
    let processRunning = false;

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
            if (element.id.localeCompare(images[i].id) === 0)
                index = i;
        }
        refresh();
    }

    function refresh() {
        if (typeof superPixelSize[index] === 'undefined')
            superPixelSize[index] = 10.0;


        document.getElementById("superPixelSize").innerText = superPixelSize[index];
        document.getElementById("index").innerText = "index: " + index;

        clearCanvases();
        refreshImage();
        refreshSlides();
        if (typeof boundryArray[index] === 'undefined') {
            superPixelize();
        }

        if (!(typeof clickedArray[index] === 'undefined')) {
            for (let i = 0; i < clickedArray[index].length; i++)
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
</script>

<script>
    function setCanvases() {
        const canvas0 = document.getElementById("canvas0");
        const context0 = canvas0.getContext("2d");
        const canvas1 = document.getElementById("canvas1");
        const context1 = canvas1.getContext("2d");

        canvas0.width = document.getElementById("image0").clientWidth;
        canvas0.height = document.getElementById("image0").clientHeight;
        context0.globalAlpha = 0.25;
        context0.fillStyle = "#0000FF";

        canvas1.width = document.getElementById("image0").clientWidth;
        canvas1.height = document.getElementById("image0").clientHeight;
        context1.globalAlpha = 0.1;
        context1.fillStyle = "#FF00FF";
    }

    function clearCanvases() {
        const canvas0 = document.getElementById("canvas0");
        const context0 = canvas0.getContext("2d");
        const canvas1 = document.getElementById("canvas1");
        const context1 = canvas1.getContext("2d");

        context0.clearRect(0, 0, canvas0.width, canvas0.height);
        context1.clearRect(0, 0, canvas1.width, canvas1.height);
    }

    function drawOnCanvas() {
        const borderText = boundryArray[index];
        const canvas0 = document.getElementById("canvas0");
        const context0 = canvas0.getContext("2d");

        for (let i = 0; i < borderText.length; i = i + 2) {
            context0.fillRect(borderText[i], borderText[i + 1], 1, 1);
        }
    }

    function clickOnCanvas(event) {
        clickX = event.offsetX;
        clickY = event.offsetY;

        if (isMagic) {
            magicSuperPixel(clickX, clickY)
        }
        else {
            floodFill(clickX, clickY);
        }
    }
</script>

<script>
    function superPixelize() {
        if (!processRunning) {
            processRunning = true;
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
                processRunning = false;

            });
        }
    }

    function magicSuperPixel(x, y) {
        var clickIndex = findSuperPixel(x, y);
        $.get("MagicSuperpixel?imageID=" + index + "&superPixelSize=" + superPixelSize[index] + "&clickIndex=" + clickIndex + "&tolerance=0.02", function (responseText) {
            const buffer = responseText.split('|');
            const tempClickArray = buffer[4].split(',');

            for (let i = 0; i < clickedArray[index].length; i++) {
                if (clickedArray[index][i] === 1) {
                    clearSuperPixel(i);
                    clickedArray[index][i] = 0;
                }
            }

            for (let i = 0; i < tempClickArray.length; i++) {
                clickedArray[index][tempClickArray[i]] = 1;

                fillSuperPixel(tempClickArray[i]);
            }
        });
    }

    function updateThreshold(n) {
        superPixelSize[index] += n;
        if (superPixelSize[index] === 11)
            superPixelSize[index] += n;

        if (superPixelSize[index] >= 100)
            superPixelSize[index] = 100;
        else if (superPixelSize[index] < 5)
            superPixelSize[index] = 5;

        document.getElementById("superPixelSize").innerText = superPixelSize[index];

        clearCanvases();
        superPixelize();
    }

    function updateThreshold2(n) {
        superPixelSize[index] = n;
        if (superPixelSize[index] === 11)
            superPixelSize[index] += n;

        if (superPixelSize[index] >= 100)
            superPixelSize[index] = 100;
        else if (superPixelSize[index] < 5)
            superPixelSize[index] = 5;

        document.getElementById("superPixelSize").innerText = superPixelSize[index];

        clearCanvases();
        superPixelize();
    }
</script>

<script>
    function semiAutomate(count) {
        semiAutomateRight(count);
        //semiAutomateLeft(count);
    }

    function semiAutomateRight(count) {

        //if (!processRunning) {
        if (count < 5) {
            // clickX and clickY are -1 since magic wand does not work for this call.
            //processRunning = true ;
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

                if (averageArray[index + count] !== -1)
                    semiAutomateRight(count + 1);
                // processRunning = false;
            });
            //}
        }
    }

    function semiAutomateLeft(count) {
        if (!processRunning) {
            if (count < 5) {
                processRunning = true;
                $.get("MagicWand?imageID=" + (index - count) + "&x=" + centerXArray[index - count + 1] + "&y=" + centerYArray[index - count + 1] + "&tolerance=" + superPixelSize[index] + "&average=" + averageArray[index - count + 1], function (responseText) {
                    const buffer = responseText.split('|');
                    selectionArray[index - count] = buffer[0].split(',');
                    boundryArray[index - count] = buffer[1].split(',');
                    averageArray[index - count] = buffer[2];
                    var center = buffer[3].split(",");

                    centerXArray[index - count] = center[0];
                    centerYArray[index - count] = center[1];

                    superPixelSize[index - count] = superPixelSize[index];

                    if (averageArray[index - count] !== -1)
                        semiAutomateLeft(count + 1);
                    processRunning = false;
                });
            }
        }
    }

    function castSuperPixels(count) {
        for (var i = 0; i < clickedArray[index + count - 1].length; i++) {
            if (clickedArray[index + count - 1][i] === 1) {
                //alert('res: ' + (Math.abs(averageArray[index + count - 1][i] - averageArray[index + count][i]) / 255));
                if ((Math.abs(averageArray[index + count - 1][i] - averageArray[index + count][i]) / 255) < 0.03
                    &&
                    (Math.abs(centerArray[index + count - 1][i] - centerArray[index + count][i]) / 255) < 0.05)
                    clickedArray[index + count][i] = 1;
            }
        }
    }
</script>

<script>
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
        if (clickedArray[index][clickedIndex] === 0) {
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

    function changeTool() {
        if (isMagic) {
            isMagic = false;
            document.getElementById("magic").innerHTML = "Current Selection: Single Region ";
        } else {
            isMagic = true;
            document.getElementById("magic").innerHTML = "Current Selection: Multiple Region ";
        }
    }
</script>

<script>
    function zoomIn() {
        var temp = document.getElementById("image" + index);

        temp.width = (temp.width + 100);
        temp.height = (temp.height + 100);

        var temp2 = document.getElementById("canvas0");
        temp2.width = (temp2.width + 100);
        temp2.height = (temp2.height + 100);

        temp3 = document.getElementById("canvas1");
        temp3.width = (temp3.width + 100);
        temp3.height = (temp3.height + 100);

    }

    function zoomOut() {
        var temp = document.getElementById("image" + index);
        var value = temp.width - 100;
        if (value < 512)
            value = 512;
        temp.width = value;
        temp.height = value;

        var temp2 = document.getElementById("canvas0");
        temp2.width = value;
        temp2.height = value;

        var temp3 = document.getElementById("canvas1");
        temp3.width = value;
        temp3.height = value;
    }
</script>

<script>
    setCanvases();
    refresh();
</script>
</body>
<%}%>
</html>
