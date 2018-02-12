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

	public void receiveImages() {

		File theDir = null;
		try {
			theDir = new File("./Medipo/resource/server_data/" +dataInputStream.readInt());
		} catch (IOException e) {
			e.printStackTrace();
		}

		if (!theDir.exists()) {
			boolean result = false;

			try{
				theDir.mkdir();
				result = true;
			}
			catch(SecurityException se){
				//handle it
			}
		}

		try {
			int count = 1;
			int length = dataInputStream.readInt();
			if(length > 0) {
				byte[] byteArray = new byte[length];
				dataInputStream.read(byteArray, 0, length);
				InputStream inputStream = new ByteArrayInputStream(byteArray);
				BufferedImage bufferedImage = ImageIO.read(inputStream);
				ImageIO.write(bufferedImage, "bmp", new File(theDir + "/" + count + ".bmp"));
				length = dataInputStream.readInt();
				count++;
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
