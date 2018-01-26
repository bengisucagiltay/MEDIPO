package bitmap;

import java.awt.*;

public class SizeLayer extends Layer {
    public SizeLayer(int w, int h) {
        super(w, h);
    }

    public void setPixel(int w, int h) {
        setRGB(w, h, Color.red.getRGB());
    }
}
