package upload;

import org.apache.commons.io.FileUtils;
import utils.FileManager;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

/**
 * Servlet implementation class Upload
 */
@WebServlet("/Upload")
public class Upload extends HttpServlet {

    private static final String USERS  = FileManager.getResourcesDirectory() +
            "/users/";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        boolean isMultipart = ServletFileUpload.isMultipartContent(request);
        String userFolder = USERS + ((String) request.getSession().getAttribute("dirPath"));

        FileUtils.cleanDirectory(new File(userFolder));


        if (!isMultipart) {
        } else {
            FileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            List items = null;
            try {
                items = upload.parseRequest(request);
            } catch (FileUploadException e) {
                e.printStackTrace();
            }
            Iterator itr = items.iterator();
            int count = 1;
            while (itr.hasNext()) {
                FileItem item = (FileItem) itr.next();
                if (item.isFormField()) {
                } else {
                    try {
                        String itemName = item.getName();
                        File savedFile = new File(userFolder + System.getProperty("file.separator") + count + itemName.substring(itemName.length() - 4));
                        item.write(savedFile);
                        count++;
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }

        //FileManager.zipDirectory((String) request.getAttribute("dirPath"), (String) request.getAttribute("fname"));

        response.sendRedirect("slider.jsp");

    }
}
