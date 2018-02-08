package client;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;

@WebServlet(name = "ClientServlet")
public class ClientServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        BufferedImage bufferedimage = ImageIO.read(new File("./resource/ba/im1.bmp"));
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(bufferedimage, "bmp", baos );
        baos.flush();
        byte[] imageInByteArray = baos.toByteArray();
        baos.close();
        String b64 = javax.xml.bind.DatatypeConverter.printBase64Binary(imageInByteArray);
        request.getSession().setAttribute("b64", b64);
    }
}
