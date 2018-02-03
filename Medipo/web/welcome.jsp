<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="java">

<head>
	<link href="welcome.css" type="text/css" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css?family=Cinzel+Decorative|Open+Sans:400,600i"
		  rel="stylesheet">
	<title>..::Welcome to Medipo::..</title>

	<meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<body>
<h1 class="header">Medipo</h1>

<div class="topnav">
	<a href="welcome.jsp">Home</a>
	<a href="guestupload.jsp">Upload</a>
	<a href="login.jsp">Login</a>
	<a href="#">About</a>
	<a href="#">Contact</a>
</div>

<div class="row">
	<div class="centerp" style="background-image:url(pulse1.png)">
		<a class= "gubutton" onclick="document.getElementById('id01').style.display='block'" style="width:auto" class="gubutton">Upload</a>
		<div id="id01" class="modal">

			<form class="modal-content animate" action="login.jsp">
				<div class="container">
					<span onclick="document.getElementById('id01').style.display='none'"
						  class="close" title="Close Modal">&times;</span>
					<button type="submit">Login</button>
					<button type="submit" formaction="register.jsp">Register</button><br>
					<button type="submit" formaction="guestupload.jsp">Continue as a Guest</button>
			</form>
		</div>

	</div>
</div>

	<div class="rightp">
		<h2>Server</h2>
		<p class="updatec">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce sit amet ex ante. In at rhoncus ex. Nunc eu magna at turpis dapibus molestie. Sed ut mattis augue.</p>

		<h2>Update 1.2</h2>
		<p class="updatec">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce sit amet ex ante. In at rhoncus ex. Nunc eu magna at turpis dapibus molestie. Sed ut mattis augue.</p>

		<h2 class="updatc" >Maintenance on 21.12.22</h2><br>
		<p class="updatec">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce sit amet ex ante. In at rhoncus ex. Nunc eu magna at turpis dapibus molestie. Sed ut mattis augue.</p>

	</div>
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

	<form action="GuestUpload.jsp">
		<input type="submit" value = "Guest"></form>
</body>
</html>

-->
