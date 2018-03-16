<%@ page import="utils.FileManager" %>
<%@ page import="java.io.File" %>
<html>
<title>W3.CSS</title>
<body>

<h2>Manual Slideshow</h2>

<button onclick="updateIndexButton(-1)">&#10094;</button>
<button onclick="updateIndexButton(1)">&#10095;</button>

<div>
    <%
        File imageDir = new File(FileManager.getResourcesDirectory() + "/users/" + session.getAttribute("dirPath"));
        File[] images = imageDir.listFiles();
        String extension = images[0].getName().substring(images[0].getName().length() - 4);

        for (int i = 0; i < imageDir.list().length; i++) {
    %>
    <img id="<%=i%>" class="image" src="resources/users/<%=session.getAttribute("dirPath")%>/<%=(i + 1)%><%=extension%>"
         onclick="getPos(this, event)">
    <%
        }
    %>
</div>


<div>

    <%
        for (int i = 0; i < imageDir.list().length; i++) {
    %>
    <img class="slide" src="resources/users/<%=session.getAttribute("dirPath")%>/<%=(i + 1)%><%=extension%>"
         onclick="updateIndexSlide(this)" width="9%">
    <%
        }
    %>


</div>


<p id="demo">Text</p>


<script>
    var slideCount = 2;
    var index = 0;
    refreshImages(index);

    function updateIndexButton(n) {
        var images = document.getElementsByClassName("image");
        index += n;
        if(index == images.length)
            index = 0
        else if(index < 0)
            index = images.length - 1
        refresh();
    }

    function updateIndexSlide(element) {
        var images = document.getElementsByClassName("image");
        for (var i = 0; i < images.length; i++) {
            if (element.src.localeCompare(images[i].src) == 0)
                index = i;
        }
        refresh();
    }

    function refreshImages() {
        var images = document.getElementsByClassName("image")
        for (var i = 0; i < images.length; i++) {
            images[i].style.display = "none";
        }
        images[index].style.display = "block";
    }

    function refreshSlides() {
        var slides = document.getElementsByClassName("slide");
        var divResult = (index / slideCount)
        divResult = divResult.toFixed(0)

        document.getElementById("demo").innerHTML = divResult;


        for (var i = 0; i < slides.length; i++) {
            if ((i / slideCount).toFixed(0) == divResult)
                slides[i].style.display = "block";
            else
                slides[i].style.display = "none";
        }
    }

    function refresh() {
        refreshImages()
        refreshSlides()
    }

    function getPos(element, event) {
        var x = event.clientX;
        var y = event.clientY;
        document.getElementById("demo").innerHTML = "X coords: " + (x - element.offsetLeft) + ", Y coords: " + (y - element.offsetTop);
    }
</script>

</body>
</html>