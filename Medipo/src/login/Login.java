package login;

import utils.FileManager;

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
import java.util.StringTokenizer;

/**
 * Servlet implementation class Login
 */
@WebServlet("/Login")
public class Login extends HttpServlet {

    private File USER_INFO = new File( FileManager.getResourcesDicrectory() +
            "/server_data" +
            "/user_info.txt");
    private File PASSWORDS = new File( FileManager.getResourcesDicrectory() +
            "/server_data" +
            "/passwords.txt");
    private File EMAILS = new File(FileManager.getResourcesDicrectory() +
            "/server_data" +
            "/emails.txt");

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException,
            IOException {
        String fname = request.getParameter("firstname"); //null
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
        else if (checkUserExists(mail) == -2){
            System.out.println("Your entry cannot be empty");
            out.println("<script src='https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/6.11.4/sweetalert2.all.js'></script>");
            out.println("<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>");
            out.println("<script>");
            out.println("$(document).ready(function(){");
            out.println("swal ( 'Oops' ,  'Your entry cannot be empty! Please try again..' ,  'error' )");
            out.println("});");
            out.println("</script>");
            //response.sendRedirect("login.jsp");
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.include(request,response);
        }
        else{   //user exists check password match
            int uid = checkUserExists(mail);

            if(checkPasswordMatch(pword, uid)){
                System.out.println("Login Succesful");
                HttpSession session = request.getSession();
                String uname = getUserName(uid);
                session.setAttribute("fname", uname);
                session.setAttribute("mail", mail);
                response.sendRedirect("welcome.jsp");
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

    /*
    * Method that checks if the user exists
    * */
	private int checkUserExists(String mail){
        int uid = 0;



            try {
                System.out.println("Working Directory = " +
                        System.getProperty("user.dir"));
                Scanner scanner = new Scanner(EMAILS);
                while (scanner.hasNextLine()) {
                    uid++;
                    if(mail.equals(scanner.nextLine())){
                        System.out.println("A user with this e-mail exists in line " + uid);
                        return uid;
                    }
                    else if(mail.equals("")) {
                        System.out.println("Mail cannot be empty");
                        return -2;
                    }
                }
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }
            return -1;
        }
    /*
     * Method that checks if the password matches
     * */
    private boolean checkPasswordMatch(String pword, int uid){
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

    /*
     * Method that gets the user name
     * */
    private String getUserName(int uid) {
        int i;
        Scanner scanner;
        String uname = "";
        try {
            scanner = new Scanner(USER_INFO);
            for(i=1;i!=uid;i++) //go to the line
                scanner.nextLine();
            if(i == uid){
                uname = scanner.nextLine();
                StringTokenizer tok = new StringTokenizer(uname, ",");
                return tok.nextToken();
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return uname;
    }
}

