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

@WebServlet("/MSuperpixel")
public class MSuperPixel extends HttpServlet {

    private static final int M = 100;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = (String)request.getSession().getAttribute("email");
        String extension = (String)request.getSession().getAttribute("extension");
        int imageID = Integer.parseInt(request.getParameter("imageID"));
        int clickIndex = Integer.parseInt(request.getParameter("clickIndex"));
        double superPixelSize = Double.parseDouble(request.getParameter("superPixelSize"));
        String selection = request.getParameter("selection");
        double tolerance = Double.parseDouble(request.getParameter("tolerance"));

        SuperPixel s = new SuperPixel();
        BufferedImage img = null;
        try {
            img = ImageIO.read(new File(FileManager.getDirPath_UserUpload(email) + "/" + imageID + extension));
        } catch (IOException e) {
            e.printStackTrace();
        }
        s.calculate(img, superPixelSize, M);

        String responseText = ""; //getResponseString(s.getTotalBorderArray()) + "|" + getResponseString(s.getCenterList()) + "|" + getResponseString(s.getAverageList()) + "|" + getResponseString(s.getClusterPixelList());

        if(selection != null){
            ArrayList<Integer> selectionArray = getIntegerArray(selection);
            String result = ""; //s.castSelection(selectionArray, 0.5);
            responseText += "|" + result;
        }
        else if(clickIndex != -1){
            String result = s.magicWand(clickIndex, tolerance);
            responseText += "|" + result;
        }

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(responseText);
        response.getWriter().flush();
    }

    private String getResponseString(ArrayList<String> strArrayList) {
        StringBuilder response = new StringBuilder();
        for (int i = 0; i < strArrayList.size(); i++) {
            String str = strArrayList.get(i);

            if(i < strArrayList.size() - 1)
                if(strArrayList.get(i + 1).equals("$")){
                    response.append(str).append("$");
                    i++;
                }
                else{
                    response.append(str).append(",");
                }
            else
                response.append(str);
        }

        return response.toString();
    }

    private ArrayList<Integer> getIntegerArray(String boundry) {
        ArrayList<Integer> result = new ArrayList<>();

        String[] tokens = boundry.split(",");

        for (String token : tokens) {
            result.add(Integer.parseInt(token));
        }

        return result;
    }

}
