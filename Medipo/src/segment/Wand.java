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
    private ArrayList<String> border;
    private ArrayList<String> selection;

    public Wand() {
        centerX = -1;
        centerY = -1;
        average = -1;
        border = new ArrayList<>();
        selection = new ArrayList<>();
    }

    private double getPixelValue(BufferedImage image, int x, int y) {
        Color color = new Color(image.getRGB(x, y));
        return (color.getRed() + color.getBlue() + color.getGreen()) / 3;
    }

    public void process(BufferedImage image, int x, int y, double tolerance) {
        Queue<Point> queue = new LinkedList<>();
        boolean[][] borderChecked = new boolean[image.getWidth()][image.getHeight()];
        boolean[][] selectionChecked = new boolean[image.getWidth()][image.getHeight()];

        average = getPixelValue(image, x, y);
        queue.add(new Point(x, y));

        int count = 0;
        while (!queue.isEmpty()) {
            Point current = queue.remove();
            int currentX = current.x;
            int currentY = current.y;

            if (currentX < 0 || currentY < 0 || currentX >= image.getWidth() || currentY >= image.getHeight()) {
                continue;
            }
            if (selectionChecked[currentX][currentY]) {
                continue;
            }

            double pixelValue = getPixelValue(image, currentX, currentY);
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
            int currentX = current.x;
            int currentY = current.y;

            if (currentX < 0 || currentY < 0 || currentX >= image.getWidth() || currentY >= image.getHeight()) {
                continue;
            }

            if (borderChecked[currentX][currentY]) {
                continue;
            }

            if (selectionChecked[currentX][currentY]) {
                if (!(selectionChecked[currentX - 1][currentY]
                        && selectionChecked[currentX - 1][currentY - 1]
                        && selectionChecked[currentX - 1][currentY + 1]
                        && selectionChecked[currentX][currentY - 1]
                        && selectionChecked[currentX][currentY + 1]
                        && selectionChecked[currentX + 1][currentY]
                        && selectionChecked[currentX + 1][currentY - 1]
                        && selectionChecked[currentX + 1][currentY + 1]
                )) {
                    border.add(currentX + "," + currentY);
                    borderChecked[currentX][currentY] = true;

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

    public ArrayList<String> getBorder() {
        return border;
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
