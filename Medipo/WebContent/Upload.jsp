<%@page import="java.io.DataInputStream"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Medipo - Upload</title>
</head>
<body>

	<%
		if(session.getAttribute("username")== null){	//user not registered (guest)
			response.sendRedirect("Login.jsp");
		}
	%>
	
	Welcome ${username} <br>
	
	<img alt="" src="https://d30y9cdsu7xlg0.cloudfront.net/png/1061782-200.png"><br><br>
	
	Upload here <br>
	<form name = "uploadForm" action="Upload" method="POST" enumtype = "multipart/form-data">
		
		<input type = "file" name = "file" value = "" width = 100 >
		<input type = "submit" value = "Submit" name = "submit" >
		${isSubmitted}
	
	</form>
			<br><form action = "Logout">
			<input type = "submit" value = "Logout">
			</form>
</body>
</html>