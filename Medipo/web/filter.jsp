<%@ page import="java.io.File" %>
<%@ page import="utils.FileManager" %>

<html>
<head>
    <script src="https://code.jquery.com/jquery-1.10.2.js"></script>
    <link href="css/slider.css" type="text/css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Cinzel+Decorative|Open+Sans:400,600i"
          rel="stylesheet">

    <title>Image Slider</title>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

</head>

<body>
<div id="navbar1">
</div>
<script>
    $(function () {
        $("#navbar1").load("navigationbar.jsp");
    });
</script>
<form action="Filters" method="post"  name="form2" id="form2">
    <input type="submit" name="confirm" value="CANNY"/>
</form>

<form action="Filters" method="post"  name="form2" id="form2">
    <input type="submit" name="confirm" value="SOBEL"/>
</form>

<%
    int slideCount = 10;
    session = request.getSession();
    String email = (String) session.getAttribute("email");
    String userDirectoryPath = FileManager.getDirPath_UserUpload(email);
    String filterDirectoryPath = FileManager.getDirPath_UserUpload(email+ "/out-sobel") ;

    File filterImagesDir = new File(filterDirectoryPath);
    File[] images = filterImagesDir.listFiles();

    File imagesMainDir = new File(userDirectoryPath);
    //File[] imagesMain = imagesDir1.listFiles();
    File[] imagesMain = imagesMainDir.listFiles((dir, i) -> i.toLowerCase().endsWith(".bmp"));

    if (imagesMain.length == 0) {
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
        //String extension = images[0].getName().substring(images[0].getName().length() - 4);

%>


<div class="containerS">

<h1 id="demo">Text</h1>

<div>
    <button class="sbutton" onclick="updateIndexButton(-1)">&#10094;</button>
    <button class="sbutton" onclick="updateIndexButton(1)">&#10095;</button>
</div>

<div class="outsideWrapper">
    <div class="insideWrapper">
        <%
            for (int i = 0; i < images.length; i++) {
                String outName = images[i].getName();
        %>
        <img id="<%=i%>" class="image"
             src="<%=FileManager.convertPathForJSP(filterDirectoryPath)%>/<%=outName%>"
         onclick="getPos(this, event)" width="100%">
    <%
        }
    %>
    <canvas id="canvas" class="coveringCanvas"></canvas>
</div>
<%--<div id="myresult" class="img-zoom-result" style="display: inline-block"></div>--%>
</div>

<div>
    <button class="sbutton" onclick="updateIndexButton(-10)">&#10094;</button>
    <button class="sbutton" onclick="updateIndexButton(10)">&#10095;</button>
</div>

<div>
    <%
        for (int i = 0; i < images.length; i++) {
            String outName = images[i].getName();
    %>
    <img class="slide" src="<%=FileManager.convertPathForJSP(filterDirectoryPath)%>/<%=outName%>"
         onclick="updateIndexSlide(this)" width="<%=(100 / slideCount) - 1%>%">
    <%
        }
    %>
</div>

<script>
    var clicks = 0;
    var den = 0;
    var lastClick = [0, 0];

    document.getElementById('canvas').addEventListener('click', drawLine, false);

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

        return [x, y];
    }

    function drawLine(e) {
        context = this.getContext('2d');

        x = getCursorPosition(e)[0] - this.offsetLeft;
        y = getCursorPosition(e)[1] - this.offsetTop;
        if (den == 0)
            den = 1;
        else if (clicks != 0) {
            clicks++;
        } else {
            context.beginPath();
            context.moveTo(lastClick[0], lastClick[1]);
            context.lineTo(x, y, 6);

            context.strokeStyle = '#ff0000';
            context.stroke();

            clicks = 0;
        }

        lastClick = [x, y];
    }
</script>

<script>
    var index = 0;

    //imageZoom(index, "myresult");

    refresh();

    function refresh() {
        refreshImage();
        refreshSlides();

        /*remove lens*/
        document.getElementsByClassName("img-zoom-lens")[0].remove();
        imageZoom(index, "myresult");
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

    function getPos(element, event) {
        var x = event.clientX;
        var y = event.clientY;
    }

    function imageZoom(imgID, resultID) {
        var img, lens, result, cx, cy;
        img = document.getElementById(imgID);
        result = document.getElementById(resultID);
        /*create lens:*/
        lens = document.createElement("DIV");
        lens.setAttribute("class", "img-zoom-lens");

        /*insert lens:*/
        img.parentElement.insertBefore(lens, img);
        /*calculate the ratio between result DIV and lens:*/
        cx = result.offsetWidth / lens.offsetWidth;
        cy = result.offsetHeight / lens.offsetHeight;
        /*set background properties for the result DIV:*/
        result.style.backgroundImage = "url('" + img.src + "')";
        result.style.backgroundSize = (img.width * cx) + "px " + (img.height * cy) + "px";
        /*execute a function when someone moves the cursor over the image, or the lens:*/
        lens.addEventListener("mousemove", moveLens);
        img.addEventListener("mousemove", moveLens);
        /*and also for touch screens:*/
        lens.addEventListener("touchmove", moveLens);
        img.addEventListener("touchmove", moveLens);

        function moveLens(e) {
            var pos, x, y;
            /*prevent any other actions that may occur when moving over the image:*/
            e.preventDefault();
            /*get the cursor's x and y positions:*/
            pos = getCursorPos(e);
            /*calculate the position of the lens:*/
            x = pos.x - (lens.offsetWidth / 2);
            y = pos.y - (lens.offsetHeight / 2);
            /*prevent the lens from being positioned outside the image:*/
            if (x > img.width - lens.offsetWidth) {
                x = img.width - lens.offsetWidth;
            }
            if (x < 0) {
                x = 0;
            }
            if (y > img.height - lens.offsetHeight) {
                y = img.height - lens.offsetHeight;
            }
            if (y < 0) {
                y = 0;
            }
            /*set the position of the lens:*/
            lens.style.left = x + "px";
            lens.style.top = y + "px";
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

            document.getElementById("demo").innerHTML = "X coords: " + (x) + ", Y coords: " + (y);

            return {x: x, y: y};
        }
    }
</script>
</div>
<img src="images/pulse.png" width="100%" alt="backg" >
</body>
</html>

<%}%>