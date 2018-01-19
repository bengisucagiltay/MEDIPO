package test;

import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;

import bitmap.BitmapEditor;

public class BitmapMain {

	public static void main(String args[]) {
				
		BitmapEditor be = new BitmapEditor();
		BufferedImage image = null;
		BufferedImage outputImage = null;

		
		
		JFrame frame = new JFrame();
		frame.getContentPane().setLayout(new GridLayout(2, 2));
		
		for(int i = 100; i < 104; i++) {
			
			try {
				image = ImageIO.read(new File("./resource/ba/im" + i + ".bmp"));
				outputImage = be.createBoundImage(image);
				frame.getContentPane().add(new JLabel(new ImageIcon(outputImage)));
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		frame.pack();
		frame.setVisible(true);
		
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	}
}
