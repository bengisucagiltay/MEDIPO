<%@ page import="utils.AlertManager" %>
<%@ page import="utils.FileManager" %>
<%@ page import="java.io.File" %>

<%
    int slideCount = 10;

    String email;
    String userUpload = null;
    File imagesDir;
    File[] images = new File[0];

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


    <title>Image Slider</title>

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

<div class="cBig" style="top: 25%;padding-bottom: 10%">
    <div class="row">
        <div class="col-75" style="width:auto; align-content: left;">
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

        <div class="col-25" style="left: 5%;width: 50%; align-content: center">
            <h2>Adjust Threshold:</h2><br>
            <button onclick="updateThreshold(-0.01)">-&#10094;</button>
            <button onclick="updateThreshold(0.01)">&#10095;+</button><br>

            <script>
                var ijk = 0;
                var cnrlength = 0;
                while (document.getElementById("image" + ijk) != null) {
                    var a = document.getElementById("image" + ijk).src;
                    cnrdeneme.push(a);
                    ijk++;
                }
                cnrlength = ijk - 1;

            </script>
            <button style="background-color: lightcyan"onclick="zoomOut()">Zoom OUT</button>
            <button style="background-color: lightcyan"onclick="Carousel.leftClick()">Zoom IN</button>
            <br>
            <button onclick="semiAutomate(1)">Apply Selection</button>
            <button onclick="clearCanvases()">CLEAR</button><br>
            <form action="Download" method="post">
                <input type="submit" name="Submit" value="Download ZIP"/>
            </form>
            <br>
            <p id="threshold" style="display: none;">0.02</p>

            <br><br>
            <h1 style="padding-left: 5%" id="index">0</h1>

            <div id="carouselSlider" style="transform: scale(1.2)"></div>
            <script src='https://cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react-with-addons.min.js'></script>
            <script src='https://cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react-dom.min.js'></script>
            <script type="text/javascript" src="js/carousel.js"></script>
        </div>

    </div>
</div>

<script>
    //let index = 0;
    let index = <%=images.length/2%>;
    let threshold = [];
    let clickX, clickY;
    let processRunning = false;
</script>

<script>
    let selectionArray = [];
    let boundryArray = [];
    let averageArray = [];
    let centerXArray = [];
    let centerYArray = [];
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
        if (typeof threshold[index] === 'undefined')
            threshold[index] = 0.02;

        document.getElementById("index").innerText = "index: " + index;
        document.getElementById("threshold").innerText = "threshold: " + threshold[index];

        clearCanvases();
        refreshImage();
        //refreshSlides();
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
        var l_2 = document.getElementsByClassName("level-2")[0];
        var l_1 = document.getElementsByClassName("level-1")[0];
        var l1 = document.getElementsByClassName("level1")[0];
        var l2 = document.getElementsByClassName("level2")[0];
        var l0 = document.getElementsByClassName("level0")[0];


        if (typeof selectionArray[index - 2] !== 'undefined') {
            l_2.style.border = "solid #E58D1E thick";
        }
        else
            l_2.style.border = "0px";

        if (typeof selectionArray[index - 1] !== 'undefined') {
            l_1.style.border = "solid #E58D1E thick";
        }
        else
            l_1.style.border = "0px";
        if (typeof selectionArray[index + 1] !== 'undefined') {
            l1.style.border = "solid #E58D1E thick";
        }
        else
            l1.style.border = "0px";
        if (typeof selectionArray[index + 2] !== 'undefined') {
            l2.style.border = "solid #E58D1E thick";
        }
        else
            l2.style.border = "0px";

        l0.style.border = "solid #0094e2 thick ";
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
        context0.fillStyle = "#FF0000";

        canvas1.width = document.getElementById("image0").clientWidth;
        canvas1.height = document.getElementById("image0").clientHeight;
        context1.globalAlpha = 1;
        context1.fillStyle = "#0000FF";
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
        const selectionText = selectionArray[index];
        const borderText = boundryArray[index];


        const canvas0 = document.getElementById("canvas0");
        const context0 = canvas0.getContext("2d");

        const canvas1 = document.getElementById("canvas1");
        const context1 = canvas1.getContext("2d");

        context0.fillStyle = "#FF0000";
        context1.fillStyle = "#0000FF";

        var temp3=document.getElementById("canvas0");
        console.log(borderText);
        for (let i = 0; i < selectionText.length; i++) {
            selectionText[i]=(parseInt(selectionText[i])+(temp3.width-512)/2)+"";
        }
        for (let i = 0; i < borderText.length; i++) {
            borderText[i]=(parseInt(borderText[i])+ (temp3.width-512)/2)+"";
        }

        console.log(borderText);
        for (let i = 0; i < selectionText.length; i = i + 2) {
            context0.fillRect(selectionText[i], selectionText[i + 1], 1, 1);
        }
        for (let i = 0; i < borderText.length; i = i + 2) {
            context1.fillRect(borderText[i], borderText[i + 1], 1, 1);
        }
    }

    function clickOnCanvas(event) {
        const temp2 = document.getElementById("canvas0");

        clickX = event.offsetX- (temp2.width-512)/2;
        clickY = event.offsetY- (temp2.width-512)/2;
        sendClickOp();
    }
