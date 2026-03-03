package com.project.servlet;

import com.project.model.StockData;
import com.project.service.StockAnalyzerService;
import com.project.util.CompanyRegistry;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

public class SectorRiskServlet extends HttpServlet {

    private final StockAnalyzerService analyzer = new StockAnalyzerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String sector = request.getParameter("sector");
        String range = request.getParameter("range");

        if (sector == null || sector.trim().isEmpty()) {
            response.sendRedirect("sectorDashboard.jsp");
            return;
        }

        if (range == null) range = "1Y";

        int days;
        switch (range) {
            case "6M": days = 126; break;
            case "5Y": days = 1260; break;
            case "1M": days = 21; break;
            default: days = 252; range = "1Y";
        }

        List<String> symbols = CompanyRegistry.getSymbolsBySector(sector);

        // ==============================
        // 1️⃣ FIXED 1Y SUMMARY SECTION
        // ==============================
        List<Double> oneYearVolList = new ArrayList<>();
        List<Double> oneYearDDList = new ArrayList<>();

        // ==============================
        // 2️⃣ DYNAMIC RANGE SECTION
        // ==============================
        List<Double> companyVolList = new ArrayList<>();
        List<Double> companyDDList = new ArrayList<>();
        List<String> validSymbols = new ArrayList<>();

        // For sector average drawdown trend
        List<List<Double>> allDrawdownSeries = new ArrayList<>();
        List<String> commonDates = null;

        for (String symbol : symbols) {

            try {
                StockData data = analyzer.loadStockData(symbol);
                List<Double> closes = data.getClose();
                List<String> dates = data.getDates();

                if (closes.size() < 252) continue;

                // ---------- 1Y FIXED SUMMARY ----------
                List<Double> last1Y = closes.subList(closes.size() - 252, closes.size());
                oneYearVolList.add(analyzer.getVolatility(last1Y));
                oneYearDDList.add(analyzer.getMaxDrawdown(last1Y));

                // ---------- DYNAMIC RANGE ----------
                if (closes.size() < days) continue;

                List<Double> recentCloses =
                        closes.subList(closes.size() - days, closes.size());

                List<String> recentDates =
                        dates.subList(dates.size() - days, dates.size());

                double vol = analyzer.getVolatility(recentCloses);
                double dd = analyzer.getMaxDrawdown(recentCloses);

                companyVolList.add(vol);
                companyDDList.add(dd);
                validSymbols.add(symbol);

                // Drawdown series for chart
                List<Double> drawdownSeries =
                        analyzer.getDrawdownList(recentCloses);

                allDrawdownSeries.add(drawdownSeries);

                if (commonDates == null) {
                    commonDates = new ArrayList<>(recentDates);
                }

            } catch (Exception e) {
                System.err.println("Error processing " + symbol);
            }
        }

        // ==============================
        // Sector Average Drawdown Trend
        // ==============================
        List<Double> sectorAvgDrawdown = new ArrayList<>();

        if (!allDrawdownSeries.isEmpty()) {

            int length = allDrawdownSeries.get(0).size();

            for (int i = 0; i < length; i++) {
                double sum = 0;
                int count = 0;

                for (List<Double> series : allDrawdownSeries) {
                    if (i < series.size()) {
                        sum += series.get(i);
                        count++;
                    }
                }

                sectorAvgDrawdown.add(count > 0 ? sum / count : 0);
            }
        }

        // ==============================
        // FINAL CALCULATIONS
        // ==============================

        Double avgVolatility1Y = average(oneYearVolList);
        Double avgDrawdown1Y = average(oneYearDDList);

        String stabilityLevel;
        if (avgVolatility1Y == null) {
            stabilityLevel = "No Data";
        } else if (avgVolatility1Y < 15) {
            stabilityLevel = "High Stability";
        } else if (avgVolatility1Y < 25) {
            stabilityLevel = "Moderate Stability";
        } else {
            stabilityLevel = "Low Stability (High Risk)";
        }

        // ==============================
        // SEND TO JSP
        // ==============================

        request.setAttribute("sector", sector);
        request.setAttribute("selectedRange", range);

        request.setAttribute("avgVolatility1Y", avgVolatility1Y);
        request.setAttribute("avgDrawdown1Y", avgDrawdown1Y);
        request.setAttribute("stabilityLevel", stabilityLevel);

        request.setAttribute("companyVolList", companyVolList);
        request.setAttribute("companyDDList", companyDDList);
        request.setAttribute("symbols", validSymbols);

        request.setAttribute("sectorAvgDrawdown", sectorAvgDrawdown);
        request.setAttribute("drawdownDates", commonDates);

        request.setAttribute("totalCompanies", oneYearVolList.size());

        request.getRequestDispatcher("sectorRisk.jsp")
                .forward(request, response);
    }

    private Double average(List<Double> list) {
        if (list.isEmpty()) return null;
        return list.stream()
                .mapToDouble(Double::doubleValue)
                .average()
                .orElse(0);
    }
}