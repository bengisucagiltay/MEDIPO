package transfer;

import utils.FileManager;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

public class Download extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String zipPath = FileManager.getDirPath_User((String) request.getAttribute("email")) + "/" + request.getAttribute("firstname") + ".zip";

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