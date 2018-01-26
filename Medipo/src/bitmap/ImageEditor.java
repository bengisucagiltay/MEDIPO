package bitmap;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

public class ImageEditor {

	private ArrayList<EditableImage> images;

	public ImageEditor(){
		images = new ArrayList<>();
	}

	public void createImages(int start, int end){

		for(int i = start; i <= end; i++) {
			try {
				BufferedImage image = ImageIO.read(new File("./Medipo/resource/ba/im" + i + ".bmp"));
				images.add(new EditableImage(image));
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public ArrayList<EditableImage> getImages() {
		return images;
	}
}
