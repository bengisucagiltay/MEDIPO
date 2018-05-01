<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
		 pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="java">

<head>
	<script src="js/jquery-1.10.2.js"></script>
	<link href="css/login.css" type="text/css" rel="stylesheet">
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
	<div class="container" >

		<form action="Upload" method="post" enctype="multipart/form-data" name="form1" id="form1">
			<br>
			<h1 align="center" ><b>Upload your files</b><br><br>
			<input name="file" type="file" id="file" multiple></h1><br>
			<input type="submit" name="Submit" value="Submit files"/>
		</form>

		<form action="wandTest.jsp" method="post" >
			<input type="submit" name="Submit" value="Image History"/>
		</form>
	</div>
</div>
<img src="images/pulse.png" width="100%" alt="backg" >
</body>
</html>


