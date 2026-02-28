package com.project.servlet;

import com.project.model.StockData;
import com.project.service.StockAnalyzerService;
import com.project.util.CompanyRegistry;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

public class SectorGrowthServlet extends HttpServlet {

    private final StockAnalyzerService analyzer = new StockAnalyzerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String sector = request.getParameter("sector");
        String range = request.getParameter("range"); // dynamic selector

        if (sector == null || sector.trim().isEmpty()) {
            response.sendRedirect("sectorDashboard.jsp");
            return;
        }

        if (range == null) range = "1M";

        int days;
        switch (range) {
            case "6M": days = 126; break;
            case "1Y": days = 252; break;
            case "5Y": days = 1260; break;
            default: days = 21; range = "1M";
        }

        List<String> symbols = new ArrayList<>();

        CompanyRegistry.getCompanyMap().forEach((symbol, info) -> {
            if (info.sector.equalsIgnoreCase(sector)) {
                symbols.add(symbol);
            }
        });

        List<Double> r1MList = new ArrayList<>();
        List<Double> r6MList = new ArrayList<>();
        List<Double> r1YList = new ArrayList<>();
        List<Double> r5YList = new ArrayList<>();

        List<Double> selectedRangeList = new ArrayList<>();

        String bestStock = null;
        String worstStock = null;
        Double bestReturn = null;
        Double worstReturn = null;

        for (String symbol : symbols) {
            try {
                StockData data = analyzer.loadStockData(symbol);
                List<Double> closes = data.getClose();
                if (closes.size() < 2) continue;

                double r1M = analyzer.getMomentum(closes, 21);
                double r6M = analyzer.getMomentum(closes, 126);
                double r1Y = analyzer.getMomentum(closes, 252);
                double r5Y = analyzer.getMomentum(closes, 1260);

                r1MList.add(r1M);
                r6MList.add(r6M);
                r1YList.add(r1Y);
                r5YList.add(r5Y);

                double selectedReturn = analyzer.getMomentum(closes, days);
                selectedRangeList.add(selectedReturn);

                if (bestReturn == null || selectedReturn > bestReturn) {
                    bestReturn = selectedReturn;
                    bestStock = symbol;
                }

                if (worstReturn == null || selectedReturn < worstReturn) {
                    worstReturn = selectedReturn;
                    worstStock = symbol;
                }

            } catch (Exception e) {
                System.err.println("Error processing " + symbol + ": " + e.getMessage());
            }
        }

        // --- Existing attributes ---
        request.setAttribute("sector", sector);
        request.setAttribute("selectedRange", range);

        request.setAttribute("avg1M", average(r1MList));
        request.setAttribute("avg6M", average(r6MList));
        request.setAttribute("avg1Y", average(r1YList));
        request.setAttribute("avg5Y", average(r5YList));

        request.setAttribute("bestStock", bestStock);
        request.setAttribute("bestReturn", bestReturn);
        request.setAttribute("worstStock", worstStock);
        request.setAttribute("worstReturn", worstReturn);

        double positivePercent = percentagePositive(selectedRangeList);
        request.setAttribute("positivePercent", positivePercent);
        request.setAttribute("negativePercent", 100 - positivePercent);

        // --- NEW: Company counts for selected range ---
        int totalCompanies = selectedRangeList.size();

        long positiveCount = selectedRangeList.stream()
                .filter(d -> d > 0)
                .count();

        long negativeCount = selectedRangeList.stream()
                .filter(d -> d <= 0)
                .count();

        request.setAttribute("totalCompanies", totalCompanies);
        request.setAttribute("positiveCount", (int) positiveCount);
        request.setAttribute("negativeCount", (int) negativeCount);

        request.getRequestDispatcher("sectorGrowth.jsp").forward(request, response);
    }

    private Double average(List<Double> list) {
        if (list.isEmpty()) return null;
        return list.stream().mapToDouble(Double::doubleValue).average().orElse(0);
    }

    private double percentagePositive(List<Double> list) {
        if (list.isEmpty()) return 0;
        long count = list.stream().filter(d -> d > 0).count();
        return (count * 100.0) / list.size();
    }
}