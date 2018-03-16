<div class="topnav">
    <a href="welcome.jsp">Home</a>
    <a href="
			<%
				if(session.getAttribute("fname")== null)
    out.println("uploadGuest.jsp");
    else
    out.println("upload.jsp");
    %>
    ">

    Upload
    </a>
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
