package com.project.servlet;

import com.project.model.StockSummaryResult;
import com.project.service.StockAnalyzerService;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class StockSummaryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String symbol = request.getParameter("symbol");

        if (symbol == null || symbol.isEmpty()) {
            response.sendRedirect("companyDashboard.jsp");
            return;
        }

        try {
            StockAnalyzerService analyzer = new StockAnalyzerService();

            StockSummaryResult result = analyzer.analyzeStockSummary(symbol);

            request.setAttribute("symbol", symbol);
            request.setAttribute("summary", result);

            request.getRequestDispatcher("stock_summary.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
