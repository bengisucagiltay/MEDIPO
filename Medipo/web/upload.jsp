<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
		 pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="java">

<head>
	<link href="css/login.css" type="text/css" rel="stylesheet">
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
	<a href="about.jsp">About</a>
	<a href="contact.jsp">Contact</a>
	<b>Welcome, Guest</b>
</div>

<div class="row">
	<div class="centerclmn">

		<h2>Upload here</h2><br><br>
		<form action="Upload" method="post" enctype="multipart/form-data" name="form1" id="form1">
			<center>
				<table border="1">
					<tr>
						<td align="center"><b>Multipale file Uploade</td>
					</tr>
					<tr>
						<td>
							Specify file: <input name="file" type="file" id="file" multiple>
						</td>
					</tr>
					<tr>
						<td align="center">
							<input type="submit" name="Submit" value="Submit files"/>
						</td>
					</tr>
				</table>
				<center>
		</form>
		<br><form action = "Logout">
		<input type = "submit" value = "Logout">
	</form>

	</div>
	<div class="rightclmn">
		<h2 align="center">Server ver.1</h2>
		<h4 class="updatec">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce sit amet ex ante. In at rhoncus ex. Nunc eu magna at turpis dapibus molestie. Sed ut mattis augue.</h4>

		<h2 align="center">Update 1.2</h2>
		<h4 class="updatec">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce sit amet ex ante. In at rhoncus ex. Nunc eu magna at turpis dapibus molestie. Sed ut mattis augue.</h4>

		<h2 align="center" >Maintenance on 21.12.22</h2><br>
		<h4 class="updatec">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce sit amet ex ante. In at rhoncus ex. Nunc eu magna at turpis dapibus molestie. Sed ut mattis augue.</h4>

	</div>
	<img src="images/pulse1.png" width="80%" alt="backg" >
</div>
</body>
</html>


