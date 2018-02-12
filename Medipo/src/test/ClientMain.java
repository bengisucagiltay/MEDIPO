package test;

import client.Client;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

public class ClientMain {
	
	public static void main(String args[]) {
		Client c = new Client("test2");
		c.connect("localhost", 6789);
		c.sendInformation();
		c.fillImages();
		c.sendImages();
	}
}
