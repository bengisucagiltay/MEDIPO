<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="java">

<head>
	<link href="css/welcome.css" type="text/css" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css?family=Cinzel+Decorative|Open+Sans:400,600i"
		  rel="stylesheet">
	<title>..::Welcome to Medipo::..</title>

	<meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<body>
<h1 class="header">Medipo</h1>

<div class="topnav">
	<a href="welcome.jsp">Home</a>
	<a href="upload.jsp">Upload</a>
	<a href="login.jsp">Login</a>
	<a href="about.jsp">About</a>
	<a href="contact.jsp">Contact</a>

	<b>Welcome,
	<%
		if(session.getAttribute("fname")== null){	//user not registered (guest)
			out.println(" Guest");
		}
		else
		    out.println(session.getAttribute("fname")); //to do: logout based on guest or registered
	%>
	</b>

	<a style="float: right" href="/Logout" ><u>Logout</u></a>
</div>

<div class="row">
	<div class="centerclmn">
		<a class= "gubutton" onclick="document.getElementById('id01').style.display='block'" style="width:auto" class="gubutton">Get Started</a>
		<div id="id01" class="modal">

			<form class="modal-content animate" action="login.jsp">
                <span onclick="document.getElementById('id01').style.display='none'"
                      class="close" title="Close Modal" >&times</span>
				<div class="container">
					<button type="submit">Login</button>
					<button type="submit" formaction="register.jsp">Register</button><br>
					<button type="submit" formaction="uploadGuest.jsp">Continue as a Guest</button>
				</div>
			</form>
		</div>

	</div>
	<div class="rightclmn">
		<h2 align="center">Server ver.1</h2>
		<h4 class="updatec">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce sit amet ex ante. In at rhoncus ex. Nunc eu magna at turpis dapibus molestie. Sed ut mattis augue.</h4>

		<h2 align="center">Update 1.2</h2>
		<h4 class="updatec">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce sit amet ex ante. In at rhoncus ex. Nunc eu magna at turpis dapibus molestie. Sed ut mattis augue.</h4>

		<h2 align="center" >Maintenance on 21.12.22</h2>
		<h4 class="updatec">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce sit amet ex ante. In at rhoncus ex. Nunc eu magna at turpis dapibus molestie. Sed ut mattis augue.</h4>

	</div>
<img src="images/pulse1.png" width="80%" alt="backg" >
</div>
</body>
</html>


<!-- Commented old version of jsp
<html>
<head>
<link href="welcomehtml.html" type="text/html" rel="html">

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>..::Welcome to Medipo::..</title>

</head>
<body>

	<h1> Welcome to Medipo</h1><br>
	<img alt="" src="https://d30y9cdsu7xlg0.cloudfront.net/png/137469-200.png"><br><br>

	<form action = "Login.jsp">
		<input type="submit" value = "Login"></form>

	<form action="Register.jsp">
		<input type="submit" value = "Sign up"></form>

	<form action="UploadGuest.jsp">
		<input type="submit" value = "Guest"></form>
</body>
</html>

-->
