package mypackage;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.project.util.DBConnection;

@WebServlet("/RetServlet")
public class RetServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<String[]> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT regno, name, department, college FROM test_table";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String regno = rs.getString("regno");
                String name = rs.getString("name");
                String department = rs.getString("department");
                String college = rs.getString("college");

                // Store each row as an array (NO model class)
                String row[] = { regno, name, department, college };
                list.add(row);
            }

            // Send data to JSP
            request.setAttribute("data", list);
            RequestDispatcher rd = request.getRequestDispatcher("Retjsp.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
