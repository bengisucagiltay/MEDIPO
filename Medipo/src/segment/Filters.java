package segment;

import org.opencv.core.*;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;
import utils.FileManager;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet("/Filters")
public class Filters extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("In filters");

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        String userDirectoryPath = FileManager.getUserDirectoryPath(email);
        String imgType = ".bmp";

        File imagesDir = new File(userDirectoryPath);
        File[] images = imagesDir.listFiles((dir, i) -> i.toLowerCase().endsWith(imgType));

        System.out.println("Before IF: " + email + "-email, imagesLength" + images.length);



        if (images.length == 0) {
            System.out.println("No image");
            RequestDispatcher rd = request.getRequestDispatcher("upload.jsp");
            rd.include(request, response);
        } else {
            String extension = images[0].getName().substring(images[0].getName().length() - 4);

            try {
                int kernelSize = 9;
                //System.loadLibrary( Core.NATIVE_LIBRARY_NAME );
                System.load("C:\\Users\\Bengisu\\IdeaProjects\\CS491-Medipo\\Medipo\\lib\\opencv_java340.dll");
                //System.load("lib/opencv_java340.dll");

                //TODO:: !!!! IMPLEMENT WITH ROI !!!!

                for (int i = 0; i < images.length; i++) {
                    /*String out = FileManager.getResourcesDirectoryPath() + "\\out-canny\\canny-" + (i + 1) +
                            extension;*/
                    String path = "C:\\Users\\Bengisu\\IdeaProjects\\CS491-Medipo\\out\\artifacts" +
                            "\\Medipo_war_exploded" +
                            "\\resources\\users\\" + email.replace('@', '-');

                    Mat source = Imgcodecs.imread(path + "\\" + (i + 1) + extension, Imgcodecs
                            .CV_LOAD_IMAGE_GRAYSCALE);

                    Mat destination = new Mat(source.rows(), source.cols(), source.type());

                    //TODO:: CANNY EDGE DETECTION
                    //TODO:: PATH DÜZELT
                    Mat canny = new Mat();
                    Imgproc.Canny(source, canny, 80, 100);

                    String cannyOut = path + "\\out-canny";

                    //out.replace("/", "\\");
                    //out.replace("\\", "/");

                    createDir(cannyOut);

                    createFile(cannyOut + "\\canny-" + (i+1) + imgType);
                    String cannyWrite = cannyOut + "\\canny-" + (i+1) + imgType;

                    Imgcodecs.imwrite(cannyWrite, canny);
                    //Imgcodecs.imwrite("out-canny\\canny-" + i + imgType, canny);

                    //TODO:: SOBEL
                    Mat sobelX = new Mat();
                    Mat sobelY = new Mat();
                    Mat gradient = new Mat();

                    Imgproc.Sobel(source, sobelX, CvType.CV_32F, 1, 0, -1, 1.0, 0);

                    String sobelOut = path + "\\out-sobel";
                    createDir(sobelOut);

                    String sobelXWrite = sobelOut + "\\sobel-X-" + (i+1) + imgType;
                    Imgcodecs.imwrite(sobelXWrite, sobelX);
                    //Imgcodecs.imwrite(userDirectoryPath + "\\out-sobel\\sobel-x-" + (i + 1) + extension, sobelX);
                    //Imgcodecs.imwrite("out-sobel\\sobel-x-" + i + imgType, sobelX);

                    String sobelYWrite = sobelOut + "\\sobel-Y-" + (i+1) + imgType;
                    Imgcodecs.imwrite(sobelYWrite, sobelX);
                    Imgproc.Sobel(source, sobelY, CvType.CV_32F, 0, 1, -1, 1.0, 0);
                    //Imgcodecs.imwrite(userDirectoryPath + "\\out-sobel\\sobel-y-" + (i + 1) + extension, sobelY);
                    //Imgcodecs.imwrite("out-sobel\\sobel-y-" + i + imgType, sobelY);


                    //TODO::çarpma toplama xor denenebilir
                    Core.multiply(sobelX, sobelY, gradient);
                    Core.convertScaleAbs(gradient, gradient);

                    String gradientWrite = sobelOut + "\\gradient-" + (i+1) + imgType;
                    Imgcodecs.imwrite(gradientWrite, sobelX);
                    //Imgcodecs.imwrite(userDirectoryPath + "\\out-sobel\\gradient-" + (i + 1) + extension,
                    //gradient);
                    //Imgcodecs.imwrite("out-sobel\\gradient-" + i + imgType, gradient);


                    //TODO::contour

                   /* List<MatOfPoint> contours = new ArrayList<>();
                    Mat dest = Mat.zeros(source.size(), CvType.CV_8UC3);
                    Scalar white = new Scalar(255, 255, 255);

                    // Find contours
                    Imgproc.findContours(source, contours, new Mat(), Imgproc.RETR_EXTERNAL, Imgproc.CHAIN_APPROX_SIMPLE);

                    // Draw contours in dest Mat
                    Imgproc.drawContours(dest, contours, -1, white);

                    for (MatOfPoint contour : contours)
                        Imgproc.fillPoly(dest, Arrays.asList(contour), white);
                    Scalar green = new Scalar(81, 190, 0);
                    for (MatOfPoint contour : contours) {
                        RotatedRect rotatedRect = Imgproc.minAreaRect(new MatOfPoint2f(contour.toArray()));
                        drawRotatedRect(dest, rotatedRect, green, 4);
                    }*/

                        //TODO:: OTHER contour

                        //TODO:: findContours() to ROI
                        //https://stackoverflow.com/questions/42004652/how-can-i-find-contours-inside-roi-using-opencv-and-python
                        //https://stackoverflow.com/questions/22769747/how-to-crop-mat-using-contours-in-opencv-for-java
                        //https://stackoverflow.com/questions/21287179/crop-the-region-of-interest-with-few-points-available
                    }

                } catch(Exception e){
                    System.out.println("Error: " + e.getMessage());
                }
            }
            response.sendRedirect("filter.jsp");
        }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{}

        public static void drawRotatedRect (Mat image, RotatedRect rotatedRect, Scalar color,int thickness){
            Point[] vertices = new Point[4];
            rotatedRect.points(vertices);
            MatOfPoint points = new MatOfPoint(vertices);
            Imgproc.drawContours(image, Arrays.asList(points), -1, color, thickness);
        }

        public static String  createDir(String path){
                File f = new File(path);

                if (f.exists()) {
                    return path;
                } else {
                    System.out.println("creating because does not exist");
                    f.mkdirs();
                    return path;
                }
            }
    public static String createFile(String path){
        File f = new File(path);

        if (f.exists()) {
            return path;
        } else {
            try {
                f.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
            return path;
        }
    }

}