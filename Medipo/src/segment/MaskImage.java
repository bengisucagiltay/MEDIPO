package segment;

import utils.FileManager;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/MaskImage")
public class MaskImage extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = (String) request.getSession().getAttribute("email");
        String extension = (String) request.getSession().getAttribute("extension");
        String selection = request.getParameter("selection");
        String selectionIndexes = request.getParameter("selectionIndexes");

        ArrayList<String> strArray = getStringArray(selection);
        ArrayList<String> indArray = getStringArray(selectionIndexes);

        for (int i = 0; i < strArray.size(); i++) {
            maskImage(email, extension, indArray.get(i), getIntegerArray(strArray.get(i)));
        }

        String responseText = "done";
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(responseText);
        response.getWriter().flush();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    private ArrayList<String> getStringArray(String boundry) {
        ArrayList<String> result = new ArrayList<>();

        String[] tokens = boundry.split("-");

        for (String token : tokens) {
            result.add(token);
        }

        return result;
    }

    protected void maskImage(String email, String extension, String index, ArrayList<Integer> selection) {
        BufferedImage img0 = null;
        try {
            img0 = ImageIO.read(new File(FileManager.getDirPath_UserUpload(email) + "/" + index + extension));
        } catch (IOException e) {
            e.printStackTrace();
        }
        if (img0 != null) {
            BufferedImage img1 = new BufferedImage(img0.getWidth(), img0.getHeight(), BufferedImage.TYPE_INT_ARGB);
            BufferedImage img2 = new BufferedImage(img0.getWidth(), img0.getHeight(), BufferedImage.TYPE_INT_ARGB);

            for (int i = 0; i < selection.size(); i = i + 2) {
                img2.setRGB(selection.get(i), selection.get(i + 1), (new Color(200, 0, 0, 100).getRGB()));
            }

            System.out.println(img0.toString());

            Graphics g = img1.getGraphics();
            g.drawImage(img0, 0, 0, null);
            g.drawImage(img2, 0, 0, null);

            try {
                ImageIO.write(img1, "PNG", new File(FileManager.getDirPath_UserDownload(email), index + extension));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
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
