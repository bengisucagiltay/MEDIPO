<%@ page import="utils.AlertManager" %>
<%@ page import="utils.FileManager" %>
<%@ page import="java.io.File" %>

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

<html>

<head>
    <title>Super Pixel</title>

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
            width: 10%;
        }
    </style>

    <script src="js/jquery-1.10.2.js"></script>
</head>

<body>

<div>
    <button onclick="buttonUpdateIndex(-1)" style="display: inline-block">&#10094;</button>
    <p id="index" style="display: inline-block">index: <%=images.length / 2%>></p>
    <button onclick="buttonUpdateIndex(1)" style="display: inline-block">&#10095;</button>
</div>

<div>
    <%
        for (int i = 0; i < images.length; i++) {
    %>
    <img id="image<%=i%>" class="image" style="display: inline-block"
         src="<%=request.getContextPath() + FileManager.convertPathForJSP(userUpload)%>/<%=i + extension%>">
    <%
        }
    %>
    <canvas id="canvas3" class="canvas"></canvas>
    <canvas id="canvas2" class="canvas"></canvas>
    <canvas id="canvas1" class="canvas"></canvas>
    <canvas id="canvas0" class="canvas" onclick="clickOnCanvas(event)"></canvas>
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

<div>
    <button onclick="updateSuperPixelSize(-1)" style="display: inline-block">&#10094;</button>
    <p id="superPixelSize" style="display: inline-block">superPixelSize: 10</p>
    <button onclick="updateSuperPixelSize(1)" style="display: inline-block">&#10095;</button>
</div>

<div>
    <button onclick="semiAutomateLeft(1)">AUTO LEFT 4</button>
    <button onclick="semiAutomate(1)">AUTO BOTH 4</button>
    <button onclick="semiAutomateRight(1)">AUTO RIGHT 4</button>
</div>

<div>
    <button id="magic" onclick="changeTool()">Current Selection: Single Region</button>
</div>

<div>
    <button onclick="clearCurrent()">CLEAR</button>
    <button onclick="clearAll()">CLEAR ALL</button>
</div>

<script>
    let size = <%=images.length%>;
    let index = <%=images.length/2%>;
    let processRunning = false;
    let processRunningRight = false;
    let processRunningLeft = false;
    let isMagic = false;
    let clickX, clickY;
</script>

