package utils;

import bitmap.EditableImage;
import segment.Segmenter;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

public class ImageManager {

	private Segmenter segmenter;
	private ArrayList<EditableImage> images;

	public ImageManager(){
		segmenter = new Segmenter();
		images = new ArrayList<>();
	}

	public void readImages(int start, int end){

		for(int i = 1; i <= end; i++) {
			try {
				BufferedImage image = ImageIO.read(new File("./Medipo/web/resources/"));
				images.add(new EditableImage(image));
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public void segmentImages(){
		for(int i = 0; i < images.size(); i++) {
			segmenter.scanImage(images.get(i));
		}
	}

	public ArrayList<EditableImage> getImages() {
		return images;
	}
}
