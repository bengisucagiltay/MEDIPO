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

@WebServlet("/SuperPixelPixelate")
public class SuperPixelPixelate extends HttpServlet {

    private static final int M = 20;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = (String)request.getSession().getAttribute("email");
        String extension = (String)request.getSession().getAttribute("extension");
        int index = Integer.parseInt(request.getParameter("index"));
        double superPixelSize = Double.parseDouble(request.getParameter("superPixelSize"));

        SuperPixel s = new SuperPixel();
        BufferedImage img = null;
        try {
            img = ImageIO.read(new File(FileManager.getDirPath_UserUpload(email) + "/" + index + extension));
        } catch (IOException e) {
            e.printStackTrace();
        }

        s.calculate(img, superPixelSize, M);

        String responseText = s.getSpBorder() + "|" + s.getSpAverage() + "|" + s.getSpCenter() + "|" + s.getPixelsOfSp() + "|" + s.getSpNeighbourList() + "|" + s.getSpOfPixels();
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(responseText);
        response.getWriter().flush();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        doPost(request, response);
    }
}
