package bitmap;

import java.awt.*;

public class MarkLayer extends Layer {
    public MarkLayer(int w, int h) {
        super(w, h);
    }

    public void setPixel(int w, int h) {
        setRGB(w, h, Color.blue.getRGB());
    }
}
