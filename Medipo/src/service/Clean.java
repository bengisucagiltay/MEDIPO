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

@WebServlet("/Clean")
public class Clean extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		PrintWriter out = response.getWriter();
		HttpSession session = request.getSession();
		out.println("test");
		deleteImages(request);

		response.sendRedirect("welcome.jsp");

	}

	public static void deleteImages(HttpServletRequest request){
		String email = (String) request.getSession().getAttribute("email");
		String userDirectoryPath = FileManager.getDirPath_UserUpload(email);

		try {
			FileUtils.cleanDirectory(new File(userDirectoryPath));
		} catch (IOException e) {
			e.printStackTrace();
		}

	}


	public static void deleteGuest(){


	}
	}
