<%@ page import="java.io.File" %>
<%@ page import="utils.FileManager" %>

<html>
<head>
    <%--<script src="https://code.jquery.com/jquery-1.10.2.js"></script>--%>
    <%--<link href="css/slider.css" type="text/css" rel="stylesheet">--%>
    <%--<link href="https://fonts.googleapis.com/css?family=Cinzel+Decorative|Open+Sans:400,600i"--%>
    <%--rel="stylesheet">--%>
    <%--<meta name="viewport" content="width=device-width, initial-scale=1.0">--%>

    <title>Image Slider</title>

    <style>
        div {
            position: relative;
        }

        .image {
            position: relative;
        }

        .canvas {
            position: absolute;
            left: 0px;
            top: 0px;
        }

        .img-zoom-result {
            border: 1px solid #d4d4d4;
            /*set the size of the result div:*/
            width: 300px;
            height: 300px;
            position: relative;
        }
    </style>
</head>

<body>

<%--<div id="navbar1">--%>
<%--</div>--%>
<%--<script>--%>
<%--$(function () {--%>
<%--$("#navbar1").load("navigationbar.jsp");--%>
<%--});--%>
<%--</script>--%>

<%
    //Durması lazım bunun?
    /*if ( session.getAttribute("firstname") == null|| session.getAttribute("firstname") == "Guest") {
        //session.setAttribute("email", "guest@" + session.getId());
    }*/

    int slideCount = 10;
    String email = (String) session.getAttribute("email");
    String userDirectoryPath = FileManager.getUserDirectoryPath(email);

    File imagesDir = new File(userDirectoryPath);
    //File[] images = imagesDir.listFiles();
    File[] images = imagesDir.listFiles((dir, i) -> i.toLowerCase().endsWith(".bmp"));


    if (images.length <= 0) {
        System.out.println("No image");
        //JspWriter jout = pageContext.getOut();
        out.println("<script src='https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/6.11.4/sweetalert2.all.js'></script>");
        out.println("<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>");
        out.println("<script>");
        out.println("$(document).ready(function(){");
        out.println("swal ( 'Oops' ,  'There is no image history for this user..' ,  'error' )");
        out.println("});");
        out.println("</script>");

        RequestDispatcher rd = request.getRequestDispatcher("upload.jsp");
        rd.include(request, response);

    } else {
        String extension = images[0].getName().substring(images[0].getName().length() - 4);
%>

<%--<div class="containerS">--%>

<p id="demo">demo</p>

<div>
    <button class="sbutton" onclick="updateIndexButton(-1)">&#10094;</button>
    <button class="sbutton" onclick="updateIndexButton(1)">&#10095;</button>
</div>

<div id="cnr">
    <%
        for (int i = 0; i < images.length; i++) {
    %>
    <img id="<%=i%>" class="image"
         src="<%=request.getContextPath() + FileManager.convertPathForJSP(userDirectoryPath)%>/<%=i%><%=extension%>">
    <%
        }
    %>
    <canvas id="canvas" class="canvas"></canvas>

    <button id="stopDraw" onclick="stopDraw()">Stop Draw</button>
    <button id="startDraw" onclick="startDraw()">Start Draw</button>
    <button id="clearImage" onclick="clearImage()">Clear Image</button>



</div>

<div id="myresult" class="img-zoom-result"></div>

<div>
    <button class="sbutton" onclick="updateIndexButton(-10)">&#10094;</button>
    <button class="sbutton" onclick="updateIndexButton(10)">&#10095;</button>
</div>

<div>
    <%
        System.out.println(images.length);
        for (int i = 0; i < images.length; i++) {
    %>
    <img class="slide"
         src="<%=request.getContextPath() + FileManager.convertPathForJSP(userDirectoryPath)%>/<%=i%><%=extension%>"
         onclick="updateIndexSlide(this)" width="<%=(100 / slideCount) - 1%>%">
    <%
        }
    %>
</div>

<a href="<%=request.getContextPath() + FileManager.convertPathForJSP(FileManager.getUsersDirectoryPath()) + "/" + session.getAttribute("firstname")%>.zip">download</a>


<%--<script>--%>

<%--var c = document.getElementById("canvas2");--%>
<%--var ctx = c.getContext("2d");--%>
<%--ctx.beginPath();--%>
<%--ctx.moveTo(15, 0);--%>
<%--ctx.lineTo(15, 20);--%>
<%--ctx.moveTo(0, 10);--%>
<%--ctx.lineTo(30, 10);--%>
<%--ctx.strokeStyle="#ff0000";--%>
<%--ctx.stroke();--%>

<%--function myFunction() {--%>
<%--document.getElementById("canvas").removeEventListener('click', drawLine);--%>
<%--}--%>
<%--</script>--%>


<script>
    imageZoom("1", "myresult");

    function imageZoom(imgID, resultID) {
        var img, lens, result, cx, cy;
        img = document.getElementById(imgID);
        result = document.getElementById(resultID);
        temp = document.getElementById("canvas");
        /*create lens:*/

        /*calculate the ratio between result DIV and lens:*/
        cx = result.offsetWidth / 40;
        cy = result.offsetHeight / 40;
        /*set background properties for the result DIV:*/
        result.style.backgroundImage = "url('" + img.src + "')";
        result.style.backgroundSize = (img.width * cx) + "px " + (img.height * cy) + "px";
        /*execute a function when someone moves the cursor over the image, or the lens:*/

        temp.addEventListener("mousemove", moveLens);
        /*and also for touch screens:*/
        temp.addEventListener("touchmove", moveLens);

        function moveLens(e) {
            var pos, x, y;
            /*prevent any other actions that may occur when moving over the image:*/
            e.preventDefault();
            /*get the cursor's x and y positions:*/
            pos = getCursorPos(e);
            /*calculate the position of the lens:*/
            x = pos.x - 20;
            y = pos.y - 20;
            /*prevent the lens from being positioned outside the image:*/
            if (x > img.width - 40) {
                x = img.width - 40;
            }
            if (x < 0) {
                x = 0;
            }
            if (y > img.height - 40) {
                y = img.height - 40;
            }
            if (y < 0) {
                y = 0;
            }
            /*set the position of the lens:*/

            /*display what the lens "sees":*/
            result.style.backgroundPosition = "-" + (x * cx) + "px -" + (y * cy) + "px";
        }

        function getCursorPos(e) {
            var a, x = 0, y = 0;
            e = e || window.event;
            /*get the x and y positions of the image:*/
            a = img.getBoundingClientRect();
            /*calculate the cursor's x and y coordinates, relative to the image:*/
            x = e.pageX - a.left;
            y = e.pageY - a.top;
            /*consider any page scrolling:*/
            x = x - window.pageXOffset;
            y = y - window.pageYOffset;

            return {x: x, y: y};
        }
    }
</script>

<script>

    setSize();

    var clicks = 0;
    var den = 0;
    var lastClick = [0, 0];
    document.getElementById('canvas').addEventListener('click', drawLine);

    function getCursorPosition(e) {
        var x;
        var y;
        if (e.pageX != undefined && e.pageY != undefined) {
            x = e.pageX;
            y = e.pageY;
        } else {
            x = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
            y = e.clientY + document.body.scrollTop + document.documentElement.scrollTop;
        }

        x = x - document.getElementById('cnr').offsetLeft;
        y = y - document.getElementById('cnr').offsetTop;

        return [x, y];
    }

    function drawLine(e) {

        var context = this.getContext('2d');

        x = getCursorPosition(e)[0] - this.offsetLeft;
        y = getCursorPosition(e)[1] - this.offsetTop;


        if (den == 0)
            den = 1;
        else if (clicks != 0) {
            clicks++;
        } else {
            context.beginPath();
            context.moveTo(lastClick[0], lastClick[1]);
            context.lineTo(x, y);

            document.getElementById("demo").innerHTML = "x: " + x + " y: " + y;


            context.strokeStyle = '#00ff00';
            context.stroke();

            clicks = 0;
        }

        lastClick = [x, y];
    }

    function setSize() {
        var canvas = document.getElementById("canvas");
        canvas.width = 512;
        canvas.height = 512;
    }

    function stopDraw(){
       document.getElementById("canvas").removeEventListener('click', drawLine);
    }


    function startDraw(){
        document.getElementById("canvas").addEventListener('click', drawLine);
    }

    function clearImage(){
        var canvas=document.getElementById("canvas");
        var context=canvas.getContext("2d");
        context.clearRect(0,0,canvas.width,canvas.height);

        clicks = 0;
        den = 0;
        lastClick = [0, 0];
    }
</script>

<script>
    var index = 0;

    refresh();

    function refresh() {
        refreshImage();
        refreshSlides();
        clearCanvas();
        changeZoom();
    }

    function refreshImage() {
        var images = document.getElementsByClassName("image");
        for (var i = 0; i < images.length; i++) {
            images[i].style.display = "none";
        }
        images[index].style.display = "inline-block";
    }

    function refreshSlides() {
        var slides = document.getElementsByClassName("slide");
        var divResult = Math.floor(index / <%=slideCount%>);

        for (var i = 0; i < slides.length; i++) {
            if (Math.floor(i / <%=slideCount%>) === divResult)
                slides[i].style.display = "inline-block";
            else
                slides[i].style.display = "none";
        }
    }

    function updateIndexButton(n) {
        var images = document.getElementsByClassName("image");
        index += n;
        if (index >= images.length)
            index = 0;
        else if (index < 0)
            index = images.length - 1;
        refresh();
    }

    function updateIndexSlide(element) {
        var images = document.getElementsByClassName("image");
        for (var i = 0; i < images.length; i++) {
            if (element.src.localeCompare(images[i].src) === 0)
                index = i;
        }
        refresh();
    }

    function clearCanvas(){
        var canvas=document.getElementById("canvas");
        var context=canvas.getContext("2d");
        context.clearRect(0,0,canvas.width,canvas.height);

        clicks = 0;
        den = 0;
        lastClick = [0, 0];
    }

    function changeZoom(){
        imageZoom(index, "myresult");
    }

    function getPos(element, event) {
        var x = event.clientX;
        var y = event.clientY;
    }
</script>
</div>

</body>

</html>

<%}%>