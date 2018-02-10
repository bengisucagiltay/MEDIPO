package login;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Scanner;

/**
 * Servlet implementation class Login
 */
@WebServlet("/Login")
public class Login extends HttpServlet {
    private static final String USER_INFO = "C:\\Users\\Bengisu\\IdeaProjects\\CS491-Medipo\\Medipo\\resource" +
            "\\server_data" +
            "\\user_info.txt";

    private File PASSWORDS = new File( "C:\\Users\\Bengisu\\IdeaProjects\\CS491-Medipo\\Medipo\\resource" +
            "\\server_data" +
            "\\passwords.txt");

    private File EMAILS = new File("C:\\Users\\Bengisu\\IdeaProjects\\CS491-Medipo\\Medipo\\resource" +
            "\\server_data" +
            "\\emails.txt");

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException,
            IOException {
        //String fname = request.getParameter("firstname"); //null
        String mail = request.getParameter("email");
        String pword = request.getParameter("password");

        PrintWriter out = response.getWriter();

        if(checkUserExists(mail) == -1){
            System.out.println("This user does not exist");
            out.println("<script src='https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/6.11.4/sweetalert2.all.js'></script>");
            out.println("<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>");
            out.println("<script>");
            out.println("$(document).ready(function(){");
            out.println("swal ( 'Oops' ,  'This user does not exist! Please try again..' ,  'error' )");
            out.println("});");
            out.println("</script>");
            //response.sendRedirect("login.jsp");
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.include(request,response);
        }
        else{   //user exists check password match
            int loc = checkUserExists(mail);

            if(checkPasswordMatch(pword, loc)){
                System.out.println("Login Succesful");

                //TODO: PRINT WELCOME username INFO IN WELCOME PAGE
                HttpSession session = request.getSession();
                session.setAttribute("mail", mail);
                response.sendRedirect("welcome.jsp");
                //response.sendRedirect("welcome.jsp?mail="+mail);
            }
            else{
                System.out.println("Login Unsuccesful");
                out.println("<script src='https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/6.11.4/sweetalert2.all.js'></script>");
                out.println("<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>");
                out.println("<script>");
                out.println("$(document).ready(function(){");
                out.println("swal ( 'Oops' ,  'Your password is incorrect! Please try again..' ,  'error' )");
                out.println("});");
                out.println("</script>");
                //response.sendRedirect("login.jsp");
                RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
                rd.include(request,response);
            }
        }
	}

	public int checkUserExists(String mail){   //TODO: return the line if the user exists
        int uid = 0;
            try {
                Scanner scanner = new Scanner(EMAILS);
                while (scanner.hasNextLine()) {
                    uid++;
                    if(mail.equals(scanner.nextLine())){
                        System.out.println("A user with this e-mail exists in line " + uid);
                        return uid;
                    }
                }
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }
            return -1;
        }

    public boolean checkPasswordMatch(String pword, int uid){ //TODO: check if password matches
        int i;
        Scanner scanner;
        try {
            scanner = new Scanner(PASSWORDS);
            for(i=1;i!=uid;i++) //go to the line
                scanner.nextLine();
            if(i == uid){
                if(pword.equals(scanner.nextLine()))
                    return true;
                else
                    return false;
        }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return false;

    }
}

