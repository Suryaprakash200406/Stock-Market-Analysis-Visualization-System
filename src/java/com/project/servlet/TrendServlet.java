package com.project.servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;

public class TrendServlet extends HttpServlet {

    private static final String CLEAN_PATH =
        "D:/Actual_Company_Datasets/Clean/";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String symbol = req.getParameter("symbol");
        if (symbol == null || symbol.isEmpty()) {
            resp.sendRedirect("landing.jsp");
            return;
        }

        File csvFile = new File(CLEAN_PATH + symbol + ".csv");

        List<String> dates = new ArrayList<>();
        List<Double> closePrices = new ArrayList<>();
        List<Double> movingAvg = new ArrayList<>();

        try (BufferedReader br = new BufferedReader(new FileReader(csvFile))) {
            String line;
            br.readLine(); // skip header

            while ((line = br.readLine()) != null) {
                String[] cols = line.split(",");
                dates.add(cols[0]);                    // DATE
                closePrices.add(Double.parseDouble(cols[4])); // CLOSE
            }
        }

        // Calculate 20-day Moving Average
        int window = 20;
        for (int i = 0; i < closePrices.size(); i++) {
            if (i < window - 1) {
                movingAvg.add(null);
            } else {
                double sum = 0;
                for (int j = i; j > i - window; j--) {
                    sum += closePrices.get(j);
                }
                movingAvg.add(sum / window);
            }
        }

        req.setAttribute("symbol", symbol);
        req.setAttribute("dates", dates);
        req.setAttribute("closePrices", closePrices);
        req.setAttribute("movingAvg", movingAvg);

        req.getRequestDispatcher("trends.jsp").forward(req, resp);
    }
}
