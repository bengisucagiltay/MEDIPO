package bitmap;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.util.ArrayList;

public class EditableImage extends BufferedImage{

    private int threshold;
    private BorderLayer borderLayer;
    private SizeLayer sizeLayer;
    private MarkLayer markLayer;

    public EditableImage(BufferedImage image) {
        super(image.getWidth(), image.getHeight(), BufferedImage.TYPE_INT_RGB);

        threshold = -1;

        borderLayer = new BorderLayer(getWidth(), getHeight());
        sizeLayer = new SizeLayer(getWidth(), getHeight());
        markLayer = new MarkLayer(getWidth(), getHeight());

        copyFromImage(image);
    }

    private void copyFromImage(BufferedImage image){
        getGraphics().drawImage(image, 0, 0, null);
    }

    public BorderLayer getBorderLayer() {
        return borderLayer;
    }

    public SizeLayer getSizeLayer() {
        return sizeLayer;
    }

    public MarkLayer getMarkLayer() {
        return markLayer;
    }
}
