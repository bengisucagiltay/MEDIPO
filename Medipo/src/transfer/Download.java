package transfer;

import utils.FileManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/Download")
public class Download extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {


        String email = (String) request.getSession().getAttribute("email");
        String firstname = (String) request.getSession().getAttribute("firstname");

        FileManager.zip(email, firstname);
        String zipPath = FileManager.getDirPath_User( email+"/" + firstname + ".zip");
        System.out.println("ZIPPATH IS:"+zipPath);

        OutputStream out= response.getOutputStream();
        response.setContentType("application/zip");
        response.setHeader("Content-Disposition","attachment;filename="+email+".zip");


        FileInputStream in = new FileInputStream(new File(zipPath));
        byte[] buffer = new byte[4096];

        int length;
        while ((length = in.read(buffer)) > 0) {
            System.out.println("MY LENGTH"+length);
            out.write(buffer, 0, length);
        }
        in.close();
        out.flush();


        //response.sendRedirect("welcome.jsp");
    }
}