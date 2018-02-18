package test;

import utils.ImageManager;
import gui.TestFrame;
import utils.MyTimer;

public class BitmapMain {

	public static void main(String args[]) {

		ImageManager imageManager = new ImageManager();

		MyTimer.start();
		imageManager.createImages(1, 176);
		imageManager.segmentImages();
		MyTimer.end();
		System.out.println("Scan Images: " + MyTimer.getTotalTime());

		MyTimer.start();
		TestFrame tf = new TestFrame(imageManager.getImages());
		MyTimer.end();
		System.out.println("GUI: " + MyTimer.getTotalTime());

	}
}
