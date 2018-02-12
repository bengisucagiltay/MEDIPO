package gui;

import bitmap.EditableImage;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class ImagePanel extends JPanel {

    private EditableImage image;

    public ImagePanel(EditableImage image){
        super();
        this.image = image;
        setPreferredSize(new Dimension(image.getWidth(), image.getHeight()));
        addMouseWheelListener(new MyMouseWheelListener());
        addMouseMotionListener(new MyMouseMotionListener());
    }

    @Override
    protected void paintComponent(Graphics g) {
        g.drawImage(image, 0, 0, null);
        g.drawImage(image.getBorderLayer(), 0,0,null);
        g.drawImage(image.getSizeLayer(), 0,0,null);
        g.drawImage(image.getMarkLayer(), 0,0,null);
        repaint();
    }

    private class MyMouseMotionListener implements MouseMotionListener{
        @Override
        public void mouseDragged(MouseEvent e) {
            image.getMarkLayer().setPixel(e.getX(), e.getY());
        }

        @Override
        public void mouseMoved(MouseEvent e) {

        }
    }

    private class MyMouseWheelListener implements MouseWheelListener {
        @Override
        public void mouseWheelMoved(MouseWheelEvent e) {
            image.getMarkLayer().resetImage();
        }
    }
}
