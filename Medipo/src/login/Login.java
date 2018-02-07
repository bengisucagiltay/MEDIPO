package login;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
/**
 * Servlet implementation class Login
 */
@WebServlet("/Login")
public class Login extends HttpServlet {
	
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fname = request.getParameter("firstname");
        String mail = request.getParameter("email");
        String pword = request.getParameter("password");

        if(mail.equals("admin") && pword.equals("admin")) {	//TODO: check from saved file later

            HttpSession session = request.getSession();
            session.setAttribute("mail", mail);
            response.sendRedirect("upload.jsp");
        }
        else {
            System.out.println("Invalid username and password");
            response.sendRedirect("login.jsp");
        }
	}

	public int checkUserExists(){   //TODO: return the line if the user exists

	    return -1;
    }

    public boolean checkPasswordMatch(){ //TODO: check if password matches

    return true;
    }
}

