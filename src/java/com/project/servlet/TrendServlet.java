package com.project.servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;

public class TrendServlet extends HttpServlet {

    private static final String CLEAN_PATH =
        "D:/Actual_Company_Datasets/Clean/";

    private static final int MA_WINDOW = 20;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String symbol = req.getParameter("symbol");
        String range = req.getParameter("range");

        if (symbol == null || symbol.isEmpty()) {
            resp.sendRedirect("sample.jsp");
            return;
        }

        if (range == null) {
            range = "1Y"; // default
        }

        File csvFile = new File(CLEAN_PATH + symbol + ".csv");
        if (!csvFile.exists()) {
            throw new ServletException("CSV file not found for " + symbol);
        }

        List<String> dates = new ArrayList<>();
        List<Double> openList = new ArrayList<>();
        List<Double> highList = new ArrayList<>();
        List<Double> lowList = new ArrayList<>();
        List<Double> closeList = new ArrayList<>();
        List<Long> volumeList = new ArrayList<>();

        // READ CSV
        try (BufferedReader br = new BufferedReader(new FileReader(csvFile))) {
            String line;
            br.readLine(); // skip header

            while ((line = br.readLine()) != null) {

                String[] cols = line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");


                if (cols.length < 6) continue;

                dates.add(cols[0].replace("\"", "").trim());

                openList.add(Double.parseDouble(cols[1].replace("\"","").replace(",","").trim()));
                highList.add(Double.parseDouble(cols[2].replace("\"","").replace(",","").trim()));
                lowList.add(Double.parseDouble(cols[3].replace("\"","").replace(",","").trim()));
                closeList.add(Double.parseDouble(cols[4].replace("\"","").replace(",","").trim()));
                volumeList.add(Long.parseLong(cols[5].replace("\"","").replace(",","").trim()));
            }
        }

        int size = closeList.size();

        // RANGE CALCULATION
        int days = size;
        switch (range) {
            case "1M": days = 21; break;
            case "6M": days = 126; break;
            case "1Y": days = 252; break;
            case "5Y": days = 252 * 5; break;
            case "MAX": days = size; break;
        }

        int startIndex = Math.max(0, size - days);

        // FILTERED DATA
        List<String> filteredDates = dates.subList(startIndex, size);
        List<Double> filteredClose = closeList.subList(startIndex, size);

        // MOVING AVERAGE (20 DAY)
        List<Double> movingAvg = new ArrayList<>();
        for (int i = startIndex; i < size; i++) {

            if (i < MA_WINDOW - 1) {
                movingAvg.add(null);
            } else {
                double sum = 0;
                for (int j = i; j > i - MA_WINDOW; j--) {
                    sum += closeList.get(j);
                }
                movingAvg.add(sum / MA_WINDOW);
            }
        }

        // SUMMARY (1Y reference always)
        int oneYearStart = Math.max(0, size - 252);

        double oneYearHigh = Double.MIN_VALUE;
        double oneYearLow = Double.MAX_VALUE;

        for (int i = oneYearStart; i < size; i++) {
            oneYearHigh = Math.max(oneYearHigh, highList.get(i));
            oneYearLow = Math.min(oneYearLow, lowList.get(i));
        }

        double latestClose = closeList.get(size - 1);
        double previousClose = closeList.get(size - 2);
        double dailyChange = latestClose - previousClose;
        double dailyChangePercent = (dailyChange / previousClose) * 100;

        double priceOneYearAgo = closeList.get(oneYearStart);
        double oneYearReturn =
                ((latestClose - priceOneYearAgo) / priceOneYearAgo) * 100;

        Double latestMA = movingAvg.get(movingAvg.size() - 1);

        // LAST 10 DAYS
        List<Map<String, Object>> recentData = new ArrayList<>();
        int lastTenStart = Math.max(0, size - 10);

        for (int i = lastTenStart; i < size; i++) {
            Map<String, Object> row = new HashMap<>();
            row.put("date", dates.get(i));
            row.put("open", openList.get(i));
            row.put("high", highList.get(i));
            row.put("low", lowList.get(i));
            row.put("close", closeList.get(i));
            row.put("volume", volumeList.get(i));
            recentData.add(row);
        }

        // SEND TO JSP
        req.setAttribute("symbol", symbol);
        req.setAttribute("range", range);

        req.setAttribute("dates", filteredDates);
        req.setAttribute("closeList", filteredClose);
        req.setAttribute("movingAvg", movingAvg);

        req.setAttribute("latestClose", latestClose);
        req.setAttribute("dailyChange", dailyChange);
        req.setAttribute("dailyChangePercent", dailyChangePercent);
        req.setAttribute("oneYearHigh", oneYearHigh);
        req.setAttribute("oneYearLow", oneYearLow);
        req.setAttribute("oneYearReturn", oneYearReturn);
        req.setAttribute("latestMA", latestMA);

        req.setAttribute("recentData", recentData);

        req.getRequestDispatcher("trends.jsp").forward(req, resp);
    }
}