</script>

<script>
    function sendClickOp() {
        //TODO::
        if (!processRunning) {
            clearCanvases();
            processRunning = true;
            $.get("MagicWand?imageID=" + index + "&x=" + clickX + "&y=" + clickY + "&tolerance=" + threshold[index] + "&average=-1", function (responseText) {
                const buffer = responseText.split('|');
                selectionArray[index] = buffer[0].split(',');
                boundryArray[index] = buffer[1].split(',');
                averageArray[index] = buffer[2];
                centerXArray[index] = clickX;
                centerYArray[index] = clickY;

                drawOnCanvas();
                processRunning = false;
            });
        }

    }

    function updateThreshold(n) {
        threshold[index] += n;
        if (threshold[index] >= 0.2)
            threshold[index] = 0.2;
        else if (threshold[index] < 0)
            threshold[index] = 0;

        document.getElementById("threshold").innerText = threshold[index];
        sendClickOp();
    }

    /*function updateThreshold2(n) {
        threshold[index] = n;
        if (threshold[index] >= 0.2)
            threshold[index] = 0.2;
        else if (threshold[index] < 0)
            threshold[index] = 0;

        document.getElementById("threshold").innerText = threshold[index];
        sendClickOp()
    }*/
</script>

<script>
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

                const center = buffer[3].split(",");
                centerXArray[index + count] = center[0];
                centerYArray[index + count] = center[1];

                threshold[index + count] = threshold[index];

                if (averageArray[index + count] !== -1)
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

                const center = buffer[3].split(",");
                centerXArray[index - count] = center[0];
                centerYArray[index - count] = center[1];

                threshold[index - count] = threshold[index];

                if (averageArray[index - count] !== -1)
                    semiAutomateLeft(count + 1);
            });
        }
    }
</script>

<script>
    function clearCurrent() {
        selectionArray[index] = [];
        boundryArray[index] = [];
        averageArray[index] = -1;
        centerXArray[index] = -1;
        centerYArray[index] = -1;

        clearCanvases();
    }

    function clearAll() {
        selectionArray = [];
        boundryArray = [];
        averageArray = [];
        centerXArray = [];
        centerYArray = [];

        clearCanvases();
    }

</script>

<script>

    function zoomIn() {
        var temp=document.getElementById("image"+index);

        temp.width = (temp.width+100);
        temp.height = (temp.height+100);

        var temp2=document.getElementById("canvas0");
        temp2.width=(temp2.width+100);
        temp2.height=(temp2.height+100);

        temp3=document.getElementById("canvas1");
        temp3.width=(temp3.width+100);
        temp3.height=(temp3.height+100);

    }

    function zoomOut() {
        var temp=document.getElementById("image"+index);
        var value=temp.width-100;
        if(value<512)
            value=512;
        temp.width = value;
        temp.height = value;

        var temp2=document.getElementById("canvas0");
        temp2.width=value;
        temp2.height=value;

        var temp3=document.getElementById("canvas1");
        temp3.width=value;
        temp3.height=value;
    }
</script>
<script>
    setCanvases();
    refresh();
</script>
</body>
<%}%>
</html>
