<%@ page import="utils.FileManager" %>
<%@ page import="java.io.File" %>

    <%
        if(session.getAttribute("fname") == null || session.getAttribute("fname") == "Guest")
            session.setAttribute("dirPath", "Guest");

        int slideCount = 10;
        File imagesDir = new File(FileManager.getResourcesDirectory() + "/users/" + session.getAttribute("dirPath"));
        File[] images = imagesDir.listFiles();

        if(images.length == 0) {
            System.out.println("No image");
            //JspWriter jout = pageContext.getOut();
            out.println("<script src='https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/6.11.4/sweetalert2.all.js'></script>");
            out.println("<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>");
            out.println("<script>");
            out.println("$(document).ready(function(){");
            out.println("swal ( 'Oops' ,  'There is no image history for this user..' ,  'error' )");
            out.println("});");
            out.println("</script>");

            if(session.getAttribute("fname") == null || session.getAttribute("fname") == "Guest") {
                RequestDispatcher rd = request.getRequestDispatcher("uploadGuest.jsp");
                rd.include(request, response);
            }
            else {
                RequestDispatcher rd = request.getRequestDispatcher("upload.jsp");
                rd.include(request, response);
            }
        }
        else{
            String extension = images[0].getName().substring(images[0].getName().length() - 4);

    %>


<html>
<title>Slider</title>

<head>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * {box-sizing: border-box;}
        .img-zoom-container {
            position: relative;
        }
        .img-zoom-lens {
            position: absolute;
            border: 1px solid #d4d4d4;
            /*set the size of the lens:*/
            width: 50px;
            height: 50px;
        }
        .img-zoom-result {
            /*border: 1px solid #d4d4d4;*/
            /*set the size of the result div:*/
            width: 300px;
            height: 300px;
        }
    </style>
</head>

<body>

<p id="demo">Text</p>

<div>
    <button onclick="updateIndexButton(-1)">&#10094;</button>
    <button onclick="updateIndexButton(1)">&#10095;</button>
</div>

<div class="img-zoom-container">
    <%
        for (int i = 0; i < images.length; i++) {
    %>
    <img id="<%=i%>" class="image" src="resources/users/<%=session.getAttribute("dirPath")%>/<%=(i + 1)%><%=extension%>"
         onclick="getPos(this, event)">
    <%
        }
    %>

    <div id="myresult" class="img-zoom-result" style="display: inline-block"></div>
</div>

<div>
    <button onclick="updateIndexButton(-10)">&#10094;</button>
    <button onclick="updateIndexButton(10)">&#10095;</button>
</div>

<div>
    <%
        for (int i = 0; i < images.length; i++) {
    %>
    <img class="slide" src="resources/users/<%=session.getAttribute("dirPath")%>/<%=(i + 1)%><%=extension%>"
         onclick="updateIndexSlide(this)" width="<%=(100 / slideCount) - 1%>%">
    <%
        }
    %>
</div>

<script>
    var index = 0;

    imageZoom(index, "myresult");

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

</body>
</html>

<%}%>