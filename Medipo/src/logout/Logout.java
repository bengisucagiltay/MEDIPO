package logout;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet implementation class Logout
 */
@WebServlet("/Logout")
public class Logout extends HttpServlet {

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		HttpSession session = request.getSession();

		System.out.print("user is:"+session.getId());

		session.removeAttribute("fname");
		session.removeAttribute("mail");


		response.setHeader("Cache-Control","no-store");
		response.setHeader("Pragma","no-cache");

		response.setDateHeader("Expires",0);
		session.invalidate();
		System.out.print("user is:"+session.getId());

		/*
		System.out.print("user is:"+session.getId());

		response.setHeader("Cache-Control","no-store");
		response.setHeader("Pragma","no-cache");

		response.setDateHeader("Expires",0);
		request.getSession().invalidate();
		System.out.print("user is:"+session.getId());
		response.sendRedirect("Home.jsp");
		*/
		out.println("<script src='https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/6.11.4/sweetalert2.all.js'></script>");
		out.println("<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>");
		out.println("<script>");
		out.println("$(document).ready(function(){");
		out.println("swal ( 'Success' ,  'Logout Successful!' ,  'success' )");
		out.println("});");
		out.println("</script>");
		//response.sendRedirect("welcome.jsp");
		RequestDispatcher rd = request.getRequestDispatcher("welcome.jsp");
		rd.include(request,response);

	}

}
