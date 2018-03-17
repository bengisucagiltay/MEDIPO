<%@ page language="java" contentType="text/html; charset=utf-8"
		 pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="java">

<head>
	<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
	<link href="css/login.css" type="text/css" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css?family=Cinzel+Decorative|Open+Sans:400,600i"
		  rel="stylesheet">
	<title>..::Login to Medipo::..</title>

	<meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<body>
<h1 class="header">Medipo</h1>

<div id="navbar1">
</div>
<script>
    $(function () {
        $("#navbar1").load("navigationbar.jsp");
    });
</script>

<div class="container">
	<form action="Login">
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
				<label for="pword"><h2>Password</h2></label>
			</div>
			<div class="col-75">
				<input type="password" id="pword" name="password" placeholder="Your password...">
			</div>
		</div>
		<div class="row">
			<input type="submit" value="Login">
			<input type="button" onclick="location='register.jsp'" value="Register">
		</div>
	</form>
</div>
<img src="images/pulse1.png" width="100%" alt="backg" >
</body>
</html>
