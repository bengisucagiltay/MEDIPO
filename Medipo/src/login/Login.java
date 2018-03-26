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

    private File USERS = new File(FileManager.getFilePath_Names());
    private File PASSWORDS = new File(FileManager.getFilePath_Passwords());
    private File EMAILS = new File(FileManager.getFilePath_Emails());

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException,
            IOException {
        String firstname = request.getParameter("firstname"); //null
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        PrintWriter out = response.getWriter();

        if (checkUserExists(email) == -1) {
            System.out.println("This user does not exist");
            alerts(out, "Oops", "This user does not exist! Please try again..", "error");
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.include(request, response);
        } else if (checkUserExists(email) == -2) {
            System.out.println("Your entry cannot be empty");
            alerts(out, "Oops", "Your entry cannot be empty! Please try again..", "error");
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.include(request, response);
        } else {   //user exists check password match
            int uid = checkUserExists(email);

            if (checkPasswordMatch(password, uid)) {
                System.out.println("Login Succesful");
                HttpSession session = request.getSession();
                String userName = getUserName(uid);
                session.setAttribute("firstname", userName);
                session.setAttribute("email", email);
                //session.setAttribute("dirPath", email.replace('@', '-'));
                response.sendRedirect("welcome.jsp");
            } else {
                System.out.println("Login Unsuccesful");
                alerts(out, "Oops", "Your password is incorrect! Please try again..", "error");
                RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
                rd.include(request, response);
            }
        }
    }

    /*
     * Method that checks if the user exists
     * */
    private int checkUserExists(String email) {
        int uid = 0;
        try {
            System.out.println("Working Directory = " +
                    System.getProperty("user.dir"));
            Scanner scanner = new Scanner(EMAILS, "UTF-8");
            while (scanner.hasNextLine()) {
                uid++;
                if (email.equals(scanner.nextLine())) {
                    System.out.println("A user with this e-mail exists in line " + uid);
                    return uid;
                } else if (email.equals("")) {
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
    private boolean checkPasswordMatch(String password, int uid) {
        int i;
        Scanner scanner;
        try {
            scanner = new Scanner(PASSWORDS, "UTF-8");
            for (i = 1; i != uid; i++) //go to the line
                scanner.nextLine();
            if (i == uid) {
                if (password.equals(scanner.nextLine()))
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
            scanner = new Scanner(USERS, "UTF-8");
            for (i = 1; i != uid; i++) //go to the line
                scanner.nextLine();
            if (i == uid) {
                uname = scanner.nextLine();
                StringTokenizer tok = new StringTokenizer(uname, ",");
                return tok.nextToken();
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return uname;
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

