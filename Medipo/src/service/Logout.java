package service;

import org.apache.commons.io.FileUtils;
import utils.AlertManager;
import utils.FileManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/Logout")
public class Logout extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		HttpSession session = request.getSession();

		session.removeAttribute("firstname");
		session.removeAttribute("email");

		response.setHeader("Cache-Control","no-store");
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);

		String sessionID = session.getId();
		String userDirectoryPath = FileManager.getDirPath_User("guest@" + sessionID);
		FileUtils.deleteDirectory(new File(userDirectoryPath));

		session.invalidate();

		AlertManager.alert(out, request, response, "Success", "Logout Successful!", "success", "welcome.jsp");
	}
}
