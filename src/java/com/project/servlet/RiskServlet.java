package com.project.servlet;

import com.project.model.StockData;
import com.project.service.StockAnalyzerService;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class RiskServlet extends HttpServlet {

    private final StockAnalyzerService analyzer = new StockAnalyzerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String symbol = request.getParameter("symbol");
        String range = request.getParameter("range");
        if (symbol == null || symbol.isEmpty()) {
            response.sendRedirect("companyDashboard.jsp");
            return;
        }
        if (range == null || range.isEmpty()) range = "1Y";

        try {
            StockData fullData = analyzer.loadStockData(symbol);

            // -------- 1️⃣ Fixed 1-Year summary --------
            StockData last1YearData = analyzer.filterByRange(fullData, "1Y");
            List<Double> closes1Y = last1YearData.getClose();

            double volatility = analyzer.getVolatility(closes1Y);
            double maxDrawdown = analyzer.getMaxDrawdown(closes1Y);
            double high1Y = closes1Y.stream().mapToDouble(d -> d).max().orElse(0);
            double low1Y = closes1Y.stream().mapToDouble(d -> d).min().orElse(0);

            // -------- 2️⃣ Chart data based on selected range --------
            StockData chartData = analyzer.filterByRange(fullData, range);
            List<Double> chartCloses = chartData.getClose();
            List<String> chartDates = chartData.getDates();
            List<Double> drawdownList = analyzer.getDrawdownList(chartCloses);

            // -------- Send attributes --------
            request.setAttribute("symbol", symbol);
            request.setAttribute("range", range);

            // Summary (always 1Y)
            request.setAttribute("volatility", volatility);
            request.setAttribute("maxDrawdown", maxDrawdown);
            request.setAttribute("high1Y", high1Y);
            request.setAttribute("low1Y", low1Y);

            // Chart
            request.setAttribute("labels", chartDates);
            request.setAttribute("drawdownList", drawdownList);

            request.getRequestDispatcher("risk.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
