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
    <title>Wand</title>

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
    <button onclick="updateThreshold(-0.01)" style="display: inline-block">&#10094;</button>
    <p id="threshold" style="display: inline-block">threshold: 0.01</p>
    <button onclick="updateThreshold(0.01)" style="display: inline-block">&#10095;</button>
</div>

<div>
    <button onclick="semiAutomateLeft(1)">AUTO LEFT 4</button>
    <button onclick="semiAutomate(1)">AUTO BOTH 4</button>
    <button onclick="semiAutomateRight(1)">AUTO RIGHT 4</button>
</div>

<div>
    <button onclick="clearCurrent()">CLEAR</button>
    <button onclick="clearAll()">CLEAR ALL</button>
</div>

<script>
    let index = <%=images.length/2%>;
    let processRunning = false;
    let processRunningRight = false;
    let processRunningLeft = false;
</script>

<script>
    let selectionArray = [];
    let borderArray = [];
    let averageArray = [];
    let threshold = [];
    let centerXArray = [];
    let centerYArray = [];
    let clickXArray = [];
    let clickYArray = [];
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
            threshold[index] = 0.01;

        document.getElementById("index").innerText = "index: " + index;
        document.getElementById("threshold").innerText = "threshold: " + threshold[index].toFixed(2);

        refreshImage();
        refreshSlides();
        clearCanvases();
        drawOnCanvases();
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
            else if (typeof selectionArray[i] !== 'undefined') {
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

        canvas0.width = document.getElementById("image" + index).clientWidth;
        canvas0.height = document.getElementById("image" + index).clientHeight;

        canvas1.width = document.getElementById("image" + index).clientWidth;
        canvas1.height = document.getElementById("image" + index).clientHeight;
        context1.globalAlpha = 0.25;
        context1.fillStyle = "#FF0000";

        canvas2.width = document.getElementById("image" + index).clientWidth;
        canvas2.height = document.getElementById("image" + index).clientHeight;
        context2.globalAlpha = 0.5;
        context2.fillStyle = "#00FF00";
    }

    function clearCanvases() {
        const canvas0 = document.getElementById("canvas0");
        const context0 = canvas0.getContext("2d");
        const canvas1 = document.getElementById("canvas1");
        const context1 = canvas1.getContext("2d");
        const canvas2 = document.getElementById("canvas2");
        const context2 = canvas2.getContext("2d");

        context0.clearRect(0, 0, canvas0.width, canvas0.height);
        context1.clearRect(0, 0, canvas1.width, canvas1.height);
        context2.clearRect(0, 0, canvas1.width, canvas1.height);
    }

    function drawOnCanvases() {
        const canvas1 = document.getElementById("canvas1");
        const context1 = canvas1.getContext("2d");
        const canvas2 = document.getElementById("canvas2");
        const context2 = canvas2.getContext("2d");

        const selection = selectionArray[index];
        const border = borderArray[index];

        if (typeof selection !== "undefined") {
            for (let i = 0; i < selection.length; i = i + 2) {
                context1.fillRect(selection[i], selection[i + 1], 1, 1);
            }
        }

        if (typeof border !== "undefined") {
            for (let i = 0; i < border.length; i = i + 2) {
                context2.fillRect(border[i], border[i + 1], 1, 1);
            }
        }
    }

    function clickOnCanvas(event) {
        clickXArray[index] = event.offsetX;
        clickYArray[index] = event.offsetY;

        sendClickOp();
    }
</script>

<script>
    function updateThreshold(n) {
        threshold[index] += n;
        if (threshold[index] >= 0.2)
            threshold[index] = 0.2;
        else if (threshold[index] <= 0.01)
            threshold[index] = 0.01;

        document.getElementById("threshold").innerText = "threshold: " + threshold[index].toFixed(2);

        sendClickOp();
    }

    function sendClickOp() {
        if (!processRunning && (index >= 0) && (index < <%=images.length%>) && typeof clickXArray[index] !== 'undefined' && typeof clickYArray[index] !== 'undefined' && typeof threshold[index] !== 'undefined') {
            processRunning = true;
            $.get("WandMagic?imageID=" + index + "&x=" + clickXArray[index] + "&y=" + clickYArray[index] + "&tolerance=" + threshold[index], function (responseText) {
                const buffer = responseText.split('|');
                selectionArray[index] = buffer[0].split(',');
                borderArray[index] = buffer[1].split(',');
                averageArray[index] = buffer[2];
                const centerBuffer = buffer[3].split(',');
                centerXArray[index] = centerBuffer[0];
                centerYArray[index] = centerBuffer[1];

                processRunning = false;
                refresh();
            });
        }
    }
