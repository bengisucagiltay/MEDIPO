package register;

import utils.FileManager;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.Scanner;


/**
 * Servlet implementation class Register
 */
@WebServlet("/Register")
public class Register extends HttpServlet {
    private static final String USER_INFO = FileManager.getResourcesDicrectory() +
            "/server_data" +
            "/user_info.txt";

    private static final String PASSWORDS  = FileManager.getResourcesDicrectory() +
            "/server_data" +
            "/passwords.txt";

    private File EMAILS = new File(FileManager.getResourcesDicrectory() +
            "/server_data" +
            "/emails.txt");
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException,
            IOException {
        String fname = request.getParameter("firstname");
        String lname = request.getParameter("lastname");
        String mail = request.getParameter("email");
        String pword = request.getParameter("password");

        PrintWriter out = response.getWriter();

        //HttpSession session = request.getSession();
        //session.setAttribute("fname", fname);   //TODO: use this session attribute for WELCOME $fname message

        if(checkUserExists(mail) == true){
            System.out.println("A user with this e-mail already exists!");
            out.println("<script src='https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/6.11.4/sweetalert2.all.js'></script>");
            out.println("<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>");
            out.println("<script>");
            out.println("$(document).ready(function(){");
            out.println("swal ( 'Oops' ,  'A user with this e-mail already exists! Please try again..' ,  'error' )");
            out.println("});");
            out.println("</script>");
            //response.sendRedirect("register.jsp");
            RequestDispatcher rd = request.getRequestDispatcher("register.jsp");
            rd.include(request,response);
        }
        else if(mail.equals("") || pword.equals("") || fname.equals("") || lname.equals("")){
            System.out.println("Entry cannot be empty");
            out.println("<script src='https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/6.11.4/sweetalert2.all.js'></script>");
            out.println("<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>");
            out.println("<script>");
            out.println("$(document).ready(function(){");
            out.println("swal ( 'Oops' ,  'Entry cannot be empty! Please try again..' ,  'error' )");
            out.println("});");
            out.println("</script>");
            //response.sendRedirect("register.jsp");
            RequestDispatcher rd = request.getRequestDispatcher("register.jsp");
            rd.include(request, response);
        }
        else if(pword.length()< 1){
            System.out.println("Password should be at least 8 characters");
            out.println("<script src='https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/6.11.4/sweetalert2.all.js'></script>");
            out.println("<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>");
            out.println("<script>");
            out.println("$(document).ready(function(){");
            out.println("swal ( 'Oops' ,  'Password should have at least 8 characters! Please try again..' ,  'error'" +" )");
            out.println("});");
            out.println("</script>");
            //response.sendRedirect("register.jsp");
            RequestDispatcher rd = request.getRequestDispatcher("register.jsp");
            rd.include(request, response);
        }
        else{
            writeUserInfo(fname, lname, mail, pword);
            createUserHomeFile(mail);
            //TODO: CHECK IF EMAIL IS WRITTEN IN NAME@EMAIL.COM
            out.println("<script src='https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/6.11.4/sweetalert2.all.js'></script>");
            out.println("<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>");
            out.println("<script>");
            out.println("$(document).ready(function(){");
            out.println("swal ( 'Success' ,  'Register Complete! Please log in..' ,  'success' )");
            out.println("});");
            out.println("</script>");
            //response.sendRedirect("login.jsp");
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.include(request,response);
        }
	}


    private void createUserHomeFile(String mail) {
        String filePath = FileManager.getResourcesDicrectory() + "/users/" + mail.replace('@', '-');
        File f = new File(filePath);
        f.mkdirs();
        return;
    }

	/*
	* private method checkIfExists
	* scans the email file and checks if an email already is registered
	* returns true if already registered
	* */
	private boolean checkUserExists(String mail){
        try {
            Scanner scanner = new Scanner(EMAILS);
            while (scanner.hasNextLine()) {
                if(mail.equals(scanner.nextLine()))
                    return true;
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }

    /*
     * private method writeUserInfo
     * writes the user info to corresponded files
     * */
    private void writeUserInfo(String fname, String lname, String mail, String pword){
        BufferedWriter wr1 = null;
        BufferedWriter wr2 = null;
        BufferedWriter wr3 = null;

        try{
            wr1 = new BufferedWriter(new FileWriter(USER_INFO,true));
            wr1.write(fname + "," + lname +"\n");
            wr2 = new BufferedWriter(new FileWriter(EMAILS,true));
            wr2.write(mail +"\n");
            wr3 = new BufferedWriter(new FileWriter(PASSWORDS,true));
            wr3.write(pword +"\n");

        }catch (IOException e){
            e.printStackTrace();
        }
        finally {
            try {
                if(wr1 != null)
                    wr1.close();
                if(wr2 != null)
                    wr2.close();
                if(wr3 != null)
                    wr3.close();
            }catch (IOException e){
                e.printStackTrace();
            }
        }
        System.out.println("Registration complete");
    }
}