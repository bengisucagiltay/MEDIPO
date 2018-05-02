package segment;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Queue;

public class ExpandBorder {

    private ArrayList<Integer> border;
    private ArrayList<Integer> selection;
    private double finalAverage;

    private double getPixelValue(BufferedImage image, int x, int y) {
        Color color = new Color(image.getRGB(x, y));
        return (color.getRed() + color.getBlue() + color.getGreen()) / 3;
    }

    public void process(BufferedImage image, ArrayList<Integer> boundryArray, ArrayList<Integer> selectionArray, double average, double tolerance) {
        border = new ArrayList<>();
        selection = new ArrayList<>();

        finalAverage = average;

        Queue<Tuple> queue = new LinkedList<>();
        boolean[][] borderChecked = new boolean[image.getWidth()][image.getHeight()];
        boolean[][] selectionChecked = new boolean[image.getWidth()][image.getHeight()];
        boolean[][] selectionAdded = new boolean[image.getWidth()][image.getHeight()];

        for(int i = 0; i < selectionArray.size(); i += 2)
            selectionChecked[selectionArray.get(i)][selectionArray.get(i + 1)] = true;

        for(int i = 0; i < boundryArray.size(); i += 2) {
            selectionChecked[boundryArray.get(i)][boundryArray.get(i + 1)] = false;
            queue.add(new Tuple(-1, -1, boundryArray.get(i), boundryArray.get(i + 1)));
        }

        int count = 0;
        while (!queue.isEmpty()) {
            Tuple current = queue.remove();

            int currentX = current.dest.x;
            int currentY = current.dest.y;

            if (currentX < 0 || currentY < 0 || currentX >= image.getWidth() || currentY >= image.getHeight()) {
                continue;
            }
            if (selectionChecked[currentX][currentY]) {
                continue;
            }

            double pixelValue = getPixelValue(image, currentX, currentY);
            if (current.src.x == -1 || (Math.abs(pixelValue - average)) / 255 < tolerance) {
                selectionChecked[currentX][currentY] = true;


                count++;
                finalAverage = (finalAverage * (count - 1) + pixelValue) / count;

                queue.add(new Tuple(currentX, currentY,currentX - 1, currentY));
                queue.add(new Tuple(currentX, currentY,currentX + 1, currentY));
                queue.add(new Tuple(currentX, currentY, currentX, currentY - 1));
                queue.add(new Tuple(currentX, currentY, currentX, currentY + 1));
            }
        }

        int x = selectionArray.get(0), y = 0;
        while (!selectionChecked[x][y]) y++;

        Queue<Point> basicQueue = new LinkedList<>();
        basicQueue.add(new Point(x, y));

        while (!basicQueue.isEmpty()) {
            Point current = basicQueue.remove();

            int currentX = (int) current.getX();
            int currentY = (int) current.getY();

            if (currentX < 0 || currentY < 0 || currentX >= image.getWidth() || currentY >= image.getHeight()) {
                continue;
            }

            if (selectionAdded[currentX][currentY]) {
                continue;
            }

            if (selectionChecked[currentX][currentY]) {
                selection.add(currentX);
                selection.add(currentY);
                selectionAdded[currentX][currentY] = true;

                basicQueue.add(new Point(currentX - 1, currentY));
                basicQueue.add(new Point(currentX - 1, currentY - 1));
                basicQueue.add(new Point(currentX - 1, currentY + 1));
                basicQueue.add(new Point(currentX, currentY - 1));
                basicQueue.add(new Point(currentX, currentY + 1));
                basicQueue.add(new Point(currentX + 1, currentY));
                basicQueue.add(new Point(currentX + 1, currentY - 1));
                basicQueue.add(new Point(currentX + 1, currentY + 1));
            }
        }

        x = selectionArray.get(0);
        y = 0;

        while (!selectionChecked[x][y]) y++;

        basicQueue.add(new Point(x, y));

        while (!basicQueue.isEmpty()) {
            Point current = basicQueue.remove();

            int currentX = (int) current.getX();
            int currentY = (int) current.getY();

            if (currentX < 0 || currentY < 0 || currentX >= image.getWidth() || currentY >= image.getHeight()) {
                continue;
            }

            if (borderChecked[currentX][currentY]) {
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
                    border.add(currentX);
                    border.add(currentY);
                    borderChecked[currentX][currentY] = true;


                    basicQueue.add(new Point(currentX - 1, currentY));
                    basicQueue.add(new Point(currentX - 1, currentY - 1));
                    basicQueue.add(new Point(currentX - 1, currentY + 1));
                    basicQueue.add(new Point(currentX, currentY - 1));
                    basicQueue.add(new Point(currentX, currentY + 1));
                    basicQueue.add(new Point(currentX + 1, currentY));
                    basicQueue.add(new Point(currentX + 1, currentY - 1));
                    basicQueue.add(new Point(currentX + 1, currentY + 1));
                }
            }
        }

    }

    public ArrayList<Integer> getBorder() {
        return border;
    }

    public ArrayList<Integer> getSelection() {
        return selection;
    }

    public double getFinalAverage() {
        return finalAverage;
    }

    class Tuple {
        Point src;
        Point dest;

        Tuple(int srcX, int srcY, int destX, int destY){
            src = new Point(srcX, srcY);
            dest = new Point(destX, destY);
        }
    }
}
