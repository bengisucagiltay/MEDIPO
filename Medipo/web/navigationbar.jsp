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


    <a href="welcome.jsp">Home</a>
    <a href="
			<%
				if(session.getAttribute("fname") == null || session.getAttribute("fname") == "Guest"){
				    session.setAttribute("fname", "Guest");
                    out.println("uploadGuest.jsp");
                }
                 else
                    out.println("upload.jsp");
            %>
    ">

    Upload
    </a>
    <a href="slider.jsp">Image History</a>
    <a href="about.jsp">About Us</a>
    <a href="contact.jsp">Contact</a>

    <b>Welcome,
        <%
        if(session.getAttribute("fname") == null){	//user not registered (guest)
            session.setAttribute("fname", "Guest");
            out.println(session.getAttribute("fname"));
        }
        else
        out.println(session.getAttribute("fname")); //to do: logout based on guest or registered
        %>
    </b>

    <%
        if(session.getAttribute("fname") != null && session.getAttribute("fname") != "Guest"){%>
            <a style="float: right" href="/Logout" ><u>Logout</u></a>
    <%}else if(session.getAttribute("fname") == null || session.getAttribute("fname") == "Guest"){%>
            <a style="float: right" href="login.jsp" ><u>Login</u></a>

    <%}%>

</div>
