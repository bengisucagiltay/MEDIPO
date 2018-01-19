package test;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;

import client.Client;

public class ClientMain {
	
	public static void main(String args[]) {
		Client c = new Client("localhost", 6789);
		c.connect();
		BufferedImage image;
		try {
			image = ImageIO.read(new File("./resource/test1.bmp"));
			c.sendImage(image);
			image = ImageIO.read(new File("./resource/test2.bmp"));
			c.sendImage(image);

		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
