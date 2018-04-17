package segment;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Queue;

public class Wand {
    private double centerX;
    private double centerY;
    private double average;
    private double tolerance;
    private Queue<Point> queue;
    private ArrayList<String> boundry;
    private ArrayList<String> selection;

    public Wand(double tolerance) {
        this.tolerance = tolerance;
        centerX = 0;
        centerY = 0;
        average = 0;
        queue = new LinkedList<>();
        boundry = new ArrayList<>();
        selection = new ArrayList<>();
    }

    private int getPixelValue(BufferedImage image, int x, int y) {
        Color clr = new Color(image.getRGB(x, y));
        return (clr.getRed() + clr.getBlue() + clr.getGreen()) / 3;
    }

    public void process(BufferedImage image, int x, int y) {
        boolean[][] boundryChecked = new boolean[image.getWidth()][image.getHeight()];
        boolean[][] selectionChecked = new boolean[image.getWidth()][image.getHeight()];

        average = getPixelValue(image, x, y);
        queue.add(new Point(x, y));

        int count = 0;
        while (!queue.isEmpty()) {
            Point current = queue.remove();

            int currentX = (int) current.getX();
            int currentY = (int) current.getY();

            if (currentX < 0 || currentY < 0 || currentX >= image.getWidth() || currentY >= image.getHeight()) {
                continue;
            }
            if (selectionChecked[currentX][currentY]) {
                continue;
            }

            int pixelValue = getPixelValue(image, currentX, currentY);
            if ((Math.abs(average - pixelValue)) / 255 < tolerance) {
                selection.add(currentX + "," + currentY);
                selectionChecked[currentX][currentY] = true;

                count++;
                average = (average * (count - 1) + pixelValue) / count;
                centerX = (centerX * (count - 1) + currentX) / (double) count;
                centerY = (centerY * (count - 1) + currentY) / (double) count;

                queue.add(new Point(currentX - 1, currentY));
                queue.add(new Point(currentX + 1, currentY));
                queue.add(new Point(currentX, currentY - 1));
                queue.add(new Point(currentX, currentY + 1));
            }
        }

        y = 0;
        while (!selectionChecked[x][y]) y++;

        queue.add(new Point(x, y));

        while (!queue.isEmpty()) {
            Point current = queue.remove();

            int currentX = (int) current.getX();
            int currentY = (int) current.getY();

            if (currentX < 0 || currentY < 0 || currentX >= image.getWidth() || currentY >= image.getHeight()) {
                continue;
            }

            if (boundryChecked[currentX][currentY]) {
                continue;
            }

            if (selectionChecked[currentX][currentY]) {
                if (     !(selectionChecked[currentX - 1][currentY]
                        && selectionChecked[currentX - 1][currentY - 1]
                        && selectionChecked[currentX - 1][currentY + 1]
                        && selectionChecked[currentX][currentY - 1]
                        && selectionChecked[currentX][currentY + 1]
                        && selectionChecked[currentX + 1][currentY]
                        && selectionChecked[currentX + 1][currentY - 1]
                        && selectionChecked[currentX + 1][currentY + 1]
                )) {
                    boundry.add(currentX + "," + currentY);
                    boundryChecked[currentX][currentY] = true;

                    queue.add(new Point(currentX - 1, currentY));
                    queue.add(new Point(currentX - 1, currentY - 1));
                    queue.add(new Point(currentX - 1, currentY + 1));
                    queue.add(new Point(currentX, currentY - 1));
                    queue.add(new Point(currentX, currentY + 1));
                    queue.add(new Point(currentX + 1, currentY));
                    queue.add(new Point(currentX + 1, currentY - 1));
                    queue.add(new Point(currentX + 1, currentY + 1));
                }
            }
        }
    }

    public ArrayList<String> getBoundry() {
        return boundry;
    }

    public ArrayList<String> getSelection() {
        return selection;
    }

    public double getAverage() {
        return average;
    }

    public Point getCenter() {
        return new Point((int) centerX, (int) centerY);
    }
}