</script>

<script>
    function semiAutomate(count) {
        semiAutomateRight(count);
        semiAutomateLeft(count);
    }

    function semiAutomateRight(count) {
        if (count < 5 && (index + count) < <%=images.length%>) {
            clickXArray[index + count] = centerXArray[index + count - 1];
            clickYArray[index + count] = centerYArray[index + count - 1];
            threshold[index + count] = threshold[index];

            if (!processRunningRight && typeof clickXArray[index + count] !== 'undefined' && typeof clickYArray[index + count] !== 'undefined' && typeof threshold[index + count] !== 'undefined') {
                processRunningRight = true;
                $.get("WandMagic?imageID=" + (index + count) + "&x=" + clickXArray[index + count] + "&y=" + clickYArray[index + count] + "&tolerance=" + threshold[index + count], function (responseText) {
                    const buffer = responseText.split('|');
                    selectionArray[index + count] = buffer[0].split(',');
                    borderArray[index + count] = buffer[1].split(',');
                    averageArray[index + count] = buffer[2];
                    const center = buffer[3].split(",");
                    centerXArray[index + count] = center[0];
                    centerYArray[index + count] = center[1];

                    processRunningRight = false;

                    if (Math.abs(averageArray[index + count - 1] - averageArray[index + count]) / 255 < 0.05) {
                        refresh();
                        semiAutomateRight(count + 1);
                    }
                    else
                        clear(index + count);
                });
            }
        }
    }

    function semiAutomateLeft(count) {
        if (count < 5 && (index - count) >= 0) {
            clickXArray[index - count] = centerXArray[index - count + 1];
            clickYArray[index - count] = centerYArray[index - count + 1];
            threshold[index - count] = threshold[index];

            if (!processRunningLeft && typeof clickXArray[index - count] !== 'undefined' && typeof clickYArray[index - count] !== 'undefined' && typeof threshold[index - count] !== 'undefined') {
                processRunningLeft = true;
                $.get("WandMagic?imageID=" + (index - count) + "&x=" + clickXArray[index - count] + "&y=" + clickYArray[index - count] + "&tolerance=" + threshold[index - count], function (responseText) {
                    const buffer = responseText.split('|');
                    selectionArray[index - count] = buffer[0].split(',');
                    borderArray[index - count] = buffer[1].split(',');
                    averageArray[index - count] = buffer[2];
                    const center = buffer[3].split(",");
                    centerXArray[index - count] = center[0];
                    centerYArray[index - count] = center[1];

                    processRunningLeft = false;

                    if (Math.abs(averageArray[index - count + 1] - averageArray[index - count]) / 255 < 0.05) {
                        refresh();
                        semiAutomateLeft(count + 1);
                    }
                    else
                        clear(index - count);
                });
            }
        }
    }
</script>

<script>
    function clearCurrent() {
        selectionArray[index] = undefined;
        borderArray[index] = undefined;
        averageArray[index] = undefined;
        threshold[index] = undefined;
        centerXArray[index] = undefined;
        centerYArray[index] = undefined;
        clickXArray[index] = undefined;
        clickYArray[index] = undefined;

        refresh();
    }

    function clear(clearIndex) {
        selectionArray[clearIndex] = undefined;
        borderArray[clearIndex] = undefined;
        averageArray[clearIndex] = undefined;
        threshold[clearIndex] = undefined;
        centerXArray[clearIndex] = undefined;
        centerYArray[clearIndex] = undefined;
        clickXArray[clearIndex] = undefined;
        clickYArray[clearIndex] = undefined;

        refresh();
    }

    function clearAll() {
        selectionArray = undefined;
        borderArray = undefined;
        averageArray = undefined;
        threshold = undefined;
        centerXArray = undefined;
        centerYArray = undefined;
        clickXArray = undefined;
        clickYArray = undefined;

        selectionArray = [];
        borderArray = [];
        averageArray = [];
        threshold = [];
        centerXArray = [];
        centerYArray = [];
        clickXArray = [];
        clickYArray = [];

        refresh();
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