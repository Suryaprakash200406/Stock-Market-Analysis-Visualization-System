package com.project.servlet;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

import com.project.model.StockData;
import com.project.service.StockAnalyzerService;
import com.project.util.CompanyRegistry;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class SectorParticipationServlet extends HttpServlet {

    private final StockAnalyzerService analyzer =
            new StockAnalyzerService();

    private static final DateTimeFormatter FORMATTER =
            DateTimeFormatter.ofPattern("dd-MMM-yyyy", Locale.ENGLISH);

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String sector = request.getParameter("sector");

        if (sector == null || sector.trim().isEmpty()) {
            response.sendRedirect("sectorDashboard.jsp");
            return;
        }

        List<String> symbols =
                CompanyRegistry.getSymbolsBySector(sector);

        Map<String, StockData> stockDataMap = new HashMap<>();
        LocalDate latestCommonDate = null;

        // -------- LOAD DATA & FIND COMMON DATE --------
        for (String symbol : symbols) {
            try {
                StockData data = analyzer.loadStockData(symbol);
                if (data.getDates().isEmpty()) continue;

                stockDataMap.put(symbol, data);

                LocalDate lastDate =
                        LocalDate.parse(
                                data.getDates()
                                        .get(data.getDates().size() - 1),
                                FORMATTER
                        );

                if (latestCommonDate == null ||
                        lastDate.isBefore(latestCommonDate)) {
                    latestCommonDate = lastDate;
                }

            } catch (Exception e) {
                System.err.println("Error loading "
                        + symbol + ": " + e.getMessage());
            }
        }

        if (latestCommonDate == null) {
            response.sendRedirect("sectorDashboard.jsp");
            return;
        }

        // -------- FIND LAST 10 TRADING DAYS --------
        List<String> historyDates = new ArrayList<>();
        List<Double> participationHistory = new ArrayList<>();

        StockData referenceData =
                stockDataMap.values().iterator().next();

        List<String> refDates = referenceData.getDates();

        int refIndex = -1;

        for (int i = 0; i < refDates.size(); i++) {
            if (LocalDate.parse(refDates.get(i), FORMATTER)
                    .equals(latestCommonDate)) {
                refIndex = i;
                break;
            }
        }

        int startIndex = Math.max(19, refIndex - 9);

        for (int i = startIndex; i <= refIndex; i++) {

            LocalDate currentDate =
                    LocalDate.parse(refDates.get(i), FORMATTER);

            int totalCompanies = 0;
            int aboveCount = 0;

            for (StockData data : stockDataMap.values()) {

                List<String> dates = data.getDates();
                List<Double> closes = data.getClose();

                int index = -1;

                for (int j = 0; j < dates.size(); j++) {
                    if (LocalDate.parse(dates.get(j), FORMATTER)
                            .equals(currentDate)) {
                        index = j;
                        break;
                    }
                }

                if (index < 19) continue;

                double sum = 0;
                for (int k = index - 19; k <= index; k++) {
                    sum += closes.get(k);
                }

                double ma20 = sum / 20;
                double closePrice = closes.get(index);

                totalCompanies++;

                if (closePrice > ma20) {
                    aboveCount++;
                }
            }

            if (totalCompanies > 0) {
                double percent =
                        (aboveCount * 100.0) / totalCompanies;

                participationHistory.add(
                        Math.round(percent * 100.0) / 100.0);

                // ✅ FIXED DATE FORMAT HERE
                historyDates.add(
                        currentDate.format(FORMATTER)
                );
            }
        }

        double latestPercent =
                participationHistory.get(participationHistory.size() - 1);

        int aboveLatest = 0;
        int totalLatest = 0;

        for (StockData data : stockDataMap.values()) {

            List<String> dates = data.getDates();
            List<Double> closes = data.getClose();

            int index = -1;

            for (int j = 0; j < dates.size(); j++) {
                if (LocalDate.parse(dates.get(j), FORMATTER)
                        .equals(latestCommonDate)) {
                    index = j;
                    break;
                }
            }

            if (index < 19) continue;

            double sum = 0;
            for (int k = index - 19; k <= index; k++) {
                sum += closes.get(k);
            }

            double ma20 = sum / 20;
            double closePrice = closes.get(index);

            totalLatest++;

            if (closePrice > ma20) {
                aboveLatest++;
            }
        }

        int belowLatest = totalLatest - aboveLatest;

        String status;

        if (latestPercent >= 70) {
            status = "Strong Participation";
        } else if (latestPercent >= 40) {
            status = "Moderate Participation";
        } else {
            status = "Weak Participation";
        }

        request.setAttribute("sector", sector);
        request.setAttribute("totalCompanies", totalLatest);
        request.setAttribute("aboveCount", aboveLatest);
        request.setAttribute("belowCount", belowLatest);
        request.setAttribute("participationPercent",
                Math.round(latestPercent));
        request.setAttribute("status", status);

        // ✅ FIXED aligned date format
        request.setAttribute("alignedDate",
                latestCommonDate.format(FORMATTER));

        request.setAttribute("historyDates", historyDates);
        request.setAttribute("participationHistory",
                participationHistory);

        request.getRequestDispatcher(
                "sectorParticipation.jsp")
                .forward(request, response);
    }
}