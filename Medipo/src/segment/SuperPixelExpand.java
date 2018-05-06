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

@WebServlet("/SuperPixelExpand")
public class SuperPixelExpand extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = (String)request.getSession().getAttribute("email");
        String extension = (String)request.getSession().getAttribute("extension");
        int index = Integer.parseInt(request.getParameter("index"));
        String border = request.getParameter("border");
        String selection = request.getParameter("selection");
        double average = Double.parseDouble(request.getParameter("average"));
        double tolerance = Double.parseDouble(request.getParameter("tolerance"));

        BufferedImage img = null;
        try {
            img = ImageIO.read(new File(FileManager.getDirPath_UserUpload(email) + "/" + index + extension));
        } catch (IOException e) {
            e.printStackTrace();
        }

        ArrayList<Integer> borderArray = getIntegerArray(border);
        ArrayList<Integer> selectionArray = getIntegerArray(selection);

        ExpandBorder e = new ExpandBorder();

        e.process(img, borderArray, selectionArray, average, tolerance);

        String responseText = getResponseString(e.getBorder()) + "|" + getResponseString(e.getSelection()) + "|" + e.getFinalAverage();
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
