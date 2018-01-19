package login;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class Login
 */
@WebServlet("/Login")
public class Login extends HttpServlet {
	
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String uname = request.getParameter("uname");
		String pass = request.getParameter("pass");
		
		if(uname.equals("admin") && pass.equals("admin")) {	//check from database later
		
			HttpSession session = request.getSession();
			session.setAttribute("username", uname);
			response.sendRedirect("Upload.jsp");
		}
		
		else {
			System.out.println("Invalid username and password");
			response.sendRedirect("Login.jsp");
		}
		
	}



}