<script>
    let superPixelSize = [];
    var borderArray = [];
    var selectionArray = [];
    var selectionBorderArray = [];
    var selectionAverageArray = [];
    var centerArray = [];
    var averageArray = [];
    var pixelArray = [];
    var clickedArray = [];
    var tempSelectionArray = [];
    var tempBorderArray = [];
    var tempSelectionAverageArray = [];

    for (let i = 0; i < size; i++) {
        superPixelSize[i] = 10;
        borderArray[i] = [];
        selectionArray[i] = [];
        selectionBorderArray[i] = [];
        selectionAverageArray[i] = -1;
        averageArray[i] = [];
        centerArray[i] = [];
        pixelArray[i] = [];
        clickedArray[i] = [];
        tempSelectionArray[i] = [];
        tempBorderArray[i] = [];
        tempSelectionAverageArray[i] = [];
    }
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
        if (borderArray[index].length === 0) {
            superPixelization();
        }

        document.getElementById("index").innerText = "index: " + index;
        document.getElementById("superPixelSize").innerText = superPixelSize[index];

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

        for (let i = 0; i < slides.length; i++) {
            if (index === i) {
                slides[i].border = "3";
                slides[i].style.borderColor = "purple";
            }
            else if (selectionArray[i].length !== 0) {
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
</script>

<script>
    function setCanvases() {
        const canvas0 = document.getElementById("canvas0");
        const canvas1 = document.getElementById("canvas1");
        const context1 = canvas1.getContext("2d");
        const canvas2 = document.getElementById("canvas2");
        const context2 = canvas2.getContext("2d");
        const canvas3 = document.getElementById("canvas3");
        const context3 = canvas3.getContext("2d");

        canvas0.width = document.getElementById("image" + index).clientWidth;
        canvas0.height = document.getElementById("image" + index).clientHeight;

        canvas1.width = document.getElementById("image" + index).clientWidth;
        canvas1.height = document.getElementById("image" + index).clientHeight;
        context1.globalAlpha = 0.60;
        context1.fillStyle = "#FF0000";

        canvas2.width = document.getElementById("image" + index).clientWidth;
        canvas2.height = document.getElementById("image" + index).clientHeight;
        context2.globalAlpha = 0.40;
        context2.fillStyle = "#00FF00";

        canvas3.width = document.getElementById("image" + index).clientWidth;
        canvas3.height = document.getElementById("image" + index).clientHeight;
        context3.globalAlpha = 0.20;
        context3.fillStyle = "#0000FF";
    }

    function clearCanvases() {
        const canvas0 = document.getElementById("canvas0");
        const context0 = canvas0.getContext("2d");
        const canvas1 = document.getElementById("canvas1");
        const context1 = canvas1.getContext("2d");
        const canvas2 = document.getElementById("canvas2");
        const context2 = canvas2.getContext("2d");
        const canvas3 = document.getElementById("canvas3");
        const context3 = canvas3.getContext("2d");

        context0.clearRect(0, 0, canvas0.width, canvas0.height);
        context1.clearRect(0, 0, canvas1.width, canvas1.height);
        context2.clearRect(0, 0, canvas1.width, canvas1.height);
        context3.clearRect(0, 0, canvas1.width, canvas1.height);
    }

    function drawOnCanvas() {
        const canvas1 = document.getElementById("canvas1");
        const context1 = canvas1.getContext("2d");
        const canvas2 = document.getElementById("canvas2");
        const context2 = canvas2.getContext("2d");
        const canvas3 = document.getElementById("canvas3");
        const context3 = canvas3.getContext("2d");

        const selection = selectionArray[index];
        const border = borderArray[index];
        const selectionBorder = selectionBorderArray[index];

        if (selectionBorder.length !== 0) {
            for (let i = 0; i < selectionBorder.length; i = i + 2) {
                context1.fillRect(selectionBorder[i], selectionBorder[i + 1], 1, 1);
            }
        }

        if (border.length !== 0) {
            for (let i = 0; i < border.length; i = i + 2) {
                context2.fillRect(border[i], border[i + 1], 1, 1);
            }
        }

        if (selection.length !== 0 || typeof selectionArray[index] !== 'undefined') {
            for (let i = 0; i < selection.length; i++) {
                for (let j = 0; j < pixelArray[index][selection[i]].length; j++) {
                    context3.fillRect(pixelArray[index][selection[i]][j], pixelArray[index][selection[i]][j + 1], 1, 1);
                }
            }
        }
    }

    function clickOnCanvas(event) {
        clickX = event.offsetX;
        clickY = event.offsetY;

        if (isMagic) {
            magicSuperPixel()
        }
        else {
            clickPixel();
        }
    }
</script>

<script>
    function updateSuperPixelSize(n) {
        superPixelSize[index] += n;
        if (superPixelSize[index] > 100)
            superPixelSize[index] = 100;
        else if (superPixelSize[index] < 5)
            superPixelSize[index] = 5;

        document.getElementById("superPixelSize").innerText = superPixelSize[index];

        if (selectionArray[index].length !== 0)
            castSuperPixel();
        else
            superPixelization(false);
    }

    function superPixelization() {
        if (!processRunning) {
            processRunning = true;
            $.get("SuperPixelization?imageID=" + index + "&superPixelSize=" + superPixelSize[index], function (responseText) {
                const buffer = responseText.split('|');
                borderArray[index] = buffer[0].split(',');
                centerArray[index] = buffer[1].split(',');
                averageArray[index] = buffer[2].split(',');
                const clusterBuffer = buffer[3].split("$");

                pixelArray[index] = [];
                clickedArray[index] = [];
                for (let i = 0; i < clusterBuffer.length; i++) {
                    pixelArray[index][i] = clusterBuffer[i].split(',');
                    clickedArray[index][i] = 0;
                }

                processRunning = false;
                refresh();
            });
        }
    }

    function magicSuperPixel() {
        const clickIndex = findSuperPixel(clickX, clickY);
        $.get("SuperPixelMagic?imageID=" + index + "&superPixelSize=" + superPixelSize[index] + "&clickIndex=" + clickIndex + "&tolerance=0.035", function (responseText) {
            const buffer = responseText.split('|');
            borderArray[index] = buffer[0].split(',');
            centerArray[index] = buffer[1].split(',');
            averageArray[index] = buffer[2].split(',');
            const clusterBuffer = buffer[3].split("$");
            selectionArray[index] = buffer[4].split(',');
            selectionBorderArray[index] = buffer[5].split(',');

            pixelArray[index] = [];
            clickedArray[index] = [];
            for (let i = 0; i < clusterBuffer.length; i++) {
                pixelArray[index][i] = clusterBuffer[i].split(',');
                clickedArray[index][i] = 0;
            }

            for (let i = 0; i < selectionArray[index].length; i++)
                clickedArray[index][selectionArray[index][i]] = 1;

            processRunning = false;
            refresh();
        });
    }

    function castSuperPixel() {
        if (!processRunning) {
            processRunning = true;
            $.post("SuperPixelCast", {
                    imageID: index,
                    superPixelSize: superPixelSize[index],
                    selection: selectionArray[index].toString(),
                    tolerance: 0.5
                }, function (responseText) {
                    const buffer = responseText.split('|');
                    borderArray[index] = buffer[0].split(',');
                    centerArray[index] = buffer[1].split(',');
                    averageArray[index] = buffer[2].split(',');
                    const clusterBuffer = buffer[3].split("$");
                    selectionArray[index] = buffer[4].split(',');
                    selectionBorderArray[index] = buffer[5].split(',');

                    pixelArray[index] = [];
                    clickedArray[index] = [];

                    for (let i = 0; i < clusterBuffer.length; i++) {
                        pixelArray[index][i] = clusterBuffer[i].split(',');
                        clickedArray[index][i] = 0;
                    }

                    for (let i = 0; i < selectionArray[index].length; i++)
                        clickedArray[index][selectionArray[index][i]] = 1;

                    processRunning = false;
                    refresh();
                }
            );
        }
    }

    function smoothie() {
        if (!processRunning) {
            processRunning = true;
            $.post("SuperPixelExpand",
                {
                    imageID: index,
                    border: selectionBorderArray[index].toString(),
                    selection: selectionArray[index].toString(),
                    average: selectionAverageArray[index],
                    tolerance: 0.07
                },
                function (responseText) {
                    const buffer = responseText.split('|');
                    tempBorderArray[index] = buffer[0].split(',');
                    tempSelectionArray[index] = buffer[1].split(',');
                    tempSelectionAverageArray[index] = buffer[2];

                    updateSelection();

                    processRunning = false;
                }
            );
        }
    }
</script>

<script>
    function semiAutomate(count) {
        semiAutomateRight(count);
        //semiAutomateLeft(count);
    }

    function semiAutomateRight(count) {
        if (count < 5) {

            // clickX and clickY are -1 since magic wand does not work for this call.
            $.get("SuperPixelization?imageID=" + (index + count) + "&superPixelSize=" + superPixelSize[index] + "&clickIndex=-1" + "&tolerance=-1.0", function (responseText) {
                const buffer = responseText.split('|');
                borderArray[index + count] = buffer[0].split(',');
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

                automateSuperPixels(count);

                if (averageArray[index + count] !== -1)
                    semiAutomateRight(count + 1);
            });
        }
    }

    function semiAutomateLeft(count) {

        if (count < 5) {
            $.get("WandMagic?imageID=" + (index - count) + "&x=" + centerXArray[index - count + 1] + "&y=" + centerYArray[index - count + 1] + "&tolerance=" + superPixelSize[index] + "&average=" + averageArray[index - count + 1], function (responseText) {
                const buffer = responseText.split('|');
                selectionArray[index - count] = buffer[0].split(',');
                borderArray[index - count] = buffer[1].split(',');
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

    function automateSuperPixels(count) {
        for (let i = 0; i < clickedArray[index + count - 1].length; i++) {
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
    function findSuperPixel(x, y) {
        let distance = (x - centerArray[index][0]) * (x - centerArray[index][0]) + (y - centerArray[index][1]) * (y - centerArray[index][1]);
        let nearestIndex = 0;

        for (let i = 2; i < centerArray[index].length; i += 2) {
            const temp = (x - centerArray[index][i]) * (x - centerArray[index][i]) + (y - centerArray[index][i + 1]) * (y - centerArray[index][i + 1]);

            if (temp < distance) {
                distance = temp;
                nearestIndex = i / 2;
            }
        }

        return nearestIndex;
    }

    function clickPixel() {
        const clickedIndex = findSuperPixel(clickX, clickY);

        if (clickedArray[index][clickedIndex] === 0) {
            clickedArray[index][clickedIndex] = 1;
            selectionArray[index].push(clickedIndex);
        }
        else {
            clickedArray[index][clickedIndex] = 0;
            selectionArray[index].splice(selectionArray[index].indexOf(clickedIndex.toString()), 1);
        }

        refresh();
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