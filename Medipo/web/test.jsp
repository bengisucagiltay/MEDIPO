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
    <link rel='stylesheet prefetch' href='https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.css'>
    <link rel='stylesheet prefetch' href='https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/svgs/fi-list.svg'>


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
        }

        .canvas3 {
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

    <style>
        .slidecontainer {
            width: 100%;
        }

        .slider {
            -webkit-appearance: none;
            width: 100%;
            height: 10px;
            border-radius: 5px;
            background: #ffffff;
            outline: none;
            opacity: 0.7;
            -webkit-transition: .2s;
            transition: opacity .2s;

        }

        .slider:hover {
            opacity: 1;
        }

        .slider::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 30px;
            height: 30px;
            border: none;
            background: url('images/bb.png');
            cursor: pointer;
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

    var cnrdeneme = [];
</script>


<div class="cBig">

    <div class="row">
        <div class="col-75" style="text-align: left;width:512px;height:512px;position: sticky;overflow: auto;
	 white-space: nowrap;">
            <%
                for (int i = 0; i < images.length; i++) {
            %>
            <img id="image<%=i%>" class="image"
                 src="<%=request.getContextPath() + FileManager.convertPathForJSP(userUpload)%>/<%=i + extension%>">
            <%
                }
            %>

            <canvas id="canvas0" class="canvas" onclick="clickOnCanvas(event)"></canvas>
            <canvas id="canvas1" class="canvas" onclick="clickOnCanvas(event)"></canvas>
        </div>

        <div class="col-25">
            <h1>Adjust Threshold:</h1><br>
            <div class="slidecontainer">
                <input type="range" min="2" max="10" value="2" class="slider" id="myRange">
                <p>Value: <span id="demo"></span></p>
            </div>

            <script>
                var ijk = 0;
                while (document.getElementById("image" + ijk) != null) {
                    var a = document.getElementById("image" + ijk).src;
                    cnrdeneme.push(a);
                    ijk++;
                }
                var slider = document.getElementById("myRange");
                var output = document.getElementById("demo");
                output.innerHTML = slider.value;

                slider.oninput = function () {

                    updateThreshold2(this.value / 100);
                    output.innerHTML = slider.value;
                }

                function increase() {
                    updateThreshold(0.01);
                    slider.value++;
                    output.innerHTML = slider.value;
                }

                function decrease() {
                    updateThreshold(-0.01);
                    slider.value--;
                    output.innerHTML = slider.value;
                }
            </script>

            <button onclick="semiAutomate(1)">PAINT</button>
            <!--<br>
            <button onclick="decrease()">DECREASE</button>
            <button onclick="increase()">INCREASE</button>
            <br>-->
            <button onclick="clearSelection()">CLEAR</button>
            <button onclick="zoomIn()">Zoom IN</button>
            <button onclick="zoomOut()">Zoom Out</button>
            <br>
            <p id="threshold">0.02</p><br><br>

            <div>
                <h2 style="float: left;width: 20px;height: 20px;margin: 5px;  border: 1px solid rgba(0, 0, 0, .2); background-color: #0094e2"></h2>
                <h2 style="float: left"> : Current Slice</h2><br><br>
                <h2 style="float: left;width: 20px;height: 20px;margin: 5px;  border: 1px solid rgba(0, 0, 0, .2); background-color: red"></h2>
                <h2 style="float: left"> : Edited Slices</h2><br>
                <!--<h2 style="float: left;width: 20px;height: 20px;margin: 5px;  border: 1px solid rgba(0, 0, 0, .2);
                background-color: whitesmoke"></h2>
                <h2 style="float: left"> : Default Style</h2><br>-->
            </div>
            <br><br><br>
            <a href="<%=request.getContextPath() + FileManager.convertPathForJSP(FileManager.getDirPath_User(email)) + "/" + session.getAttribute("firstname")%>.zip">download</a>


        </div>

    </div>

    <h1 id="index">0</h1>

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

    </div>
    <div id="carouselSlider"></div>
    <script src='https://cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react-with-addons.min.js'></script>
    <script src='https://cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react-dom.min.js'></script>
    <script type="text/javascript" src="js/carousel.js"></script>
    <br><br><br><br><br><br><br><br>

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
        const myImg = document.getElementsByClassName("image");
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
            //slides1[i].style.display = "inline-block";
                slides1[i].style.display = "none";//invisible

            else
                slides1[i].style.display = "none";
        }

        for (let i = 0; i < slides2.length; i++) {
            if (i == index) {
                //slides2[i].style.border ="5px solid blue";
                //slides2[i].style.display = "inline-block";
                slides2[i].style.display = "none";//invisible


            }
            else if (i <= index + 5 && i >= index - 5) {
                //slides2[i].style.display = "inline-block";
                //slides2[i].style.border ="5px";
                slides2[i].style.display = "none";//invisible


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

        var temp3=document.getElementById("canvas0");
        console.log(borderText);
        for (let i = 0; i < fillText.length; i++) {
            fillText[i]=(parseInt(fillText[i])+(temp3.width-512)/2)+"";
        }
        for (let i = 0; i < borderText.length; i++) {
            borderText[i]=(parseInt(borderText[i])+ (temp3.width-512)/2)+"";
        }

        console.log(borderText);
        for (let i = 0; i < fillText.length; i = i + 2) {
            context0.fillRect(fillText[i], fillText[i + 1], 1, 1);
        }
        for (let i = 0; i < borderText.length; i = i + 2) {
            context1.fillRect(borderText[i], borderText[i + 1], 1, 1);
        }
    }

    function clickOnCanvas(event) {
        var temp2=document.getElementById("canvas0");

        clickX = event.offsetX- (temp2.width-512)/2;
        clickY = event.offsetY- (temp2.width-512)/2;
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

    function updateThreshold2(n) {
        threshold[index] = n;
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

        temp3=document.getElementById("canvas1");
        temp3.width=value;
        temp3.height=value;
    }
</script>

<script>
    setCanvasSize();
    refresh();
</script>

</body>
<%}%>
</html>
