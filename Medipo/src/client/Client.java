package client;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.Socket;
import java.util.ArrayList;

public class Client {

	private Socket socket;
	private DataInputStream inputStream;
	private DataOutputStream outputStream;

	private ArrayList<BufferedImage> images;

	public Client() {
		socket = null;
		inputStream = null;
		outputStream = null;

		images = new ArrayList<>();
		fillImages();
	}

	public void connect(String address, int port) {
		try {
			socket = new Socket(address, port);
			inputStream = new DataInputStream(socket.getInputStream());
			outputStream = new DataOutputStream(socket.getOutputStream());
		}
		catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void sendImage(BufferedImage image) {
		ByteArrayOutputStream byteArray = new ByteArrayOutputStream();
		byte[] output;

		try {
			ImageIO.write(image, "bmp", byteArray);
			output = byteArray.toByteArray();
			outputStream.writeInt(output.length);
			outputStream.write(output);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void fillImages(){
		for(int i = 0; i < 177; i++){
			try {
				images.add(ImageIO.read(new File("./resource/ba/im1.bmp")));
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
}
