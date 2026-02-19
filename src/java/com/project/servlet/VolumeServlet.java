package com.project.servlet;

import com.project.model.StockData;
import com.project.service.StockAnalyzerService;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class VolumeServlet extends HttpServlet {

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
        if (range == null || range.isEmpty()) range = "1M";

        try {
            StockData fullData = analyzer.loadStockData(symbol);
            StockData filteredData = analyzer.filterByRange(fullData, range);

            List<Long> volumes = filteredData.getVolume();
            List<Double> volumeMA = analyzer.getVolumeMA(volumes, 20);

            request.setAttribute("symbol", symbol);
            request.setAttribute("range", range);
            request.setAttribute("dates", filteredData.getDates());
            request.setAttribute("volumes", volumes);
            request.setAttribute("volumeMA", volumeMA);

            request.setAttribute("latestVolume", analyzer.getLatestVolume(volumes));
            request.setAttribute("volumeChangePercent", analyzer.getVolumeChangePercent(volumes));
            request.setAttribute("highestVolume", analyzer.getHighestVolume(volumes));
            request.setAttribute("averageVolume", analyzer.getAverageVolume(volumes));

            request.getRequestDispatcher("volume.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
