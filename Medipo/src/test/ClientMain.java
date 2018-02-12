package test;

import client.Client;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

public class ClientMain {
	
	public static void main(String args[]) {
		Client c = new Client();
		c.connect("localhost", 6789, "test1");
		c.fillImages();
		c.sendImages();
	}
}
