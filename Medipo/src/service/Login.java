package service;

import utils.AlertManager;
import utils.FileManager;

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

@WebServlet("/Login")
public class Login extends HttpServlet {

    private File USERS = new File(FileManager.getFilePath_Names());
    private File EMAILS = new File(FileManager.getFilePath_Emails());
    private File PASSWORDS = new File(FileManager.getFilePath_Passwords());

    private String email;
    private String password;
    private PrintWriter out;
    private HttpSession session;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        email = request.getParameter("email");
        password = request.getParameter("password");
        session = request.getSession();
        out = response.getWriter();

        int userStatus = getUserStatus(email);
        if (userStatus == -1) {
            AlertManager.alert(out, request, response, "Oops", "Error with the emails file!", "error", "login.jsp");
        } else if (userStatus == -2) {
            AlertManager.alert(out, request, response, "Oops", "Your entry cannot be empty! Please try again..", "error", "login.jsp");
        } else if (userStatus == -3) {
            AlertManager.alert(out, request, response, "Oops", "This user does not exist! Please try again..", "error", "login.jsp");
        } else {

            int passwordStatus = getPasswordStatus(password, userStatus);
            if (passwordStatus == -1) {
                AlertManager.alert(out, request, response, "Oops", "Error with the passwords file!", "error", "login.jsp");
            } else if (passwordStatus == -2) {
                AlertManager.alert(out, request, response, "Oops", "Your password is incorrect! Please try again..", "error", "login.jsp");
            } else {

                String firstName = getFirstName(userStatus);
                if (firstName == null) {
                    AlertManager.alert(out, request, response, "Oops", "Error with the users file!", "error", "login.jsp");
                } else if (firstName.equals("")) {
                    AlertManager.alert(out, request, response, "Oops", "This user does not exist! Please try again..", "error", "login.jsp");
                } else {
                    session.setAttribute("firstname", firstName);
                    session.setAttribute("email", email);
                    response.sendRedirect("welcome.jsp");
                }
            }
        }
    }

    private int getUserStatus(String email) {

        Scanner scanner;
        try {
            scanner = new Scanner(EMAILS, "UTF-8");
        } catch (FileNotFoundException e) {
            return -1;
        }

        if (email.equals(""))
            return -2;

        int uid = 0;
        while (scanner.hasNextLine()) {
            if (email.equals(scanner.nextLine()))
                return uid;
            uid++;
        }

        return -3;
    }


    private int getPasswordStatus(String password, int uid) {

        Scanner scanner;
        try {
            scanner = new Scanner(PASSWORDS, "UTF-8");
        } catch (FileNotFoundException e) {
            return -1;
        }

        for (int i = 0; i != uid; i++)
            scanner.nextLine();

        if (!password.equals(scanner.nextLine()))
            return -2;
        else
            return 0;
    }

    private String getFirstName(int userID) {

        Scanner scanner;
        try {
            scanner = new Scanner(USERS, "UTF-8");
        } catch (FileNotFoundException e) {
            return null;
        }

        for (int i = 0; i != userID; i++)
            scanner.nextLine();

        String userName = scanner.nextLine();
        StringTokenizer st = new StringTokenizer(userName, ",");
        return st.nextToken();
    }
}
