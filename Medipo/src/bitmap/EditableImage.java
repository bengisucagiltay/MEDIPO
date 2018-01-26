package bitmap;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.util.ArrayList;

public class EditableImage extends BufferedImage{

    private int threshold;
    private BorderLayer borderLayer;
    private SizeLayer sizeLayer;
    private MarkLayer markLayer;
    private ArrayList<Layer> layers;

    public EditableImage(BufferedImage image) {
        super(image.getWidth(), image.getHeight(), BufferedImage.TYPE_INT_RGB);

        threshold = -1;

        borderLayer = new BorderLayer(getWidth(), getHeight());
        sizeLayer = new SizeLayer(getWidth(), getHeight());
        markLayer = new MarkLayer(getWidth(), getHeight());

        layers = new ArrayList<>();

        layers.add(borderLayer);
        layers.add(sizeLayer);
        layers.add((markLayer));

        copyFromImage(image);
        calculateThreshold();
        scanImage();
    }

    private void copyFromImage(BufferedImage image){
        getGraphics().drawImage(image, 0, 0, null);
    }

    private void calculateThreshold(){
        int sumR = 0, sumG = 0, sumB = 0;

        for (int i = 0; i < getHeight(); i++) {
            for (int j = 0; j < getWidth(); j++) {
                Color pixel = new Color(getRGB(j, i));
                sumR += pixel.getRed();
                sumG += pixel.getGreen();
                sumB += pixel.getBlue();
            }
        }

        int pixelCount =  getHeight() * getWidth();
        threshold = (int) ((sumR + sumG + sumB) / (pixelCount * 1.5));
    }

    private void scanImage(){
        Color imageColor;
        int left = getWidth(), right = 0, up = getHeight(), down = 0;

        for(int i = 0; i < getWidth(); i++) {
            for(int j = 0; j < getHeight(); j++) {
                imageColor = new Color(getRGB(i, j));
                if(imageColor.getRed() > threshold) {
                    borderLayer.setPixel(i, j);
                    if(j < up)
                        up = j;
                    break;
                }
            }
        }

        for(int i = getWidth() - 1; i >= 0; i--) {
            for(int j = getHeight() - 1; j >= 0; j--) {
                imageColor = new Color(getRGB(i, j));
                if(imageColor.getRed() > threshold) {
                    borderLayer.setPixel(i, j);
                    if(j > down)
                        down = j;
                    break;
                }
            }
        }

        for(int j = 0; j < getHeight(); j++) {
            for(int i = 0; i < getWidth(); i++) {
                imageColor = new Color(getRGB(i, j));
                if(imageColor.getRed() > threshold) {
                    borderLayer.setPixel(i, j);
                    if(i < left)
                        left = i;
                    break;
                }
            }
        }

        for(int j = getHeight() - 1; j >= 0; j--) {
            for(int i = getWidth() - 1; i >= 0; i--) {
                imageColor = new Color(getRGB(i, j));
                if(imageColor.getRed() > threshold) {
                    borderLayer.setPixel(i, j);
                    if(i > right)
                        right = i;
                    break;
                }
            }
        }

        for(int i = 0; i < 4; i++) {
            for(int j = 0; j < getWidth(); j++){
                sizeLayer.setPixel(j, up);
                sizeLayer.setPixel(j, down);
                sizeLayer.setPixel(left, j);
                sizeLayer.setPixel(right, j);
            }
        }
    }

    public MarkLayer getMarkLayer() {
        return markLayer;
    }

    public ArrayList<Layer> getLayers() {
        return layers;
    }
}
