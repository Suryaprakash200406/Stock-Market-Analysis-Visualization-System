package com.project.servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import java.util.*;

public class MomentumServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String symbol = request.getParameter("symbol");

        if (symbol == null || symbol.isEmpty()) {
            response.sendRedirect("companyDashboard.jsp");
            return;
        }

        String filePath = "D:/Actual_Company_Datasets/Clean/" + symbol + ".csv";
        List<Double> closePrices = new ArrayList<>();
        List<String> dates = new ArrayList<>();

        // Read CSV
        try (BufferedReader br = Files.newBufferedReader(Paths.get(filePath))) {
            String line;
            br.readLine(); // skip header

            while ((line = br.readLine()) != null) {
                String[] data = line.split(",");
                dates.add(data[0].replace("\"", ""));
                String closeStr = data[4].replace("\"", "").trim();
                closePrices.add(Double.parseDouble(closeStr));  // Close price
            }
        }

        int size = closePrices.size();

        if (size < 21) {
            request.setAttribute("error", "Not enough data to calculate momentum.");
            request.getRequestDispatcher("momentum.jsp").forward(request, response);
            return;
        }

        // -----------------------------
        // 🔹 10-day & 20-day Momentum
        // -----------------------------
        double latestClose = closePrices.get(size - 1);

        double close10 = closePrices.get(size - 11);
        double momentum10 = ((latestClose - close10) / close10) * 100;

        double close20 = closePrices.get(size - 21);
        double momentum20 = ((latestClose - close20) / close20) * 100;

        // -----------------------------
        // 🔹 14-Day RSI
        // -----------------------------
        int period = 14;
        double gain = 0, loss = 0;

        for (int i = size - period - 1; i < size - 1; i++) {
            double change = closePrices.get(i + 1) - closePrices.get(i);
            if (change > 0) gain += change;
            else loss += Math.abs(change);
        }

        double avgGain = gain / period;
        double avgLoss = loss / period;

        double rs = (avgLoss == 0) ? 0 : avgGain / avgLoss;
        double rsi = (avgLoss == 0) ? 100 : 100 - (100 / (1 + rs));

        // RSI Signal
        String rsiSignal;
        if (rsi > 70)
            rsiSignal = "Overbought";
        else if (rsi < 30)
            rsiSignal = "Oversold";
        else
            rsiSignal = "Neutral";

        // -----------------------------
        // 🔹 RSI Chart Data (Last 6 months ~ 120 days)
        // -----------------------------
        List<Double> rsiValues = new ArrayList<>();
        List<String> chartDates = new ArrayList<>();

        int chartStart = Math.max(period, size - 120);

        for (int i = chartStart; i < size; i++) {

            double g = 0, l = 0;

            for (int j = i - period; j < i; j++) {
                double ch = closePrices.get(j + 1) - closePrices.get(j);
                if (ch > 0) g += ch;
                else l += Math.abs(ch);
            }

            double ag = g / period;
            double al = l / period;

            double r = (al == 0) ? 100 : 100 - (100 / (1 + (ag / al)));

            rsiValues.add(r);
            chartDates.add(dates.get(i));
        }

        // Set attributes
        request.setAttribute("symbol", symbol);
        request.setAttribute("momentum10", momentum10);
        request.setAttribute("momentum20", momentum20);
        request.setAttribute("rsi", rsi);
        request.setAttribute("rsiSignal", rsiSignal);
        request.setAttribute("rsiValues", rsiValues);
        request.setAttribute("chartDates", chartDates);

        request.getRequestDispatcher("momentum.jsp").forward(request, response);
    }
}
