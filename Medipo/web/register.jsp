<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
		 pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="java">

<head>
	<link href="css/register.css" type="text/css" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css?family=Cinzel+Decorative|Open+Sans:400,600i"
		  rel="stylesheet">
	<title>..::Registering to Medipo::..</title>

	<meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<body>
<h1 class="header">Medipo</h1>

<div class="topnav">
	<a href="welcome.jsp">Home</a>
	<a href="guestupload.jsp">Upload</a>
	<a href="login.jsp">Login</a>
	<a href="about.jsp">About</a>
	<a href="contact.jsp">Contact</a>
</div>

<div class="container">
	<form action="Register">
		<div class="row">
			<div class="col-25">
				<label for="fname"><h2>First Name</h2></label>
			</div>
			<div class="col-75">
				<input type="text" id="fname" name="firstname" placeholder="Your name...">
			</div>
		</div>
		<div class="row">
			<div class="col-25">
				<label for="lname"><h2>Last Name</h2></label>
			</div>
			<div class="col-75">
				<input type="text" id="lname" name="lastname" placeholder="Your surname...">
			</div>
		</div>
		<div class="row">
			<div class="col-25">
				<label for="mail"><h2>E- Mail</h2></label>
			</div>
			<div class="col-75">
				<input type="text" id="mail" name="email" placeholder="Your e-mail...">
			</div>
		</div>
		<div class="row">
			<div class="col-25">
				<label for="pword"><h2>Your password</h2></label>
			</div>
			<div class="col-75">
				<input type="password" id="pword" name="password" placeholder="Your password...">
			</div>
		</div>
		<div class="row">
			<input type="submit" value="Submit">
		</div>
	</form>
</div>
<img src="images/pulse1.png" width="100%" alt="backg" >
</body>
</html>
