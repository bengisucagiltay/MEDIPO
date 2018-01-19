package bitmap;

import java.awt.Color;
import java.awt.image.BufferedImage;

public class BitmapEditor {
	public static final int THRESHOLD = 150;

	public BufferedImage createBoundImage(BufferedImage image) {

		int leftX = image.getWidth(), rightX = 0, leftY = image.getHeight(), rightY = 0;
		BufferedImage convertedImage = convertToRGB(image);
		Color imageColor;

		for(int j = 0; j < image.getHeight(); j++) {
			for(int i = 0; i < image.getWidth(); i++) {
				imageColor = new Color(image.getRGB(i, j));
				if(imageColor.getRed() > THRESHOLD || imageColor.getRed() > THRESHOLD || imageColor.getRed() > THRESHOLD) {
					convertedImage.setRGB(i, j, Color.RED.getRGB());
					if(i < leftX)
						leftX = i;
					break;
				}
			}
		}

		for(int j = image.getHeight() - 1; j >= 0; j--) {
			for(int i = image.getWidth() - 1; i >= 0; i--) {
				imageColor = new Color(image.getRGB(i, j));
				if(imageColor.getRed() > THRESHOLD || imageColor.getRed() > THRESHOLD || imageColor.getRed() > THRESHOLD) {
					convertedImage.setRGB(i, j, Color.RED.getRGB());
					if(i > rightX)
						rightX = i;
					break;
				}
			}
		}

		for(int i = 0; i < image.getWidth(); i++) {
			for(int j = 0; j < image.getHeight(); j++) {
				imageColor = new Color(image.getRGB(i, j));
				if(imageColor.getRed() > THRESHOLD || imageColor.getRed() > THRESHOLD || imageColor.getRed() > THRESHOLD) {
					convertedImage.setRGB(i, j, Color.RED.getRGB());
					if(j < leftY)
						leftY = j;
					break;
				}
			}
		}

		for(int i = image.getWidth() - 1; i >= 0; i--) {
			for(int j = image.getHeight() - 1; j >= 0; j--) {
				imageColor = new Color(image.getRGB(i, j));
				if(imageColor.getRed() > THRESHOLD || imageColor.getRed() > THRESHOLD || imageColor.getRed() > THRESHOLD) {
					convertedImage.setRGB(i, j, Color.RED.getRGB());
					if(j > rightY)
						rightY = j;
					break;
				}
			}
		}

		System.out.println("X-axis: " + leftX + ":" + rightX);
		System.out.println("Y-axis: " + leftY + ":" + rightY);
		System.out.println();

		return convertedImage;
	}

	private BufferedImage convertToRGB(BufferedImage image) {
		BufferedImage convertedImage = new BufferedImage(image.getWidth(), image.getHeight(), BufferedImage.TYPE_INT_RGB);
		convertedImage.getGraphics().drawImage(image, 0, 0, null);
		return convertedImage;
	}
}
