package com.project.servlet;

import java.io.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class VolumeServlet extends HttpServlet {

    private static final DateTimeFormatter CSV_DATE_FORMAT =
            DateTimeFormatter.ofPattern("dd-MMM-yyyy", Locale.ENGLISH);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String symbol = request.getParameter("symbol");
        String range = request.getParameter("range");

        if (symbol == null || symbol.trim().isEmpty()) {
            response.getWriter().println("Symbol is missing");
            return;
        }

        if (range == null || range.trim().isEmpty()) {
            range = "1M"; // default range
        }

        String csvFilePath = "D:/Actual_Company_Datasets/Clean/" + symbol + ".csv";
        File csvFile = new File(csvFilePath);

        if (!csvFile.exists()) {
            response.getWriter().println("CSV file not found for symbol: " + symbol);
            return;
        }

        List<LocalDate> dates = new ArrayList<>();
        List<Double> volumes = new ArrayList<>();

        // ---------------- READ CSV ----------------
        try (BufferedReader br = new BufferedReader(new FileReader(csvFile))) {

            String line = br.readLine(); // skip header

            while ((line = br.readLine()) != null) {

                if (line.length() < 5) continue;

                line = line.substring(1, line.length() - 1);
                String[] tokens = line.split("\",\"");

                if (tokens.length < 6) continue;

                try {
                    LocalDate date = LocalDate.parse(tokens[0].trim(), CSV_DATE_FORMAT);
                    double volume = Double.parseDouble(tokens[5].replace(",", "").trim());

                    dates.add(date);
                    volumes.add(volume);
                } catch (Exception ignore) {
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error reading CSV: " + e.getMessage());
            return;
        }

        if (dates.isEmpty()) {
            response.getWriter().println("No data available.");
            return;
        }

        // ---------------- RANGE FILTER ----------------

        LocalDate endDate = dates.get(dates.size() - 1);
        LocalDate startDate;

        switch (range) {
            case "1M": startDate = endDate.minusMonths(1); break;
            case "6M": startDate = endDate.minusMonths(6); break;
            case "1Y": startDate = endDate.minusYears(1); break;
            case "5Y": startDate = endDate.minusYears(5); break;
            case "MAX": startDate = dates.get(0); break;
            default: startDate = endDate.minusMonths(1);
        }

        List<String> filteredDates = new ArrayList<>();
        List<Double> filteredVolumes = new ArrayList<>();

        for (int i = 0; i < dates.size(); i++) {
            LocalDate d = dates.get(i);
            if (!d.isBefore(startDate) && !d.isAfter(endDate)) {
                filteredDates.add(d.toString());
                filteredVolumes.add(volumes.get(i));
            }
        }

        if (filteredDates.isEmpty()) {
            int start = Math.max(dates.size() - 30, 0);
            for (int i = start; i < dates.size(); i++) {
                filteredDates.add(dates.get(i).toString());
                filteredVolumes.add(volumes.get(i));
            }
        }

        // ---------------- 20-DAY VOLUME MA ----------------

        List<Double> volumeMA = new ArrayList<>();
        int maPeriod = 20;

        for (int i = 0; i < filteredVolumes.size(); i++) {

            if (i < maPeriod - 1) {
                volumeMA.add(null);
            } else {
                double sum = 0;
                for (int j = i - maPeriod + 1; j <= i; j++) {
                    sum += filteredVolumes.get(j);
                }
                volumeMA.add(sum / maPeriod);
            }
        }

        // ---------------- SUMMARY ----------------

        double latestVolume = 0;
        double volumeChangePercent = 0;
        double highestVolume = 0;
        double averageVolume = 0;

        if (!filteredVolumes.isEmpty()) {

            int lastIndex = filteredVolumes.size() - 1;
            latestVolume = filteredVolumes.get(lastIndex);

            if (lastIndex > 0) {
                double prevVolume = filteredVolumes.get(lastIndex - 1);
                if (prevVolume != 0) {
                    volumeChangePercent =
                            ((latestVolume - prevVolume) / prevVolume) * 100;
                }
            }

            highestVolume = Collections.max(filteredVolumes);

            double sum = 0;
            for (double v : filteredVolumes) sum += v;
            averageVolume = sum / filteredVolumes.size();
        }

        // ---------------- SEND TO JSP ----------------

        request.setAttribute("symbol", symbol);
        request.setAttribute("range", range);
        request.setAttribute("dates", filteredDates);
        request.setAttribute("volumes", filteredVolumes);
        request.setAttribute("volumeMA", volumeMA);

        request.setAttribute("latestVolume", latestVolume);
        request.setAttribute("volumeChangePercent", volumeChangePercent);
        request.setAttribute("highestVolume", highestVolume);
        request.setAttribute("averageVolume", averageVolume);

        request.getRequestDispatcher("volume.jsp").forward(request, response);
    }
}
