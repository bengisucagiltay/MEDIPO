package utils;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class AlertManager {

    public static void alert(PrintWriter out, HttpServletRequest request, HttpServletResponse response, String alert, String message, String type, String dispatch) throws ServletException, IOException {
        out.println("<script src='js/sweetalert2.all.js'></script>");
        out.println("<script src='js/jquery.min.js'></script>");
        out.println("<script>");
        out.println("$(document).ready(function(){");
        out.println("swal ( '" + alert + "' ,  '" + message + "' ,  '" + type + "' )");
        out.println("});");
        out.println("</script>");

        RequestDispatcher rd = request.getRequestDispatcher(dispatch);
        rd.include(request, response);
    }
}
