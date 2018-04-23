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

@WebServlet("/MagicSuperpixel")
public class MagicSuperpixel extends HttpServlet {

    private static final int M = 100;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String userEmail = (String)request.getSession().getAttribute("email");
        int imageID = Integer.parseInt(request.getParameter("imageID"));
        double superPixelSize = Double.parseDouble(request.getParameter("superPixelSize"));
        System.out.println(request.getParameter("clickIndex"));
        int clickIndex = Integer.parseInt(request.getParameter("clickIndex"));
        double tolerance = Double.parseDouble(request.getParameter("tolerance"));

        Superpixel s;

        s = new Superpixel();

        BufferedImage img = null;
        try {
            img = ImageIO.read(new File(FileManager.getDirPath_UserUpload(userEmail) + "/" + imageID + ".bmp"));
        } catch (IOException e) {
            e.printStackTrace();
        }

        s.calculate(img, superPixelSize, M);

        String responseText = getResponseString(s.getBoundry()) + "|" + getResponseString(s.getCenterList()) + "|" + getResponseString(s.getAverageList()) + "|" + getResponseString(s.getClusterLists());

        if(clickIndex != -1){
            String result = s.magicWand(clickIndex, tolerance);
            //System.out.println("-" + result + "-");
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
                    response.append(str + "$");
                    i++;
                }
                else{
                    response.append(str + ",");
                }
            else
                response.append(str);
        }

        return response.toString();
    }
}
