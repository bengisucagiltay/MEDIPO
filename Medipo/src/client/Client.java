package client;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;

import javax.imageio.ImageIO;

public class Client {
	private int port;
	private String address;

	private Socket clientSocket;
	private DataInputStream is;
	private DataOutputStream os;

	public Client(String address, int port) {
		this.port = port;
		this.address = address;
	}

	public void connect() {
		try {
			clientSocket = new Socket(address, port);
			is = new DataInputStream(clientSocket.getInputStream());
			os = new DataOutputStream(clientSocket.getOutputStream());
		}
		catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void sendImage(BufferedImage image) {
		ByteArrayOutputStream toByte = new ByteArrayOutputStream();
		byte[] out;

		try {
			ImageIO.write(image, "bmp", toByte);
			out = toByte.toByteArray();
			os.writeInt(out.length);
			os.write(out);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
