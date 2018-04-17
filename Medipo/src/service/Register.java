package service;

import org.apache.commons.validator.routines.EmailValidator;
import utils.AlertManager;
import utils.FileManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.Scanner;

@WebServlet("/Register")
public class Register extends HttpServlet {

    private File USERS = new File(FileManager.getFilePath_Names());
    private File EMAILS = new File(FileManager.getFilePath_Emails());
    private File PASSWORDS = new File(FileManager.getFilePath_Passwords());

    private PrintWriter out;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        out = response.getWriter();

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");

        int userExists = isUserExists(email);
        if (userExists == -1) {
            AlertManager.alert(out, request, response, "Oops", "Error with the emails file!", "error", "register.jsp");
        } else if (userExists == -2) {
            AlertManager.alert(out, request, response, "Oops", "A user with this e-mail already exists! Please try again..", "error", "register.jsp");
        } else if (email.equals("") || password.equals("") || firstname.equals("") || lastname.equals("")) {
            AlertManager.alert(out, request, response, "Oops", "Entry cannot be empty! Please try again..", "error", "register.jsp");
        } else if (password.length() < 8) {
            AlertManager.alert(out, request, response, "Oops", "Password should have at least 8 characters! Please try again..", "error", "register.jsp");
        } else if (validateMail(email) == false) {
            AlertManager.alert(out, request, response, "Oops", "Incorrect mail form (NAME@EMAIL.COM)", "error", "register.jsp");
        } else {
            writeUserInfo(firstname, lastname, email, password);
            AlertManager.alert(out, request, response, "Success", "Register Complete! Please log in..", "success", "login.jsp");
        }
    }

    private int isUserExists(String email) {

        Scanner scanner;
        try {
            scanner = new Scanner(EMAILS, "UTF-8");
        } catch (FileNotFoundException e) {
            return -1;
        }

        while (scanner.hasNextLine()) {
            if (email.equals(scanner.nextLine()))
                return -2;
        }

        return 0;
    }

    private boolean validateMail(String email) {
        EmailValidator emailValidator = EmailValidator.getInstance();

        if (emailValidator.isValid(email))
            return true;
        else
            return false;
    }


    private void writeUserInfo(String firstname, String lastname, String email, String password) {
        Writer wr1 = null;
        Writer wr2 = null;
        Writer wr3 = null;

        try {
            wr1 = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(USERS, true), "UTF8"));
            wr1.write(firstname + "," + lastname + "\n");
            wr2 = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(EMAILS, true), "UTF8"));
            wr2.write(email + "\n");
            wr3 = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(PASSWORDS, true), "UTF8"));
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
    }
}