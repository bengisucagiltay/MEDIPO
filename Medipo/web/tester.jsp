<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.ByteArrayOutputStream" %><%--
  Created by IntelliJ IDEA.
  User: Ege
  Date: 08-Feb-18
  Time: 17:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>

    <%
        BufferedImage bImage = ImageIO.read(new File("./resource/ba/im100.bmp"));//give the path of an image
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write( bImage, "bmp", baos );
        baos.flush();
        byte[] imageInByteArray = baos.toByteArray();

        baos.close();

        String b64 = javax.xml.bind.DatatypeConverter.printBase64Binary(imageInByteArray);
    %>
    <img src="data:image/jpg;base64, <%=b64%>" alt="Image not found" />
</head>
<body>

</body>
</html>
