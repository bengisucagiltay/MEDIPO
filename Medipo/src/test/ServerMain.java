package test;

import server.Server;

public class ServerMain {
	
	public static void main(String args[]) {
		Server s = new Server(6789);
		s.acceptConnection();
		s.recieveImage();

	}
}
