package test;

import bitmap.ImageEditor;
import gui.TestFrame;
import utils.MyTimer;

public class BitmapMain {

	private static MyTimer timer;

	public static void main(String args[]) {
		timer = new MyTimer();

		ImageEditor ie = new ImageEditor();

		timer.start();
		ie.createImages(1, 176);
		timer.end();
		System.out.println("Scan Images: " + timer.getTotalTime());

		timer.start();
		TestFrame tf = new TestFrame(ie.getImages());
		timer.end();
		System.out.println("GUI: " + timer.getTotalTime());

	}
}
