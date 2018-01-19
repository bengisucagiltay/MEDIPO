package server;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.ServerSocket;
import java.net.Socket;

import javax.imageio.ImageIO;

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
				is.readFully(byteImage);;
				InputStream in = new ByteArrayInputStream(byteImage);
				BufferedImage bImageFromConvert = ImageIO.read(in);
				ImageIO.write(bImageFromConvert, "bmp", new File("./resource/server_data/testImage.bmp"));
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
