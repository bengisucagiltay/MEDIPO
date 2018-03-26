package register;

import org.apache.commons.validator.routines.EmailValidator;
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
    private String USER_INFO = FileManager.getFilePath_Names();

    private String PASSWORDS = FileManager.getFilePath_Passwords();

    private File EMAILS = new File(FileManager.getFilePath_Emails());

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException,
            IOException {
        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        PrintWriter out = response.getWriter();

        if (checkUserExists(email) == true) {
            System.out.println("A user with this e-mail already exists!");
            alerts(out, "Oops", "A user with this e-mail already exists! Please try again..", "error");
            //response.sendRedirect("register.jsp");
            RequestDispatcher rd = request.getRequestDispatcher("register.jsp");
            rd.include(request, response);
        } else if (email.equals("") || password.equals("") || firstname.equals("") || lastname.equals("")) {
            System.out.println("Entry cannot be empty");
            alerts(out, "Oops", "Entry cannot be empty! Please try again..", "error");
            //response.sendRedirect("register.jsp");
            RequestDispatcher rd = request.getRequestDispatcher("register.jsp");
            rd.include(request, response);
        } else if (password.length() < 1) {
            System.out.println("Password should be at least 8 characters");
            alerts(out, "Oops", "Password should have at least 8 characters! Please try again..", "error");
            RequestDispatcher rd = request.getRequestDispatcher("register.jsp");
            rd.include(request, response);
        }
        //TODO: CHECK IF EMAIL IS WRITTEN IN NAME@EMAIL.COM
        else if (validateMail(email) == false) {
            System.out.println("Incorrect mail form (NAME@EMAIL.COM)");
            alerts(out, "Oops", "Incorrect mail form (NAME@EMAIL.COM)", "error");
            RequestDispatcher rd = request.getRequestDispatcher("register.jsp");
            rd.include(request, response);

        } else {
            writeUserInfo(firstname, lastname, email, password);
            FileManager.getDirPath_User(email);
            alerts(out, "Success", "Register Complete! Please log in..", "success");
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.include(request, response);
        }
    }

    private boolean validateMail(String email) {
        EmailValidator emailValidator = EmailValidator.getInstance();

        if (emailValidator.isValid(email))
            return true;
        else
            return false;
    }

    /*
     * private method checkIfExists
     * scans the email file and checks if an email already is registered
     * returns true if already registered
     * */
    private boolean checkUserExists(String email) {
        try {
            Scanner scanner = new Scanner(EMAILS, "UTF-8");
            while (scanner.hasNextLine()) {
                if (email.equals(scanner.nextLine()))
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
    private void writeUserInfo(String firstname, String lastname, String email, String password) {
        Writer wr1 = null;
        Writer wr2 = null;
        Writer wr3 = null;

        try {
            wr1 = new BufferedWriter(new OutputStreamWriter(
                    new FileOutputStream(USER_INFO, true), "UTF8"));
            wr1.write(firstname + "," + lastname + "\n");
            wr2 = new BufferedWriter(new OutputStreamWriter(
                    new FileOutputStream(EMAILS, true), "UTF8"));
            wr2.write(email + "\n");
            wr3 = new BufferedWriter(new OutputStreamWriter(
                    new FileOutputStream(PASSWORDS, true), "UTF8"));
            wr3.write(password + "\n");

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (wr1 != null)
                    wr1.close();
                if (wr2 != null)
                    wr2.close();
                if (wr3 != null)
                    wr3.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        System.out.println("Registration complete");
    }

    private void alerts(PrintWriter out, String alert, String message, String type) {

        out.println("<script src='https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/6.11.4/sweetalert2.all.js'></script>");
        out.println("<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>");
        out.println("<script>");
        out.println("$(document).ready(function(){");
        out.println("swal ( '" + alert + "' ,  '" + message + "' ,  '" + type + "' )");
        out.println("});");
        out.println("</script>");
        //response.sendRedirect("register.jsp");

    }
}