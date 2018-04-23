package transfer;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileUtils;
import utils.FileManager;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;


@WebServlet("/Upload")
public class Upload extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        boolean isMultipart = ServletFileUpload.isMultipartContent(request);
        String email = (String) request.getSession().getAttribute("email");
        String userDirectoryPath = FileManager.getDirPath_UserUpload(email);

        FileUtils.cleanDirectory(new File(userDirectoryPath));

        if (isMultipart) {
            FileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            List items = null;
            try {
                items = upload.parseRequest(request);
            } catch (FileUploadException e) {
                e.printStackTrace();
            }
            Iterator itr = items.iterator();

            int count = 0;
            while (itr.hasNext()) {
                FileItem item = (FileItem) itr.next();

                if (!item.isFormField()) {
                    try {
                        String itemName = item.getName();
                        File savedFile = new File(userDirectoryPath + System.getProperty("file.separator") + count + itemName.substring(itemName.length() - 4));
                        item.write(savedFile);
                        count++;
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }
        response.sendRedirect("magicwand.jsp");
    }
}
