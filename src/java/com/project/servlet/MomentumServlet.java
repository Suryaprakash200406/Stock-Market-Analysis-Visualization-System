package com.project.servlet;

import com.project.model.StockData;
import com.project.service.StockAnalyzerService;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class MomentumServlet extends HttpServlet {

    private final StockAnalyzerService analyzer = new StockAnalyzerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String symbol = request.getParameter("symbol");
        if (symbol == null || symbol.isEmpty()) {
            response.sendRedirect("companyDashboard.jsp");
            return;
        }

        try {
            StockData fullData = analyzer.loadStockData(symbol);
            // 6 months period for RSI chart
            StockData filteredData = analyzer.filterByRange(fullData, "6M");

            List<Double> closes = filteredData.getClose();
            if (closes.size() < 15) { // minimum for RSI 14
                request.setAttribute("error", "Not enough data for momentum analysis.");
                request.getRequestDispatcher("momentum.jsp").forward(request, response);
                return;
            }

            double momentum10 = analyzer.getMomentum(closes, 10);
            double momentum20 = analyzer.getMomentum(closes, 20);
            double rsi = analyzer.getRSI(closes, 14);
            String rsiSignal = analyzer.getRSISignal(rsi);

            // RSI chart for last 6 months (already filtered)
            List<Double> rsiValues = new ArrayList<>();
            List<String> chartDates = filteredData.getDates();

            int period = 14;
            List<Double> closeList = filteredData.getClose();
            for (int i = period; i < closeList.size(); i++) {
                List<Double> temp = closeList.subList(i - period, i + 1);
                rsiValues.add(analyzer.getRSI(temp, period));
            }
            // adjust dates list to match RSI values
            chartDates = chartDates.subList(period, chartDates.size());

            request.setAttribute("symbol", symbol);
            request.setAttribute("momentum10", momentum10);
            request.setAttribute("momentum20", momentum20);
            request.setAttribute("rsi", rsi);
            request.setAttribute("rsiSignal", rsiSignal);
            request.setAttribute("rsiValues", rsiValues);
            request.setAttribute("chartDates", chartDates);

            request.getRequestDispatcher("momentum.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
