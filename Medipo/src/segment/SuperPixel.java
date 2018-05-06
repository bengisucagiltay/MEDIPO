package segment;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.util.*;
import java.util.Queue;

/**
 * @author tejopa, 2014
 * @version 1
 * http://popscan.blogspot.com
 */
public class SuperPixel {

    private int height;
    private int width;
    private int[] reds;
    private int[] greens;
    private int[] blues;
    private int[] labels;
    private Cluster[] clusters;


    private Set<Point> selectionBorderArray;


    private StringBuilder spBorder;
    private StringBuilder spAverage;
    private StringBuilder spCenter;
    private StringBuilder pixelsOfSp;
    private StringBuilder neighbourList;
    private StringBuilder spOfPixels;

    public SuperPixel() {
        spBorder = new StringBuilder();
        spAverage = new StringBuilder();
        spCenter = new StringBuilder();
        pixelsOfSp = new StringBuilder();
        neighbourList = new StringBuilder();
        spOfPixels = new StringBuilder();

        selectionBorderArray = new HashSet<>();
    }

    public void calculate(BufferedImage image, double S, double m) {
        width = image.getWidth();
        height = image.getHeight();
        BufferedImage result = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);

        int[] pixels = image.getRGB(0, 0, width, height, null, 0, width);

        double[] distances = new double[width * height];
        Arrays.fill(distances, Integer.MAX_VALUE);
        labels = new int[width * height];
        Arrays.fill(labels, -1);

