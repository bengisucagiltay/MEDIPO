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

</head>
<body>

<% for(int i = 1; i <  100; i++) { %>
<div data-p="170.00">
    <img data-u="image" id="myimage<%=i%>" src="/resource/ba/im<%=i%>.bmp" />
</div>
<%}%>

</body>
</html>
