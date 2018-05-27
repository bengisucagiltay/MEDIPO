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

@WebServlet("/SuperPixelCast")
public class SuperPixelCast extends HttpServlet {

    private static final int M = 20;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String email = (String) request.getSession().getAttribute("email");
            String extension = (String) request.getSession().getAttribute("extension");
            int index = Integer.parseInt(request.getParameter("index"));
            double superPixelSize = Double.parseDouble(request.getParameter("superPixelSize"));
            String spAverage = request.getParameter("spAverage");
            String selection = request.getParameter("selection");
            String spOfPixels = request.getParameter("spOfPixels");

            SuperPixel s = new SuperPixel();
            BufferedImage img = null;

            img = ImageIO.read(new File(FileManager.getDirPath_UserUpload(email) + "/" + index + extension));


            s.calculate(img, superPixelSize, M);

            String responseText = s.getSpBorder() + "|" + s.getSpAverage() + "|" + s.getSpCenter() + "|" + s.getPixelsOfSp() + "|" + s.getSpNeighbourList() + "|" + s.getSpOfPixels();
            ArrayList<Integer> selectionArray = getIntegerArray(selection);
            ArrayList<Integer> spOfPixelsArray = getIntegerArray(spOfPixels);
            ArrayList<Double> spAverageArray = getDoubleArray(spAverage);

            String result = s.castSelection(selectionArray, spOfPixelsArray, spAverageArray);
            responseText += "|" + result;

            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(responseText);
            response.getWriter().flush();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        doPost(request, response);
    }

    private ArrayList<Integer> getIntegerArray(String str) {
        ArrayList<Integer> result = new ArrayList<>();

        String[] tokens = str.split(",");

        for (String token : tokens) {
            result.add(Integer.parseInt(token));
        }

        return result;
    }

    private ArrayList<Double> getDoubleArray(String str) {
        ArrayList<Double> result = new ArrayList<>();

        String[] tokens = str.split(",");

        for (String token : tokens) {
            result.add(Double.parseDouble(token));
        }

        return result;
    }
}
