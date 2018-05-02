package segment;

import utils.FileManager;

import javax.imageio.ImageIO;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/WandMagic")
public class WandMagic extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String extension = (String) request.getSession().getAttribute("extension");
        int imageID = Integer.parseInt(request.getParameter("imageID"));
        int x = Integer.parseInt(request.getParameter("x"));
        int y = Integer.parseInt(request.getParameter("y"));
        double tolerance = Double.parseDouble(request.getParameter("tolerance"));

        Wand w = new Wand();
        BufferedImage img = null;
        try {
            img = ImageIO.read(new File(FileManager.getDirPath_UserUpload((String) request.getSession().getAttribute("email")) + "/" + imageID + extension));
        } catch (IOException e) {
            e.printStackTrace();
        }
        w.process(img, x, y, tolerance);

        String responseText = getResponseString(w.getSelection()) + "|" + getResponseString(w.getBorder()) + "|" + w.getAverage() + "|" + w.getCenter().x + "," + w.getCenter().y;

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(responseText);
        response.getWriter().flush();
    }

    private String getResponseString(ArrayList<String> strArrayList) {
        StringBuilder response = new StringBuilder();
        for (String str : strArrayList) {
            response.append(str).append(",");
        }

        return response.substring(0, response.length() - 1);
    }
}
