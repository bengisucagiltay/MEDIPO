package bitmap;

import java.awt.*;

public class BorderLayer extends Layer {
    public BorderLayer(int w, int h) {
        super(w, h);
    }

    public void setPixel(int w, int h) {
        setRGB(w, h, Color.green.getRGB());
    }
}