        reds = new int[width * height];
        greens = new int[width * height];
        blues = new int[width * height];
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                int pos = x + y * width;
                int color = pixels[pos];
                reds[pos] = color >> 16 & 0x000000FF;
                greens[pos] = color >> 8 & 0x000000FF;
                blues[pos] = color & 0x000000FF;
            }
        }

        createClusters(image, S, m);

        int loops = 0;
        int maxClusteringLoops = 50;
        boolean pixelChangedCluster = true;
        while (pixelChangedCluster && loops < maxClusteringLoops) {
            pixelChangedCluster = false;
            loops++;

            for (Cluster c : clusters) {
                int xs = Math.max((int) (c.avg_x - S), 0);
                int ys = Math.max((int) (c.avg_y - S), 0);
                int xe = Math.min((int) (c.avg_x + S), width);
                int ye = Math.min((int) (c.avg_y + S), height);

                for (int y = ys; y < ye; y++) {
                    for (int x = xs; x < xe; x++) {
                        int pos = x + width * y;
                        double D = c.distance(x, y, reds[pos], greens[pos], blues[pos]);
                        if ((D < distances[pos]) && (labels[pos] != c.id)) {
                            distances[pos] = D;
                            labels[pos] = c.id;
                            pixelChangedCluster = true;
                        }
                    }
                }
            }

            for (Cluster cluster : clusters) {
                cluster.reset();
            }

            for (int y = 0; y < height; y++) {
                for (int x = 0; x < width; x++) {
                    int pos = x + y * width;
                    clusters[labels[pos]].addPixel(x, y, reds[pos], greens[pos], blues[pos]);
                }
            }

            for (Cluster cluster : clusters) {
                cluster.calculateCenter();
            }
        }

        boolean[][] adjacencyArray = new boolean[clusters.length][clusters.length];

        for (int y = 1; y < height - 1; y++) {
            for (int x = 1; x < width - 1; x++) {
                int id1 = labels[x + y * width];
                int id2 = labels[(x + 1) + y * width];
                int id3 = labels[x + (y + 1) * width];
                if (id1 != id2) {
                    adjacencyArray[id1][id2] = true;
                    adjacencyArray[id2][id1] = true;
                    spBorder.append(x + "," + y + ",");
                    selectionBorderArray.add(new Point(x, y));
                } else if (id1 != id3) {
                    adjacencyArray[id1][id3] = true;
                    adjacencyArray[id3][id1] = true;
                    spBorder.append(x + "," + y + ",");
                    selectionBorderArray.add(new Point(x, y));
                } else {
                    result.setRGB(x, y, image.getRGB(x, y));
                }
            }
        }

        for (Cluster c : clusters) {
            spCenter.append((int) c.avg_x + "," + (int) c.avg_y + ",");
            spAverage.append(c.getAverageColor() + ",");

            ArrayList<Point> clusterPixels = c.pixels;

            for (Point clusterPixel : clusterPixels) {
                pixelsOfSp.append(clusterPixel.x + "," + clusterPixel.y + ",");
            }

            pixelsOfSp.deleteCharAt(pixelsOfSp.length() - 1);
            pixelsOfSp.append("$");

        }

        for (int i = 0; i < labels.length; i++) {
            spOfPixels.append(labels[i] + ",");
        }

        for (int i = 0; i < adjacencyArray.length; i++) {
            for (int j = 0; j < adjacencyArray.length; j++) {
                if (adjacencyArray[i][j]) {
                    clusters[i].neighbours.add(clusters[j]);
                }
            }
        }

        for (Cluster c : clusters) {
            for(Cluster neighbour: c.neighbours){
                neighbourList.append(neighbour.id + ",");
            }

            neighbourList.deleteCharAt(neighbourList.length() - 1);
            neighbourList.append("$");
        }

    }

    private void createClusters(BufferedImage image, double S, double m) {
        Vector<Cluster> temp = new Vector<>();
        int w = image.getWidth();
        int h = image.getHeight();
        boolean even = false;
        double xStart;
        int id = 0;
        for (double y = S / 2; y < h; y += S) {
            if (even) {
                xStart = S / 2.0;
                even = false;
            } else {
                xStart = S;
                even = true;
            }
            for (double x = xStart; x < w; x += S) {
                int pos = (int) (x + y * w);
                Cluster c = new Cluster(id, reds[pos], greens[pos], blues[pos], (int) x, (int) y, S, m);
                temp.add(c);
                id++;
            }
        }

        clusters = new Cluster[temp.size()];
        for (int i = 0; i < temp.size(); i++) {
            clusters[i] = temp.elementAt(i);
        }
    }

    public String getSpBorder() {
        return spBorder.deleteCharAt(spBorder.length() - 1).toString();
    }

    public String getSpAverage() {
        return spAverage.deleteCharAt(spAverage.length() - 1).toString();
    }

    public String getSpCenter() {
        return spCenter.deleteCharAt(spCenter.length() - 1).toString();
    }

    public String getPixelsOfSp() {
        return pixelsOfSp.deleteCharAt(pixelsOfSp.length() - 1).toString();
    }

    public String getSpNeighbourList(){
        return neighbourList.deleteCharAt(neighbourList.length() - 1).toString();
    }

    public String getSpOfPixels(){
        return spOfPixels.deleteCharAt(spOfPixels.length() - 1).toString();
    }

    public String magicWand(int clickIndex, double tolerance) {
        Queue<Integer> queue = new LinkedList<>();
        StringBuilder selection = new StringBuilder();
        boolean[] selectionChecked = new boolean[clusters.length];

        queue.add(clickIndex);
        double startAverage = clusters[clickIndex].getAverageColor();
        double finalAverage = startAverage;

        int count = 0;
        while (!queue.isEmpty()) {
            int current = queue.remove();

            if (selectionChecked[current]) {
                continue;
            }

            double pixelValue = clusters[current].getAverageColor();
            if ((Math.abs(startAverage - pixelValue)) / 255 < tolerance) {
                selection.append(current).append(",");
                selectionChecked[current] = true;

                count++;
                //startAverage = (startAverage * (count - 1) + pixelValue) / count;
                finalAverage = (finalAverage * (count - 1) + pixelValue) / count;

                for (int i = 0; i < clusters[current].neighbours.size(); i++) {
                    queue.add(clusters[current].neighbours.get(i).id);
                }
            }
        }

        StringBuilder selectionBorder = getBorder(selectionChecked);

        return selection.substring(0, selection.length() - 1) + "|" + selectionBorder.substring(0, selectionBorder.length() - 1) + "|" + finalAverage;
    }

    public String castSelection(ArrayList<Integer> selectionArray, ArrayList<Integer> spOfPixelsArray, ArrayList<Double> spAverageArray, double coverageTolerance, double averageTolerance) {
        StringBuilder selection = new StringBuilder();
        StringBuilder spSelected = new StringBuilder();
        double finalAverage = 0.0;
        int count = 0;
        boolean[] selectionChecked = new boolean[clusters.length];

        double[] coverageArray = new double[clusters.length];
        Arrays.fill(coverageArray, 0.0);

        for(int i = 0; i < selectionArray.size(); i += 2){
            int cluster = labels[selectionArray.get(i) + selectionArray.get(i + 1) * width];

            coverageArray[cluster] += 1.0 / clusters[cluster].pixelCount;
        }

        for (int i = 0; i < coverageArray.length; i++) {
            if(coverageArray[i] > coverageTolerance && (clusters[i].getAverageColor() - spAverageArray.get( spOfPixelsArray.get( (int)clusters[i].avg_x + (int)clusters[i].avg_y * width ) )) / 255.0 < averageTolerance){
                selectionChecked[i] = true;
                count++;
                finalAverage += clusters[i].getAverageColor();
                ArrayList<Point> clusterPixels = clusters[i].pixels;
                for (Point clusterPixel : clusterPixels) {
                    selection.append(clusterPixel.x);
                    selection.append(",");
                    selection.append(clusterPixel.y);
                    selection.append(",");
                }
            }
        }

        finalAverage /= count;

        StringBuilder border = getBorder(selectionChecked);

        for(int i = 0; i < selectionChecked.length; i++)
            if(selectionChecked[i])
                spSelected.append(i + ",");

        if(selection.length() > 0) {
            selection.deleteCharAt(selection.length() - 1);
            spSelected.deleteCharAt(spSelected.length() - 1);
            border.deleteCharAt(border.length() - 1);
        }

        return selection + "|" + border + "|" + spSelected + "|" + finalAverage;
    }

    private StringBuilder getBorder(boolean[] selectionChecked){
        StringBuilder border = new StringBuilder();

        for(Point pixel : selectionBorderArray){
            int currentX = pixel.x;
            int currentY = pixel.y;

            int currentSuperPixel = labels[currentX + currentY * width];
            int leftSuperPixel = labels[(currentX - 1) + currentY * width];
            int rightSuperPixel = labels[(currentX + 1) + currentY * width];
            int upSuperPixel = labels[currentX + (currentY - 1) * width];
            int downSuperPixel = labels[currentX + (currentY + 1) * width];

            if(selectionChecked[currentSuperPixel] && (!selectionChecked[leftSuperPixel] || !selectionChecked[rightSuperPixel] || !selectionChecked[upSuperPixel] || !selectionChecked[downSuperPixel]))
                border.append(currentX).append(",").append(currentY).append(",");
            else if(!selectionChecked[currentSuperPixel] && (selectionChecked[leftSuperPixel] || selectionChecked[rightSuperPixel] || selectionChecked[upSuperPixel] || selectionChecked[downSuperPixel]))
                border.append(currentX).append(",").append(currentY).append(",");
        }

        return border;
    }

    class Cluster {
        int id;
        double inv;
        double pixelCount;
        double avg_red;
        double avg_green;
        double avg_blue;
        double sum_red;
        double sum_green;
        double sum_blue;
        double sum_x;
        double sum_y;
        double avg_x;
        double avg_y;

        ArrayList<Point> pixels;
        ArrayList<Cluster> neighbours;

        Cluster(int id, int in_red, int in_green, int in_blue, int x, int y, double S, double m) {
            this.inv = 1.0 / ((S / m) * (S / m));
            this.id = id;

            pixels = new ArrayList<>();
            neighbours = new ArrayList<>();

            addPixel(x, y, in_red, in_green, in_blue);
            calculateCenter();
        }

        public void reset() {
            avg_red = 0;
            avg_green = 0;
            avg_blue = 0;
            sum_red = 0;
            sum_green = 0;
            sum_blue = 0;
            pixelCount = 0;
            avg_x = 0;
            avg_y = 0;
            sum_x = 0;
            sum_y = 0;

            pixels = new ArrayList<>();
            neighbours = new ArrayList<>();
        }

        double getAverageColor() {
            return ((avg_red + avg_green + avg_blue) / 3);
        }

        void addPixel(int x, int y, int in_red, int in_green, int in_blue) {
            sum_x += x;
            sum_y += y;
            sum_red += in_red;
            sum_green += in_green;
            sum_blue += in_blue;

            pixels.add(new Point(x, y));
            pixelCount++;
        }

        void calculateCenter() {
            double inv = 1 / pixelCount;
            avg_red = sum_red * inv;
            avg_green = sum_green * inv;
            avg_blue = sum_blue * inv;
            avg_x = sum_x * inv;
            avg_y = sum_y * inv;
        }

        double distance(int x, int y, int red, int green, int blue) {
            double dx_color = (avg_red - red) * (avg_red - red) + (avg_green - green) * (avg_green - green) + (avg_blue - blue) * (avg_blue - blue);
            double dx_spatial = (avg_x - x) * (avg_x - x) + (avg_y - y) * (avg_y - y);
            return Math.sqrt(dx_color) + Math.sqrt(dx_spatial * inv);
        }

    }

}