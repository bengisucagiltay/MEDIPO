package server;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;

public class Server {

	private Socket socket;
	private ServerSocket serverSocket;
	private DataInputStream dataInputStream;
	private DataOutputStream dataOutputStream;

	private String clientName;
	private String directoryName;

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
			socket = serverSocket.accept();
			dataInputStream = new DataInputStream(socket.getInputStream());
			dataOutputStream = new DataOutputStream(socket.getOutputStream());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void receiveInformation(){
		try {
			clientName = dataInputStream.readUTF();
			directoryName = "./Medipo/resource/server_data/" + clientName;
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void checkDirectory() {
		File directory = new File(directoryName);
		if (!directory.exists())
            directory.mkdir();
	}

	public void receiveImages() {
		try {
			int count = 1;
			int length = dataInputStream.readInt();
			while(length > 0) {
				byte[] byteArray = new byte[length];
				dataInputStream.readFully(byteArray, 0, length);
				InputStream inputStream = new ByteArrayInputStream(byteArray);
				BufferedImage bufferedImage = ImageIO.read(inputStream);
				ImageIO.write(bufferedImage, "bmp", new File(directoryName + "/" + count + ".bmp"));
				length = dataInputStream.readInt();
				count++;
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
