package bitmap;

import java.awt.image.BufferedImage;

public class Layer extends BufferedImage{

    public Layer(int w, int h){
        super(w, h, BufferedImage.TRANSLUCENT);
        resetImage();
    }

    public void resetImage(){
        for(int j = 0; j < getHeight(); j++){
            for(int i = 0; i < getWidth(); i++){
                setRGB(i, j, 0);
            }
        }
    }
}
