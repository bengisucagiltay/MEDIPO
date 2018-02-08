package server;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;

public class Server {

	private Socket clientSocket;
	private ServerSocket serverSocket;
	private DataInputStream inputStream;
	private DataOutputStream outputStream;

	public Server(int port) {
		try {
			serverSocket = new ServerSocket(port);
		}
		catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void acceptConnection() {
		try {
			clientSocket = serverSocket.accept();
			inputStream = new DataInputStream(clientSocket.getInputStream());
			outputStream = new DataOutputStream(clientSocket.getOutputStream());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void receiveImage() {
		try {
			int length = inputStream.readInt();
			if(length > 0) {
				byte[] byteImage = new byte[length];
				inputStream.readFully(byteImage);
				InputStream in = new ByteArrayInputStream(byteImage);
				BufferedImage bImageFromConvert = ImageIO.read(in);
				ImageIO.write(bImageFromConvert, "bmp", new File("./resource/server_data/test.bmp"));
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
