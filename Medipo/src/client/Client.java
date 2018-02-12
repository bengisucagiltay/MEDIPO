package client;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.Socket;
import java.util.ArrayList;

public class Client {

	private String name;
	private Socket socket;
	private DataInputStream dataInputStream;
	private DataOutputStream dataOutputStream;
	private ArrayList<BufferedImage> images;

	public Client() {
		socket = null;
		dataInputStream = null;
		dataOutputStream = null;

		images = new ArrayList<>();
	}

	public void connect(String address, int port, String name) {
		this.name = name;
		try {
			socket = new Socket(address, port);
			dataInputStream = new DataInputStream(socket.getInputStream());
			dataOutputStream = new DataOutputStream(socket.getOutputStream());
		}
		catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void sendImages() {

		ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
		byte[] byteArray;

		try {
			dataOutputStream.writeInt(Integer.parseInt(name));
		} catch (IOException e) {
			e.printStackTrace();
		}

		for(int i = 0; i < images.size(); i++) {
			try {
				ImageIO.write(images.get(i), "bmp", byteArrayOutputStream);
				byteArray = byteArrayOutputStream.toByteArray();
				dataOutputStream.writeInt(byteArray.length);
				dataOutputStream.write(byteArray);
			} catch (IOException e) {
				e.printStackTrace();
				System.out.println(i);
			}
		}
	}

	public void fillImages(){
		//for(int i = 1; i < 176; i++){
			try {

				images.add(ImageIO.read(new File("./Medipo/resource/ba/im" + 1 + ".bmp")));
			} catch (IOException e) {
				e.printStackTrace();
			}
		//}
	}
}
