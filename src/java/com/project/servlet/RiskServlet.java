package com.project.servlet;

import java.io.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class RiskServlet extends HttpServlet {

    private static final DateTimeFormatter CSV_DATE_FORMAT =
            DateTimeFormatter.ofPattern("dd-MMM-yyyy", Locale.ENGLISH);

    private static final String DATA_FOLDER =
            "D:/Actual_Company_Datasets/Clean/";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String symbol = request.getParameter("symbol");
        String range = request.getParameter("range");

        if (symbol == null || symbol.trim().isEmpty()) {
            response.getWriter().println("Symbol missing");
            return;
        }

        if (range == null || range.trim().isEmpty()) {
            range = "1Y";
        }

        File file = new File(DATA_FOLDER + symbol + ".csv");

        if (!file.exists()) {
            response.getWriter().println("CSV not found for " + symbol);
            return;
        }

        List<LocalDate> dates = new ArrayList<>();
        List<Double> closes = new ArrayList<>();

        // ---------- READ CSV ----------
        try (BufferedReader br = new BufferedReader(new FileReader(file))) {

            String line = br.readLine(); // skip header

            while ((line = br.readLine()) != null) {

                if (line.length() < 10) continue;

                line = line.substring(1, line.length() - 1);
                String[] tokens = line.split("\",\"");

                if (tokens.length < 6) continue;

                try {
                    LocalDate date = LocalDate.parse(tokens[0].trim(), CSV_DATE_FORMAT);
                    double close = Double.parseDouble(tokens[4].replace(",", "").trim());

                    dates.add(date);
                    closes.add(close);

                } catch (Exception ignored) {}
            }

        } catch (Exception e) {
            response.getWriter().println("Error reading CSV");
            return;
        }

        if (closes.size() < 252) {
            response.getWriter().println("Not enough data for 1Y risk analysis");
            return;
        }

        LocalDate endDate = dates.get(dates.size() - 1);

        // =====================================================
        // 1️⃣ FIXED 1-YEAR DATASET (FOR SUMMARY SECTION)
        // =====================================================

        LocalDate oneYearStart = endDate.minusYears(1);

        List<Double> oneYearCloses = new ArrayList<>();

        for (int i = 0; i < dates.size(); i++) {
            if (!dates.get(i).isBefore(oneYearStart)) {
                oneYearCloses.add(closes.get(i));
            }
        }

        if (oneYearCloses.size() < 2) {
            response.getWriter().println("Not enough 1Y data");
            return;
        }

        // --- Daily Returns (1Y) ---
        List<Double> returns = new ArrayList<>();

        for (int i = 1; i < oneYearCloses.size(); i++) {
            double prev = oneYearCloses.get(i - 1);
            if (prev == 0) continue;

            double r = (oneYearCloses.get(i) - prev) / prev;
            returns.add(r);
        }

        double mean = returns.stream().mapToDouble(d -> d).average().orElse(0.0);

        double variance = 0.0;
        for (double r : returns) {
            variance += Math.pow(r - mean, 2);
        }

        variance = returns.size() > 0 ? variance / returns.size() : 0.0;

        double volatility = Math.sqrt(variance) * Math.sqrt(252) * 100;

        // --- Max Drawdown (1Y) ---
        double peak = oneYearCloses.get(0);
        double maxDrawdown = 0.0;

        for (double price : oneYearCloses) {
            if (price > peak) peak = price;

            double drawdown = ((price - peak) / peak) * 100;

            if (drawdown < maxDrawdown) {
                maxDrawdown = drawdown;
            }
        }

        double high1Y = Collections.max(oneYearCloses);
        double low1Y = Collections.min(oneYearCloses);

        String riskCategory;
        if (volatility < 20) riskCategory = "Low";
        else if (volatility < 35) riskCategory = "Moderate";
        else riskCategory = "High";

        // =====================================================
        // 2️⃣ RANGE-BASED DATASET (FOR CHART ONLY)
        // =====================================================

        LocalDate startDate;

        switch (range) {
            case "1M": startDate = endDate.minusMonths(1); break;
            case "6M": startDate = endDate.minusMonths(6); break;
            case "1Y": startDate = endDate.minusYears(1); break;
            case "5Y": startDate = endDate.minusYears(5); break;
            case "MAX": startDate = dates.get(0); break;
            default: startDate = endDate.minusYears(1);
        }

        List<String> filteredDates = new ArrayList<>();
        List<Double> filteredCloses = new ArrayList<>();

        for (int i = 0; i < dates.size(); i++) {
            if (!dates.get(i).isBefore(startDate)) {
                filteredDates.add(dates.get(i).toString());
                filteredCloses.add(closes.get(i));
            }
        }

        List<Double> drawdownList = new ArrayList<>();
        double peakChart = filteredCloses.get(0);

        for (double price : filteredCloses) {

            if (price > peakChart) peakChart = price;

            double dd = ((price - peakChart) / peakChart) * 100;
            drawdownList.add(dd);
        }

        // =====================================================
        // SEND ATTRIBUTES
        // =====================================================

        request.setAttribute("symbol", symbol);
        request.setAttribute("range", range);

        // Fixed Summary (1Y only)
        request.setAttribute("volatility", volatility);
        request.setAttribute("maxDrawdown", maxDrawdown);
        request.setAttribute("high1Y", high1Y);
        request.setAttribute("low1Y", low1Y);
        request.setAttribute("riskCategory", riskCategory);

        // Dynamic Chart
        request.setAttribute("labels", filteredDates);
        request.setAttribute("drawdownList", drawdownList);

        request.getRequestDispatcher("risk.jsp").forward(request, response);
    }
}
