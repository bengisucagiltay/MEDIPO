<%@ page import="utils.AlertManager" %>
<%@ page import="utils.FileManager" %>
<%@ page import="java.io.File" %>

<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8" %>


<%
    String email;
    String userUpload;
    File imagesDir;
    File[] images;

    try {
        email = (String) session.getAttribute("email");
        userUpload = FileManager.getDirPath_UserUpload(email);
        imagesDir = new File(userUpload);
        images = imagesDir.listFiles();


        if (images == null || images.length <= 0) {
            AlertManager.alert(response.getWriter(), request, response, "Oops", "There is no image history for this user..", "error", "upload.jsp");
        } else {
            String extension = images[0].getName().substring(images[0].getName().length() - 4);
            session.setAttribute("extension", extension);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="java">
<head>
    <link href="css/login.css" type="text/css" rel="stylesheet">
    <link href="css/cinzeldecorative.css" rel="stylesheet">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel='stylesheet prefetch' href='https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.css'>
    <link rel='stylesheet prefetch' href='https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/svgs/fi-list.svg'>


    <title>Magic Grid</title>

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

        .slide {
            width: 10%;
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

<div class="cBig" style="top: 25%;padding-bottom: 10%; padding-left: 5%;">

    <div class="row">
        <div class="col-75"
             style="text-align: left;width:512px;height:512px;position: sticky;overflow: auto;white-space: nowrap;">
            <%
                for (int i = 0; i < images.length; i++) {
            %>
            <img id="image<%=i%>" class="image"
                 src="<%=request.getContextPath() + FileManager.convertPathForJSP(userUpload)%>/<%=i + extension%>">
            <%
                }
            %>
            <canvas id="canvas3" class="canvas"></canvas>   <!-- Global Super Pixel Borders -->
            <canvas id="canvas2" class="canvas"></canvas>   <!-- Selection (Mask) -->
            <canvas id="canvas1" class="canvas"></canvas>   <!-- Selection Border -->
            <canvas id="canvas0" class="canvas" onclick="clickOnCanvas(event)"></canvas>

        </div>


        <div class="col-25" style="left: 10%;width: 50%; align-content: center; text-align: center">
            <h1 style=" text-align:center; font-family: 'Open Sans', sans-serif">Magic Grid Tool</h1>
            <button style="display: inline-block" onclick="updateSuperPixelSize(-2)">&#10094;</button>
            <button style="height: 40px; width:150px; float:none; pointer-events: none;" onclick="">Grid Size  </button>
            <button style="display: inline-block" onclick="updateSuperPixelSize(2)">&#10095;</button>

            <!--<button style="display: inline-block" onclick="semiAutomateLeft(1)">&#10094;</button>
            <button style="height: 40px; width:150px; float:none;pointer-events: none;">Paint</button>
            <button style="display: inline-block" onclick="semiAutomateRight(50)">&#10095;</button>
            <br>
            <button style="display: inline-block" onclick="updateThreshold(-1)">&#10094;</button>
            <button style="height: 40px; width:150px; float:none; pointer-events: none;">Threshold 3</button>
            <button style="display: inline-block" onclick="updateThreshold(1)">&#10095;</button>

            <button style="display: inline-block" onclick="updateThreshold(-1)">&#10094;</button>
            <button style="height: 40px; width:150px; float:none; pointer-events: none;">Threshold 4</button>
            <button style="display: inline-block" onclick="updateThreshold(1)">&#10095;</button>-->
            <br>


            <script>
                var ijk = 0;
                while (document.getElementById("image" + ijk) != null) {
                    var a = document.getElementById("image" + ijk).src;
                    cnrdeneme.push(a);
                    ijk++;
                }

            </script>
            <button style="height: 40px; width:150px; float:none;background-color: #77D1FA;" id="canvas3status"
                    onclick="changeVisibilityCanvas3()">GRID : ON
            </button>
            <button style="height: 40px; width:150px; float:none;background-color: #77D1FA;" id="canvas1status"
                    onclick="changeVisibilityCanvas1()">BORDER : ON
            </button>
            <button style="height: 40px; width:150px; float:none;background-color: #77D1FA;" id="canvas2status"
                    onclick="changeVisibilityCanvas2()">COLOR : ON
            </button>
            <br>
            <button style="height: 40px; width:150px; float:none;background-color: #5CC3F4;" onclick="semiAutomate(30)">
                PAINT FORWARD
            </button>
            <button style="height: 40px; width:150px; float:none;background-color: #5CC3F4;"
                    onclick="clearArraysFor(index)">CLEAR CURRENT
            </button>
            <button style="height: 40px; width:150px; float:none;background-color: #5CC3F4;" onclick="clearArraysAll()">
                CLEAR ALL
            </button>
            <br>


            <button style="background-color: #42B6EF;" id="magic" onclick="changeTool()">Current Selection: Single
                Region
            </button>
            <br><br>
            <p id="super_pixel_size" style="display: none">10</p>

        </div>
        <div class="col-25" style="left: 10%;width: 50%; align-content: center; text-align: center">
            <div id="carouselSlider" style="transform: scale(1.2)"></div>
            <script src='https://cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react-with-addons.min.js'></script>
            <script src='https://cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react-dom.min.js'></script>
            <script type="text/javascript" src="js/carousel.js"></script>
            <br><br><br><br><br><br><br>
            <h1 style="padding-left: 5%" id="index">0</h1>
            <form action="Download" method="post">
                <input style="margin-left:4%; height: 40px; width:150px; float:none;" type="submit" name="Submit"
                       value="Download ZIP"/>
            </form>
        </div>

    </div>

</div>
<script src='https://cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react-with-addons.min.js'></script>
<script src='https://cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react-dom.min.js'></script>
<script type="text/javascript" src="js/carousel.js"></script>
</div>

<script>
    let imageCount = <%=images.length%>;
    let index = <%=images.length/2%>;

    let processRunning = false;
    let isMagic = false;

    let drawToCanvas1 = true;
    let drawToCanvas2 = true;
    let drawToCanvas3 = true;

    //BBuraya buton ekle
    let averageTolerance = 0.02;
    let coverageTolerance = 0.5;

    let clickX, clickY;
    let imageWidth = document.getElementById("image" + index).clientWidth;
    let imageHeight = document.getElementById("image" + index).clientHeight;
</script>

<script>
    let spSize = [];                            // size (1D)
    let spSelected = [];                        // selected super pixel numbers (2D)
    let spSelectedBinary = [];                  // sp selected (yes/no) (2D)
    let spAverage = [];                         // average colors of super pixels (2D)
    let spBorder = [];                          // sp border (x even, y odd) (2D)
    let spCenter = [];                          // centers of super pixels (x even, y odd) (2D)
    let pixelsOfSp = [];                        // pixel list of each super pixel (x even, y odd) (3D)
    let spNeighbourList = [];                    // neighbours of super pixels (3D)
    let spOfPixels = [];                        // labels (pixels are denoted as IDs) (2D)

    let selection = [];                         // selected pixels (x even, y odd) (2D)
    let selectionBinary = [];                   // selected pixels (yes/no) (2D)
    let border = [];                            // border of the selection (x even, y odd) (2D)
    let average = [];                           // average value of the current selection (1D)
    let center = [];                            // center of the current selection (2D)

    for (let i = 0; i < imageCount; i++) {
        spSize[i] = 10;
        spSelectedBinary[i] = [];
        spSelected[i] = [];
        spBorder[i] = [];
        spAverage[i] = [];
        spCenter[i] = [];
        pixelsOfSp[i] = [];             // re-arrange after super-pixelize
        spOfPixels[i] = [];
        spNeighbourList[i] = [];          // re-arrange after super-pixelize

        selection[i] = [];
        selectionBinary[i] = [];
        border[i] = [];
        average[i] = [];
        center[i] = [];
    }
</script>

<script>
    const canvas0 = document.getElementById("canvas0");

    const canvas1 = document.getElementById("canvas1");
    const context1 = canvas1.getContext("2d");

    const canvas2 = document.getElementById("canvas2");
    const context2 = canvas2.getContext("2d");

    const canvas3 = document.getElementById("canvas3");
    const context3 = canvas3.getContext("2d");

    const images = document.getElementsByClassName("image");
</script>

<script>
    function buttonUpdateIndex(n) {
        index += n;
        if (index >= images.length)
            index = 0;
        else if (index < 0)
            index = images.length - 1;

        refresh();
    }

    function slideUpdateIndex(element) {
        for (let i = 0; i < images.length; i++) {
            if (element.src.localeCompare(images[i].src) === 0)
                index = i;
        }

        refresh();
    }

    function updateSuperPixelSize(n) {
        spSize[index] += n;
        if (spSize[index] > 40)
            spSize[index] = 40;
        else if (spSize[index] < 6)
            spSize[index] = 6;

        document.getElementById("super_pixel_size").innerText = spSize[index];

        if (selection[index].length !== 0)
            superPixelCastLocal();
        else
            superPixelPixelate();
    }
    function updateAvgTolerance(n) {
        averageTolerance[index] += n;
        if (averageTolerance[index] > 40)
            averageTolerance[index] = 40;
        else if (averageTolerance[index] < 6)
            averageTolerance[index] = 6;

        document.getElementById("average_tolerance").innerText = averageTolerance[index];

        if (selection[index].length !== 0)
            superPixelCastLocal();
        else
            superPixelPixelate();
    }

    function updateCovTolerance(n) {
        coverageTolerance[index] += n;
        if (coverageTolerance[index] > 40)
            coverageTolerance[index] = 40;
        else if (coverageTolerance[index] < 6)
            coverageTolerance[index] = 6;

        document.getElementById("coverage_tolerance").innerText = coverageTolerance[index];

        if (selection[index].length !== 0)
            superPixelCastLocal();
        else
            superPixelPixelate();
    }

    function refresh() {
        document.getElementById("index").innerText = "index: " + index;
        document.getElementById("super_pixel_size").innerText = spSize[index];

        refreshImage();
        //refreshSlides();

        refreshGlobalBorderCanvas();
        refreshSelectionCanvas();
        refreshSelectionBorderCanvas();

        if (spBorder[index].length === 0)
            superPixelPixelate();
    }

    function refreshImage() {
        for (let i = 0; i < images.length; i++) {
            images[i].style.display = "none";
        }
        images[index].style.display = "inline-block";
    }

    function refreshSlides() {
        const slides = document.getElementsByClassName("slide");

        for (let i = 0; i < slides.length; i++) {
            if (index === i) {
                slides[i].border = "3";
                slides[i].style.borderColor = "purple";
            }
            else if (selection[i].length !== 0) {
                slides[i].border = "3";
                slides[i].style.borderColor = "yellow";
            }
            else
                slides[i].border = "0";

            if (Math.abs(index - i) < 5)
                slides[i].style.display = "inline-block";
            else
                slides[i].style.display = "none";
        }
    }

    function clearArraysFor(clearIndex) {
        spSelectedBinary[clearIndex] = [];
        spSelected[clearIndex] = [];
        spBorder[clearIndex] = [];
        spAverage[clearIndex] = [];
        spCenter[clearIndex] = [];
        pixelsOfSp[clearIndex] = [];                 // re-arrange after super-pixelize
        spOfPixels[clearIndex] = [];
        spNeighbourList[clearIndex] = [];            // re-arrange after super-pixelize

        selection[clearIndex] = [];
        selectionBinary[clearIndex] = [];
        border[clearIndex] = [];
        average[clearIndex] = [];
        center[clearIndex] = [];
        refresh();
    }

    function clearArraysAll() {
        for (let i = 0; i < imageCount; i++)
            clearArraysFor(i);
        refresh();

    }

</script>

<script>
    function setCanvases() {
        canvas0.width = imageWidth;
        canvas0.height = imageHeight;

        canvas1.width = imageWidth;
        canvas1.height = imageHeight;
        context1.globalAlpha = 0.3;
        context1.fillStyle = "#00FF00";

        canvas2.width = imageWidth;
        canvas2.height = imageHeight;
        context2.globalAlpha = 0.4;
        context2.fillStyle = "#FF0000";

        canvas3.width = imageWidth;
        canvas3.height = imageHeight;
        context3.globalAlpha = 0.20;
        context3.fillStyle = "#0000FF";
    }

    function refreshGlobalBorderCanvas() {
        // canvas 3
        context3.clearRect(0, 0, canvas3.width, canvas3.height);

        const spBorderToDraw = spBorder[index];
        if (spBorderToDraw.length !== 0 && drawToCanvas3) {
            for (let i = 0; i < spBorderToDraw.length; i = i + 2) {
                context3.fillRect(spBorderToDraw[i], spBorderToDraw[i + 1], 1, 1);
            }
        }
    }

    function refreshSelectionCanvas() {
        // canvas 2
        context2.clearRect(0, 0, canvas2.width, canvas2.height);

        const selectionToDraw = selection[index];
        if (selectionToDraw.length !== 0 && drawToCanvas2) {
            for (let i = 0; i < selectionToDraw.length; i += 2) {
                context2.fillRect(selectionToDraw[i], selectionToDraw[i + 1], 1, 1);
            }
        }
    }

    function refreshSelectionBorderCanvas() {
        // canvas 1
        context1.clearRect(0, 0, canvas1.width, canvas1.height);

        const borderToDraw = border[index];
        if (borderToDraw.length !== 0 && drawToCanvas1) {
            for (let i = 0; i < borderToDraw.length; i = i + 2) {
                context1.fillRect(borderToDraw[i], borderToDraw[i + 1], 1, 1);
            }
        }
    }

    function clickOnCanvas(event) {
        clickX = event.offsetX;
        clickY = event.offsetY;

        if (isMagic) {
            superPixelMagic()
        }
        else {
            superPixelClick();
        }
    }

    function changeVisibilityCanvas1() {
        if (drawToCanvas1 == true) {
            drawToCanvas1 = false;
            document.getElementById("canvas1status").innerHTML = "BORDER   : OFF";
            context1.clearRect(0, 0, canvas1.width, canvas1.height);
        }
        else {
            drawToCanvas1 = true;
            document.getElementById("canvas1status").innerHTML = "BORDER   : ON";
            refreshSelectionBorderCanvas();
        }
    }

    function changeVisibilityCanvas2() {
        if (drawToCanvas2 == true) {
            drawToCanvas2 = false;
            document.getElementById("canvas2status").innerHTML = "COLOR    : OFF";
            context2.clearRect(0, 0, canvas2.width, canvas2.height);
        }
        else {
            drawToCanvas2 = true;
            document.getElementById("canvas2status").innerHTML = "COLOR    : ON";
            refreshSelectionCanvas();
        }
    }

    function changeVisibilityCanvas3() {
        if (drawToCanvas3 == true) {
            drawToCanvas3 = false;
            document.getElementById("canvas3status").innerHTML = "GRID     : OFF";
            context3.clearRect(0, 0, canvas3.width, canvas3.height);
        }
        else {
            drawToCanvas3 = true;
            document.getElementById("canvas3status").innerHTML = "GRID     : ON";
            refreshGlobalBorderCanvas();
        }
    }

</script>

<script>
    function superPixelPixelate() {
        if (!processRunning) {
            processRunning = true;
            $.post("SuperPixelPixelate", {
                    index: index,
                    superPixelSize: spSize[index]
                },

                function (responseText) {
                    clearArraysFor(index);

                    const buffer = responseText.split('|');

                    spBorder[index] = buffer[0].split(',');
                    spAverage[index] = buffer[1].split(',');
                    spCenter[index] = buffer[2].split(',');

                    let spBuffer = buffer[3].split("$");
                    for (let i = 0; i < spBuffer.length; i++) {
                        pixelsOfSp[index][i] = spBuffer[i].split(',');
                    }

                    // Clear selection
                    for (let i = 0; i < spBuffer.length; i++) {
                        spSelectedBinary[index][i] = 0;
                    }

                    for (let i = 0; i < imageWidth; i++) {
                        for (let j = 0; j < imageHeight; j++) {
                            selectionBinary[index][i + j * imageWidth] = 0;
                        }
                    }
                    // Clear selection

                    spBuffer = buffer[4].split("$");
                    for (let i = 0; i < spBuffer.length; i++) {
                        spNeighbourList[index][i] = spBuffer[i].split(',');
                    }

                    spOfPixels[index] = buffer[5].split(',');

                    processRunning = false;
                    refreshGlobalBorderCanvas();
                }
            );
        }
    }

    function superPixelCastLocal() {
        if (!processRunning) {
            processRunning = true;
            $.post("SuperPixelCast", {
                    index: index,
                    superPixelSize: spSize[index],
                    selection: selection[index].toString(),
                    spOfPixels: spOfPixels[index].toString(),
                    spAverage: spAverage[index].toString(),
                    averageTolerance: averageTolerance,
                    coverageTolerance: coverageTolerance
                },

                function (responseText) {
                    clearArraysFor(index);

                    const buffer = responseText.split('|');

                    spBorder[index] = buffer[0].split(',');
                    spAverage[index] = buffer[1].split(',');
                    spCenter[index] = buffer[2].split(',');

                    let spBuffer = buffer[3].split("$");
                    for (let i = 0; i < spBuffer.length; i++) {
                        pixelsOfSp[index][i] = spBuffer[i].split(',');
                    }

                    // Clear selection
                    for (let i = 0; i < spBuffer.length; i++) {
                        spSelectedBinary[index][i] = 0;
                    }

                    for (let i = 0; i < imageWidth; i++) {
                        for (let j = 0; j < imageHeight; j++) {
                            selectionBinary[index][i + j * imageWidth] = 0;
                        }
                    }
                    // Clear selection

                    spBuffer = buffer[4].split("$");
                    for (let i = 0; i < spBuffer.length; i++) {
                        spNeighbourList[index][i] = spBuffer[i].split(',');
                    }

                    spOfPixels[index] = buffer[5].split(',');

                    selection[index] = buffer[6].split(',');
                    border[index] = buffer[7].split(',');
                    spSelected[index] = buffer[8].split(',');

                    for (let i = 0; i < spSelected[index].length; i++) {
                        spSelectedBinary[index][spSelected[index][i]] = 1;
                    }

                    average[index] = buffer[9];

                    processRunning = false;
                    refreshGlobalBorderCanvas();
                    refreshSelectionCanvas();
                    refreshSelectionBorderCanvas();
                }
            );
        }
    }

    function getBorder() {
        border[index] = [];

        for (let i = 0; i < spBorder[index].length; i += 2) {

            let currentX = parseInt(spBorder[index][i]);
            let currentY = parseInt(spBorder[index][i + 1]);

            let currentSuperPixel = spOfPixels[index][currentX + currentY * imageWidth];
            let leftSuperPixel = spOfPixels[index][(currentX - 1) + currentY * imageWidth];
            let rightSuperPixel = spOfPixels[index][(currentX + 1) + currentY * imageWidth];
            let upSuperPixel = spOfPixels[index][currentX + (currentY - 1) * imageWidth];
            let downSuperPixel = spOfPixels[index][currentX + (currentY + 1) * imageWidth];

            if (spSelectedBinary[index][currentSuperPixel] === 1 && (spSelectedBinary[index][leftSuperPixel] === 0 || spSelectedBinary[index][rightSuperPixel] === 0 || spSelectedBinary[index][upSuperPixel] == 0 || spSelectedBinary[index][downSuperPixel] == 0)) {
                border[index].push(currentX);
                border[index].push(currentY);
            }
            else if (spSelectedBinary[index][currentSuperPixel] === 0 && (spSelectedBinary[index][leftSuperPixel] === 1 || spSelectedBinary[index][rightSuperPixel] === 1 || spSelectedBinary[index][upSuperPixel] == 1 || spSelectedBinary[index][downSuperPixel] == 1)) {
                border[index].push(currentX);
                border[index].push(currentY);
            }
        }
    }

    /*
    function smoothie() {
        if (!processRunning) {
            processRunning = true;
            $.post("SuperPixelExpand",
                {
                    index: index,
                    border: selectionBorderPixels_index[index].toString(),
                    selection: selectionPixels_index[index].toString(),
                    average: selectionAverage_index[index],
                    tolerance: 0.07
                },
                function (responseText) {
                    const buffer = responseText.split('|');
                    tempSelectionBorderPixels_index[index] = buffer[0].split(',');
                    tempSelectionPixels_index[index] = buffer[1].split(',');
                    tempSelectionAverage_index[index] = buffer[2];

                    processRunning = false;
                    drawTemp();
                }
            );
        }
    }
    */
</script>

<script>

    function semiAutomate(count) {
        semiAutomateRight(count);
        semiAutomateLeft(count);
    }


    function semiAutomateRight(count) {
        if (!processRunning) {
            processRunning = true;
            superPixelCastGlobal(1, count);
        }
    }

    function superPixelCastGlobal(n, count) {
        if (n < count && index + n < imageCount && selection[index + n - 1].toString().localeCompare("") !== 0) {
            $.post("SuperPixelCast", {
                    index: index + n,
                    superPixelSize: spSize[index],
                    selection: selection[index + n - 1].toString(),
                    spOfPixels: spOfPixels[index + n - 1].toString(),
                    spAverage: spAverage[index + n - 1].toString(),
                    averageTolerance: averageTolerance,
                    coverageTolerance: coverageTolerance
                },

                function (responseText) {
                    clearArraysFor(index + n);

                    const buffer = responseText.split('|');

                    spBorder[index + n] = buffer[0].split(',');
                    spAverage[index + n] = buffer[1].split(',');
                    spCenter[index + n] = buffer[2].split(',');

                    let spBuffer = buffer[3].split("$");
                    for (let i = 0; i < spBuffer.length; i++) {
                        pixelsOfSp[index + n][i] = spBuffer[i].split(',');
                    }

                    // Clear selection
                    for (let i = 0; i < spBuffer.length; i++) {
                        spSelectedBinary[index + n][i] = 0;
                    }

                    for (let i = 0; i < imageWidth; i++) {
                        for (let j = 0; j < imageHeight; j++) {
                            selectionBinary[index + n][i + j * imageWidth] = 0;
                        }
                    }
                    // Clear selection

                    spBuffer = buffer[4].split("$");
                    for (let i = 0; i < spBuffer.length; i++) {
                        spNeighbourList[index + n][i] = spBuffer[i].split(',');
                    }

                    spOfPixels[index + n] = buffer[5].split(',');

                    selection[index + n] = buffer[6].split(',');
                    border[index + n] = buffer[7].split(',');
                    spSelected[index + n] = buffer[8].split(',');

                    for (let i = 0; i < spSelected[index + n].length; i++) {
                        spSelectedBinary[index + n][spSelected[index + n][i]] = 1;
                    }

                    average[index + n] = buffer[9];
                    spSize[index + n] = spSize[index];

                    superPixelCastGlobal(n + 1, count);
                }
            );
        }
        else {
            processRunning = false;
            alert('complete');
        }
    }

    /*
    function semiAutomateLeft(count) {
        if (!processRunning) {
            processRunning = true;
            if (count < 5) {
                $.get("SuperPixelPixelate?index=" + (index - count) + "&superPixelSize=" + superPixelSize_index[index], function (responseText) {
                    const buffer = responseText.split('|');

                    borderPixels_index[index - count] = buffer[0].split(',');
                    center_index[index] = buffer[1].split(',');
                    average_index[index] = buffer[2].split(',');
                    const bufferCluster = buffer[3].split("$");

                    pixels_index_number[index - count] = [];
                    clicked_index[index - count] = [];
                    for (let i = 0; i < bufferCluster.length; i++) {
                        pixels_index_number[index - count][i] = bufferCluster[i].split(',');
                        clicked_index[index - count][i] = 0;
                    }

                    superPixelSize_index[index - count] = superPixelSize_index[index];
                    automateLeft(count);
                    semiAutomateLeft(count + 1);
                });
            }
        }
    }
    */
</script>

<script>
    function findSuperPixel(x, y) {
        return spOfPixels[index][x + y * imageWidth];
    }

    function superPixelClick() {
        const clickedNumber = findSuperPixel(clickX, clickY);

        if (spSelectedBinary[index][clickedNumber] == 0) {
            spSelectedBinary[index][clickedNumber] = 1;
            spSelected[index].push(clickedNumber);

            for (var i = 0; i < pixelsOfSp[index][clickedNumber].length; i++) {
                selection[index].push(pixelsOfSp[index][clickedNumber][i]);
                selectionBinary[index][pixelsOfSp[index][clickedNumber][i]] = 1;
            }

        }
        else {
            spSelectedBinary[index][clickedNumber] = 0;
            spSelected[index].splice(spSelected[index].indexOf(clickedNumber.toString()), 1);

            let count = 0;
            let tempArray = [];

            for (let j = 0; j < selection[index].length; j += 2) {
                let found = false;
                for (let i = 0; i < pixelsOfSp[index][clickedNumber].length; i += 2) {
                    if ((pixelsOfSp[index][clickedNumber][i] === selection[index][j] && pixelsOfSp[index][clickedNumber][i + 1] === selection[index][j + 1])) {
                        found = true;
                        break;
                    }
                }

                if (!found) {
                    tempArray[count++] = selection[index][j];
                    tempArray[count++] = selection[index][j + 1];
                }
            }

            selection[index] = tempArray;
        }

        let sum = 0;
        for (let i = 0; i < spSelected[index].length; i++)
            sum += parseFloat(spAverage[index][spSelected[index][i]]);

        average[index] = sum / spSelected[index].length;

        refreshSelectionCanvas();
        getBorder();
        refreshSelectionBorderCanvas();
    }

    function superPixelMagic() {
        const clickIndex = findSuperPixel(clickX, clickY);

        let queue = [];
        let wandSelection = [];
        let selectionChecked = [];

        for (let i = 0; i < pixelsOfSp[index].length; i++) {
            selectionChecked[i] = false;
        }

        queue.push(clickIndex);
        let startAverage = spAverage[index][clickIndex];
        let finalAverage = startAverage;

        let count = 0;
        while (queue.length > 0) {
            let current = queue.shift();

            if (selectionChecked[current]) {
                continue;
            }

            let pixelValue = spAverage[index][current];
            if ((Math.abs(startAverage - pixelValue)) / 255.0 < averageTolerance) {
                wandSelection.push(current);
                selectionChecked[current] = true;

                count++;

                startAverage = ((parseFloat(startAverage) * (count - 1)) + parseFloat(pixelValue)) / count;
                finalAverage = ((parseFloat(startAverage) * (count - 1)) + parseFloat(pixelValue)) / count;

                for (let i = 0; i < spNeighbourList[index][current].length; i++) {
                    queue.push(spNeighbourList[index][current][i]);
                }
            }
        }

        spSelected[index] = wandSelection;

        selection[index] = [];
        count = 0;
        for (let i = 0; i < spSelected[index].length; i++) {
            for (let j = 0; j < pixelsOfSp[index][spSelected[index][i]].length; j++) {
                selection[index][count++] = pixelsOfSp[index][spSelected[index][i]][j];
            }
        }

        for (let i = 0; i < selectionChecked.length; i++)
            spSelectedBinary[index][i] = 0;
        for (let i = 0; i < spSelected[index].length; i++)
            spSelectedBinary[index][spSelected[index][i]] = 1;

        for (let i = 0; i < imageWidth * imageHeight; i++)
            selectionBinary[index][i] = 0;
        for (let i = 0; i < selection[index].length; i++)
            selectionBinary[index][selection[index][i]] = 1;

        average[index] = finalAverage;

        refreshSelectionCanvas();
        getBorder();
        refreshSelectionBorderCanvas();

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
    setCanvases();
    refresh();
</script>

</body>

</html>

<%
        }
    } catch (Exception e) {
        AlertManager.alert(response.getWriter(), request, response, "Oops", "Failed to access user directory!", "error", "welcome.jsp");
    }
%>