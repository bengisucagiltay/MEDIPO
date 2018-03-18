<%@ page import="utils.FileManager" %>
<%@ page import="java.io.File" %><%--
  Created by IntelliJ IDEA.
  User: Ege
  Date: 20-Feb-18
  Time: 00:03
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    String userFolder = FileManager.getResourcesDirectoryPath() + "/users/" + ((String)request.getSession().getAttribute("mail")).replace('@','-');
    File f = new File(userFolder);
    for(int i = 1; i < f.list().length + 1; i++) {

%>
<div>
    <img src="<%=userFolder%>/<%=i%>.jpg" alt="<%=i%>"/>
</div>
<%}%>
</body>
</html>
