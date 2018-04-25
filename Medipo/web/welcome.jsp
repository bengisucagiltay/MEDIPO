<%@ page import="utils.FileManager" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
		 pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="java">

<head>
	<script src="js/jquery-1.10.2.js"></script>
	<link href="css/welcome.css" type="text/css" rel="stylesheet">
	<link href="css/cinzeldecorative.css" rel="stylesheet">

	<title>..::Welcome to Medipo::..</title>

	<meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<body>

<div id="navbar1">
</div>
	<script>
		$(function () {
			$("#navbar1").load("navigationbar.jsp");
		});
	</script>

<div class="row">
	<div class="centerclmn">

		<%
			if(session.getAttribute("firstname") == null || session.getAttribute("firstname") == "Guest"){
				session.setAttribute("firstname", "Guest");
				/*if( session.getAttribute("email") == null) {
					session.setAttribute("email", "guest@" + session.getId());
					FileManager.getDirPath_User("guest@" + session.getId());
				}*/
		%>
				<a class= "gubutton" onclick="document.getElementById('Guest').style.display='block'" style="width:auto" class="gubutton">
					<%out.println("Get Started");%>
				</a>
		<%} else {%>
				<a class= "gubutton" onclick="document.getElementById('User').style.display='block'" style="width:auto" class="gubutton">
					<%out.println("View Images");%>
				</a>
		<%}%>


		<div id="Guest" class="modal">
			<form class="modal-content animate">
                <span onclick="document.getElementById('Guest').style.display='none'"
                      class="close" title="Close Modal" >&times</span>
				<div class="container">
					<button type="submit" formaction="login.jsp" >Login</button>
					<button type="submit" formaction="register.jsp">Register</button><br>
					<button type="submit" formaction="upload.jsp">Continue as a Guest</button>
				</div>
			</form>
		</div>

		<div id="User" class="modal">
			<form class="modal-content animate">
                <span onclick="document.getElementById('User').style.display='none'"
					  class="close" title="Close Modal" >&times</span>
				<div class="container">
					<button type="submit" formaction="upload.jsp">Upload Images</button>
					<button type="submit" formaction="slider.jsp">View Image History</button>
				</div>
			</form>
		</div>

	</div>
	<div class="rightclmn">
		<h4 class="updatec"> </h4>
		<h3 align="center">Latest News</h3>
		<h4 class="updatec">These are the latest news</h4>

		<h3 align="center">CS Fair Update</h3>
		<h4 class="updatec">The Medipo Group will be presenting in Bilkent CS Fair on May 14</h4>

		<h3 align="center" >The Project MedIPO</h3>
		<h4 class="updatec">Medical Image Processing Online (MedIPO) is a web based system which allows its users to upload
			and analyze MR images quickly and easily, online. The target audience of this system are medical doctors.
			The system aims to provide an online analysis and decision support tool for medical doctors by providing detailed,
			intractable images and statistical data analysis.</h4>

	</div>

<img src="images/pulse.png" width="80%" alt="backg" >

</div>
</body>
</html>
