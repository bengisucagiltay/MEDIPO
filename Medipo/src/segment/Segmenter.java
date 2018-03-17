package segment;

import bitmap.EditableImage;

import javax.swing.text.Segment;
import java.awt.*;

public class Segmenter {


    private int threshold;

    public void calculateThreshold(EditableImage image){
        int sumR = 0, sumG = 0, sumB = 0;

        for (int i = 0; i < image.getHeight(); i++) {
            for (int j = 0; j < image.getWidth(); j++) {
                Color pixel = new Color(image.getRGB(j, i));
                sumR += pixel.getRed();
                sumG += pixel.getGreen();
                sumB += pixel.getBlue();
            }
        }

        int pixelCount =  image.getHeight() * image.getWidth();
        threshold = (int) ((sumR + sumG + sumB) / (pixelCount * 1.5));
    }

    public void scanImage(EditableImage image){
        Color imageColor;
        int left = image.getWidth(), right = 0, up = image.getHeight(), down = 0;

        for(int i = 0; i < image.getWidth(); i++) {
            for(int j = 0; j < image.getHeight(); j++) {
                imageColor = new Color(image.getRGB(i, j));
                if(imageColor.getRed() > threshold) {
                    image.getBorderLayer().setPixel(i, j);
                    if(j < up)
                        up = j;
                    break;
                }
            }
        }

        for(int i = image.getWidth() - 1; i >= 0; i--) {
            for(int j = image.getHeight() - 1; j >= 0; j--) {
                imageColor = new Color(image.getRGB(i, j));
                if(imageColor.getRed() > threshold) {
                    image.getBorderLayer().setPixel(i, j);
                    if(j > down)
                        down = j;
                    break;
                }
            }
        }

        for(int j = 0; j < image.getHeight(); j++) {
            for(int i = 0; i < image.getWidth(); i++) {
                imageColor = new Color(image.getRGB(i, j));
                if(imageColor.getRed() > threshold) {
                    image.getBorderLayer().setPixel(i, j);
                    if(i < left)
                        left = i;
                    break;
                }
            }
        }

        for(int j = image.getHeight() - 1; j >= 0; j--) {
            for(int i = image.getWidth() - 1; i >= 0; i--) {
                imageColor = new Color(image.getRGB(i, j));
                if(imageColor.getRed() > threshold) {
                    image.getBorderLayer().setPixel(i, j);
                    if(i > right)
                        right = i;
                    break;
                }
            }
        }

        for(int i = 0; i < 4; i++) {
            for(int j = 0; j < image.getWidth(); j++) {
                image.getSizeLayer().setPixel(j, up);
                image.getSizeLayer().setPixel(j, down);
                image.getSizeLayer().setPixel(left, j);
                image.getSizeLayer().setPixel(right, j);
            }
        }
    }
}
