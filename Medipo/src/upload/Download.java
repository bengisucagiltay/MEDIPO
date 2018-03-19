package upload;

import utils.FileManager;

import java.io.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class Download extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String zipPath = FileManager.getResourcesDirectoryPath() + "/" + request.getAttribute("dirPath") + "/" + request.getAttribute("firstname") + ".zip";

        OutputStream out = response.getOutputStream();
        FileInputStream in = new FileInputStream(new File(zipPath));
        byte[] buffer = new byte[4096];
        int length;
        while ((length = in.read(buffer)) > 0) {
            out.write(buffer, 0, length);
        }
        in.close();
        out.flush();
    }
}  