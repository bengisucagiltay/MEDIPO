<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="java">

<head>
    <script src="https://code.jquery.com/jquery-1.10.2.js"></script>
    <link href="css/login.css" type="text/css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Cinzel+Decorative|Open+Sans:400,600i"
          rel="stylesheet">
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

<div class="container" style="top:40%">
    <h2 style="font-family: 'Open Sans', sans-serif;
    text-align: center;
    font-size: 30px;
    font-weight: 600;">Contact Us</h2>
    <h4> </h4>
    <h4> </h4>
    <h4 style=" text-align:center;font-family: 'Open Sans', sans-serif;
    font-weight: 400;
    font-size: 14px;">Please use the Contact Form below</h4>
</div>

<div class="container" style="top:60%">
    <form action="Login">
        <div class="row">
            <div class="col-25">
                <label for="cname"><h2 style="font-family: 'Open Sans', sans-serif;
    text-align: center;
    font-size: 14px;
    font-weight: 600;">Your Full Name:</h2></label>
            </div>
            <div class="col-75">
                <input type="text" id="cname" name="conname" placeholder="Your name...">
            </div>
        </div>
        <div class="row">
            <div class="col-25">
                <label for="email"><h2 style="font-family: 'Open Sans', sans-serif;
                    text-align: center;
                    font-size: 14px;
                    font-weight: 600;">Your E-Mail:</h2></label>
            </div>
            <div class="col-75">
                <input type="text" id="email" name="conmail" placeholder="Your mail address...">
            </div>
        </div>
        <div class="row">
            <div class="col-25">
                <label for="subject"><h2 style="font-family: 'Open Sans', sans-serif;
                    text-align: center;
                    font-size: 14px;
                    font-weight: 600;">Subject:</h2></label>
            </div>
            <div class="col-75">
                <input type="text" id="subject" name="sbjct" placeholder="Subject...">
            </div>
        </div>
        <div class="row">
            <div class="col-25">
                <label for="msg"><h2 style="font-family: 'Open Sans', sans-serif;
                    text-align: center;
                    font-size: 14px;
                    font-weight: 600;">Your Message:</h2></label>
            </div>
            <div class="col-75">
                <input type="textarea" id="msg" name="mssg" placeholder="Write your message here..." style=" padding: 12px;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
    resize: vertical;height:200px; width:100%">
            </div>
        </div>
        <div class="row">
            <input type="submit" value="Submit">
        </div>
    </form>
</div>

    <img src="images/pulse.png" alt="backg" width="100%">
</body>
</html>

