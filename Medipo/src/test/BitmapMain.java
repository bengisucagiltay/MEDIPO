package test;

import managers.ImageManager;
import gui.TestFrame;
import utils.MyTimer;

public class BitmapMain {

	private static MyTimer timer;

	public static void main(String args[]) {
		timer = new MyTimer();

		ImageManager imageManager = new ImageManager();

		timer.start();
		imageManager.createImages(1, 176);
		imageManager.segmentImages();
		timer.end();
		System.out.println("Scan Images: " + timer.getTotalTime());

		timer.start();
		TestFrame tf = new TestFrame(imageManager.getImages());
		timer.end();
		System.out.println("GUI: " + timer.getTotalTime());

	}
}
