package segment;

import utils.FileManager;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/ExpandBorderServlet")
public class ExpandBorderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("this is the do post for expand border servlet");


        String email = (String)request.getSession().getAttribute("email");
        String extension = (String)request.getSession().getAttribute("extension");
        int imageID = Integer.parseInt(request.getParameter("imageID"));
        String boundry = request.getParameter("boundry");
        String selection = request.getParameter("selection");
        double average = Double.parseDouble(request.getParameter("average"));
        double tolerance = Double.parseDouble(request.getParameter("tolerance"));

        BufferedImage img = null;
        try {
            img = ImageIO.read(new File(FileManager.getDirPath_UserUpload(email) + "/" + imageID + extension));
        } catch (IOException e) {
            e.printStackTrace();
        }

        ArrayList<Integer> boundryArray = getIntegerArray(boundry);
        ArrayList<Integer> selectionArray = getIntegerArray(selection);

        ExpandBorder e = new ExpandBorder();

        e.process(img, boundryArray, selectionArray, average, tolerance);

        String responseText = getResponseString(e.getBorder()) + "|" + getResponseString(e.getSelection()) + "|" + e.getFinalAverage();

        System.out.println("---" + responseText);

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(responseText);
        response.getWriter().flush();

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    private ArrayList<Integer> getIntegerArray(String boundry) {
        ArrayList<Integer> result = new ArrayList<>();

        String[] tokens = boundry.split(",");

        for (String token : tokens) {
            result.add(Integer.parseInt(token));
        }

        return result;
    }

    private String getResponseString(ArrayList<Integer> intArrayList) {
        StringBuilder response = new StringBuilder();
        for (int i = 0; i < intArrayList.size() - 1; i++) {
            response.append(intArrayList.get(i));
            response.append(",");
        }

        if(intArrayList.size() > 1)
            response.append(intArrayList.get(intArrayList.size() - 1));

        return response.toString();
    }

}
