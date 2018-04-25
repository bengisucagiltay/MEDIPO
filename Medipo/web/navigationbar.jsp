<%@ page import="utils.FileManager" %>
<div class="header" style="background-size: 70% auto;">
    <h2 style="
    position: center;
    font-family: 'Cinzel Decorative', cursive;
    font-size: 80px;
    text-align: left;
    padding: 0 20px 0 20px;">
        Medipo
    </h2>
    <h1>Medical Image Processing Online<br></h1>
</div>

<div class="topnav">


    <a href="upload.jsp">Upload</a>
    <a href="wandTest.jsp">Image History</a>
    <a href="wandTest.jsp">Magic Wand</a>
    <a href="superpixelTest.jsp">Slic</a>




    <%
        if(session.getAttribute("firstname") != null && session.getAttribute("firstname") != "Guest"){%>
            <a style="float: right" href="Logout" ><u>Logout</u></a>
    <%}else if(session.getAttribute("firstname") == null || session.getAttribute("firstname") == "Guest"){%>
            <a style="float: right" href="login.jsp" ><u>Login</u></a>

    <%}%>
    <a href="contact.jsp"style="float: right">Contact</a>
    <a href="about.jsp"style="float: right">About MEDIPO</a>

    <b>Welcome,
        <%
            if(session.getAttribute("firstname") == null ){//user not registered (guest)
                session.setAttribute("firstname", "Guest");
                out.println(session.getAttribute("firstname"));
            }
            else
                out.println(session.getAttribute("firstname"));

            if(session.getAttribute("email") == null) {
                String sessionID = session.getId();
                session.setAttribute("email", "guest@" + sessionID);
                FileManager.getDirPath_User("guest@" + sessionID);
            }
        %>

    </b>
</div>
