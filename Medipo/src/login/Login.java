package login;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Path;
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

        if(checkUserExists(mail) == -1){
            System.out.println("This user does not exist");
            response.sendRedirect("login.jsp");
        }
        else{   //user exists check password match
            int loc = checkUserExists(mail);

            if(checkPasswordMatch(pword, loc)){
                System.out.println("Login Succesful");

                HttpSession session = request.getSession();
                session.setAttribute("mail", mail);
                //TODO: PRINT WELCOME username INFO IN WELCOME PAGE
                response.sendRedirect("welcome.jsp");
            }
            else{
                System.out.println("Login Unsuccesful");
                response.sendRedirect("login.jsp");
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
                if(pword.equals(scanner.nextLine())) {
                    System.out.println("Match");
                    return true;
                }
                else{
                    System.out.println("No Match");
                    return false;
                }
        }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return false;

    }
}

