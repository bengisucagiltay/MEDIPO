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

	public void createImages(int start, int end){

		for(int i = start; i <= end; i++) {
			try {
				//TODO: PATH DEĞİŞMELİ - FileManager'dan alınmalı
				BufferedImage image = ImageIO.read(new File("./Medipo/web/resources/"));
				images.add(new EditableImage(image));
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public void segmentImages(){
		for(int i = 0; i < images.size(); i++) {
			segmenter.calculateThreshold(images.get(i));
			segmenter.scanImage(images.get(i));
		}
	}

	public ArrayList<EditableImage> getImages() {
		return images;
	}
}
