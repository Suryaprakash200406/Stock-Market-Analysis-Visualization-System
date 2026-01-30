package mypackage;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;

import com.project.util.DBConnection;

@WebServlet("/MyServlet")
public class MyServlet extends HttpServlet {

    // Override doPost to handle form submission
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get values from HTML form
        String name = request.getParameter("username");
        String regno = request.getParameter("regno");
        String department = request.getParameter("department");
        String college = request.getParameter("college");

        try {
            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO test_table (regno, name, department, college) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, regno);
            ps.setString(2, name);
            ps.setString(3, department);
            ps.setString(4, college);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                request.setAttribute("message", "Record inserted successfully!");
            } else {
                request.setAttribute("message", "Failed to insert record.");
            }

            // Forward to JSP for response
            RequestDispatcher rd = request.getRequestDispatcher("sample.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("sample.jsp");
            rd.forward(request, response);
        }
    }

    // Optional: override doGet if you want GET requests to work too
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // You can forward GET requests to the same JSP or show a message
        response.getWriter().println("Please submit the form to insert data.");
    }
}
