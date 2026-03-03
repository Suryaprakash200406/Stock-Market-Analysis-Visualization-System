package com.project.servlet;

import com.project.service.StockAnalyzerService;
import com.project.util.CompanyRegistry;
import com.project.model.StockData;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

public class SectorPriceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String sector = request.getParameter("sector");
        if (sector == null || sector.trim().isEmpty()) {
            response.sendRedirect("sectorDashboard.jsp");
            return;
        }

        StockAnalyzerService analyzer = new StockAnalyzerService();
        List<String> companies = CompanyRegistry.getSymbolsBySector(sector);

        Map<String, List<Double>> companyCloseMap = new LinkedHashMap<>();

        for (String company : companies) {
            try {

            // Load full stock data
                StockData fullData = analyzer.loadStockData(company);

            // Filter last 1 year
                StockData oneYearData = analyzer.filterByRange(fullData, "1Y");

                List<Double> closes = oneYearData.getClose();

                if (closes != null && !closes.isEmpty()) {
                    companyCloseMap.put(company, closes);
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
    }

        if (companyCloseMap.isEmpty()) {
            request.setAttribute("error", "No data available.");
            request.getRequestDispatcher("sectorPrice.jsp").forward(request, response);
            return;
        }

        int dataSize = companyCloseMap.values().iterator().next().size();
        List<Double> sectorCloseSeries = new ArrayList<>();

        for (int i = 0; i < dataSize; i++) {
            double sum = 0;
            int count = 0;
            for (List<Double> closes : companyCloseMap.values()) {
                if (closes.size() > i) {
                    sum += closes.get(i);
                    count++;
                }
            }
            sectorCloseSeries.add(count > 0 ? sum / count : 0);
        }

        double currentPrice = sectorCloseSeries.get(sectorCloseSeries.size() - 1);
        double ma50 = analyzer.getMovingAverage(sectorCloseSeries, 50);
        double ma200 = analyzer.getMovingAverage(sectorCloseSeries, 200);
        double high52 = analyzer.getMax(sectorCloseSeries);
        double low52 = analyzer.getMin(sectorCloseSeries);

        double distFromHigh = ((currentPrice - high52) / high52) * 100;
        double distFromLow = ((currentPrice - low52) / low52) * 100;

        String structureLabel = "Consolidating";
        String structureClass = "neutral";

        if (currentPrice > ma50 && ma50 > ma200) {
            structureLabel = "Strong Uptrend";
            structureClass = "bullish";
        } else if (currentPrice > ma200 && currentPrice < ma50) {
            structureLabel = "Pullback in Uptrend";
            structureClass = "pullback";
        } else if (currentPrice < ma200) {
            structureLabel = "Downtrend";
            structureClass = "bearish";
        }

        request.setAttribute("sector", sector);
        request.setAttribute("sectorCloseSeries", sectorCloseSeries);
        request.setAttribute("currentPrice", currentPrice);
        request.setAttribute("ma50", ma50);
        request.setAttribute("ma200", ma200);
        request.setAttribute("distFromHigh", distFromHigh);
        request.setAttribute("distFromLow", distFromLow);
        request.setAttribute("structureLabel", structureLabel);
        request.setAttribute("structureClass", structureClass);

        request.getRequestDispatcher("sectorPrice.jsp").forward(request, response);
    }
}