<%@ page import="utils.AlertManager" %>
<%@ page import="utils.FileManager" %>
<%@ page import="java.io.File" %>
<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8" %>
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
        </div>
        <div class="col-25" style="left: 10%;width: 50%; align-content: center; text-align: center">
            <h1 style=" text-align:center; font-family: 'Open Sans', sans-serif" >Image History</h1>
            <br><form style="display:inline-block" action="superpixelTest2.jsp" >
                <input style="height: 40px; width:150px; float:none;" type="submit" value="Magic Grid">
            </form>
            <form style="display:inline-block"action="wandTest2.jsp">
                <input  style="height: 40px; width:150px; float:none;"type="submit" value="Magic Wand">
            </form>

        </div>
        <div class="col-25" style="left: 10%;width: 50%; align-content: center; text-align: center">

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

            <br><br><br><br><br>
            <div id="carouselSlider" style="transform: scale(1.2)"></div>
            <script src='https://cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react-with-addons.min.js'></script>
            <script src='https://cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react-dom.min.js'></script>
            <script type="text/javascript" src="js/carousel.js"></script>
            <br><br><br><br><br><br><br><h1 style="padding-left: 5%" id="index">0</h1>
            <form style="align-content: center" action="Clean" method="post" style="align-content: center">
                <input style="margin-left:4%; height: 40px; width:150px; float:none;" type="submit" value="Delete History">
            </form>
        </div>

    </div>
</div>

<script>
    let index = <%=images.length/2%>;
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
        document.getElementById("index").innerText = "index: " + index;

        refreshImage();
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
    refresh();
</script>
</body>
<%}%>
</html>
