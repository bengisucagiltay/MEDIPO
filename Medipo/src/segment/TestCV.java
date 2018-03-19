package segment;

import org.opencv.core.*;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
/*

public class TestCV {

    public static void main( String[] args ) {
        try {
            int kernelSize = 9;
            //System.loadLibrary( Core.NATIVE_LIBRARY_NAME );
            System.load("C:\\Users\\Bengisu\\Downloads\\opencv\\build\\java\\x64\\opencv_java340.dll");


            //TODO:: !!!! IMPLEMENT WITH ROI !!!!
            String imgType =".bmp";

            for(int i=55; i<59; i++) {
                Mat source = Imgcodecs.imread("ba\\im"+ i + imgType, Imgcodecs.CV_LOAD_IMAGE_GRAYSCALE);
                Mat destination = new Mat(source.rows(), source.cols(), source.type());

                //TODO:: CANNY EDGE DETECTION
                Mat canny = new Mat();
                Imgproc.Canny(source, canny, 80, 100);
                Imgcodecs.imwrite("out-canny\\canny-"+ i +imgType, canny);

                //TODO:: SOBEL
                Mat sobelX = new Mat();
                Mat sobelY = new Mat();
                Mat gradient = new Mat();

                Imgproc.Sobel( source, sobelX, CvType.CV_32F, 1, 0, -1, 1.0, 0 );
                Imgcodecs.imwrite("out-sobel\\sobel-x-"+ i +imgType, sobelX);

                Imgproc.Sobel( source, sobelY, CvType.CV_32F, 0, 1, -1, 1.0, 0 );
                Imgcodecs.imwrite("out-sobel\\sobel-y-"+ i +imgType, sobelY);


                //TODO::çarpma toplama xor denenebilir
                Core.multiply( sobelX, sobelY, gradient );
                Core.convertScaleAbs( gradient, gradient );
                Imgcodecs.imwrite("out-sobel\\gradient-"+ i +imgType, gradient);


                //TODO::contour

                List<MatOfPoint> contours = new ArrayList<>();
                Mat dest = Mat.zeros(source.size(), CvType.CV_8UC3);
                Scalar white = new Scalar(255, 255, 255);

                // Find contours
                Imgproc.findContours(source, contours, new Mat(), Imgproc.RETR_EXTERNAL, Imgproc.CHAIN_APPROX_SIMPLE);

                // Draw contours in dest Mat
                Imgproc.drawContours(dest, contours, -1, white);

                for (MatOfPoint contour: contours)
                    Imgproc.fillPoly(dest, Arrays.asList(contour), white);
                Scalar green = new Scalar(81, 190, 0);
                for (MatOfPoint contour: contours) {
                    RotatedRect rotatedRect = Imgproc.minAreaRect(new MatOfPoint2f(contour.toArray()));
                    drawRotatedRect(dest, rotatedRect, green, 4);
                }

                //TODO:: OTHER contour

                //TODO:: findContours() to ROI
                //https://stackoverflow.com/questions/42004652/how-can-i-find-contours-inside-roi-using-opencv-and-python
                //https://stackoverflow.com/questions/22769747/how-to-crop-mat-using-contours-in-opencv-for-java
                //https://stackoverflow.com/questions/21287179/crop-the-region-of-interest-with-few-points-available
            }

        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }


    public static void drawRotatedRect(Mat image, RotatedRect rotatedRect, Scalar color, int thickness) {
        Point[] vertices = new Point[4];
        rotatedRect.points(vertices);
        MatOfPoint points = new MatOfPoint(vertices);
        Imgproc.drawContours(image, Arrays.asList(points), -1, color, thickness);
    }
}*/