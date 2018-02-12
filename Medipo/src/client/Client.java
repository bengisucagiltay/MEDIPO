package client;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.Socket;
import java.util.ArrayList;

public class Client {

	private Socket socket;
	private DataInputStream dataInputStream;
	private DataOutputStream dataOutputStream;

	private String name;
	private ArrayList<BufferedImage> images;

	public Client(String name) {
		this.name = name;
	}

	public void connect(String address, int port) {
		try {
			socket = new Socket(address, port);
			dataInputStream = new DataInputStream(socket.getInputStream());
			dataOutputStream = new DataOutputStream(socket.getOutputStream());
		}
		catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void sendInformation() {
		try {
			dataOutputStream.writeUTF(name);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void sendImages() {
		for(int i = 0; i < images.size(); i++) {
			try {
				ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
				ImageIO.write(images.get(i), "bmp", byteArrayOutputStream);
				byte[] byteArray = byteArrayOutputStream.toByteArray();
				dataOutputStream.writeInt(byteArray.length);
				dataOutputStream.write(byteArray);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public void fillImages(){

		images = new ArrayList<>();
		File directory = new File("./Medipo/resource/ba");

		for(File f: directory.listFiles()){
			try {
				images.add(ImageIO.read(f));
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
}
