package test;

import client.Client;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

public class ClientMain {
	
	public static void main(String args[]) {
		Client c = new Client();
		c.connect("localhost", 6789);
		BufferedImage image;
		try {
			image = ImageIO.read(new File("./resource/ba/im1.bmp"));
			c.sendImage(image);
			image = ImageIO.read(new File("./resource/ba/im100.bmp"));
			c.sendImage(image);

		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
