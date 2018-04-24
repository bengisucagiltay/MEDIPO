<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="transfer.Contact" %>
<%@ page import="javax.mail.MessagingException" %>

<%
    String message = null;
    String status = null;
    if (request.getParameter("submit") != null) {
        Contact javaEmail = new Contact();
        javaEmail.setMailServerProperties();
        String emailSubject = "Contact Form using Java JSP GMail";
        String emailBody = "";
        if (request.getParameter("name") != null) {
            emailBody = "Sender Name: " + request.getParameter("name")
                    + "<br>";
        }
        if (request.getParameter("email") != null) {
            emailBody = emailBody + "Sender Email: "
                    + request.getParameter("email") + "<br>";
        }
        /*if (request.getParameter("subject") != null) {
            emailSubject = emailSubject + "Subject: "
                    + request.getParameter("subject") + "<br>";
        }*/
        if (request.getParameter("message") != null) {
            emailBody = emailBody + "Message: " + request.getParameter("message")
                    + "<br>";
        }
        try {
            javaEmail.createEmailMessage(emailSubject, emailBody);
        } catch (MessagingException e) {
            e.printStackTrace();
        }

        try {
            javaEmail.sendEmail();
            status = "success";
            message = "Email sent Successfully!";
        } catch (MessagingException me) {
            status = "error";
            message = "Error in Sending Email!";
        }
    }
%>
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

<div class="container" style="top:40%">
    <h2 style="font-family: 'Open Sans', sans-serif;
    text-align: center;
    font-size: 30px;
    font-weight: 600;">Contact Us</h2>
    <h4></h4>
    <h4></h4>
    <h4 style=" text-align:center;font-family: 'Open Sans', sans-serif;
    font-weight: 400;
    font-size: 14px;">Please use the form below to contact the <br>  Medipo Team</h4>
</div>

<div class="container" style="top:60%">
    <form id="frmContact" name="frmContact" action="" method="POST"
          novalidate="novalidate">
        <div class="row">
            <div class="col-25">
                <label for="name"><h2 style="font-family: 'Open Sans', sans-serif;
    text-align: center;
    font-size: 14px;
    font-weight: 600;">Your Full Name:</h2></label>
            </div>
            <div class="col-75">
                <input type="text" id="name" name="name" placeholder="Your name...">
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
                <input type="text" id="email" name="email" placeholder="Your mail address...">
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
                <input type="text" id="subject" name="subject" placeholder="Subject...">
            </div>
        </div>
        <div class="row">
            <div class="col-25">
                <label for="message"><h2 style="font-family: 'Open Sans', sans-serif;
                    text-align: center;
                    font-size: 14px;
                    font-weight: 600;">Your Message:</h2></label>
            </div>
            <div class="col-75">
                <input type="textarea" id="message" name="message" placeholder="Write your message here..." style=" padding: 12px;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
    resize: vertical;height:200px; width:100%">
            </div>
        </div>
        <div class="row">
            <input type="submit" name="submit" value="Send Message"
                   id="send-message" style="clear: both;">
            <%
                if (null != message) {
                    out.println("<div class='" + status + "'>"
                            + message + "</div>");
                }
            %>
        </div>
    </form>
</div>

<img src="images/pulse.png" alt="backg" width="100%">
</body>
</html>

