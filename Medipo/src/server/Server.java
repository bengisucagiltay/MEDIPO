package server;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;

public class Server {

	private Socket clientSocket;
	private ServerSocket serverSocket;
	private DataInputStream is;
	private DataOutputStream os;

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
			is = new DataInputStream(clientSocket.getInputStream());
			os = new DataOutputStream(clientSocket.getOutputStream());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void recieveImage() {

		try {
			int length = is.readInt();
			if(length > 0) {
				byte[] byteImage = new byte[length];
				is.readFully(byteImage);
				InputStream in = new ByteArrayInputStream(byteImage);
				BufferedImage bImageFromConvert = ImageIO.read(in);
				ImageIO.write(bImageFromConvert, "bmp", new File("./resource/server_data/test.bmp"));
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
