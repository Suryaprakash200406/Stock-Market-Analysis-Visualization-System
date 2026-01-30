package com.project.api;

import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.LinkedHashMap;

@WebServlet("/ds1parse")
public class ds1parse extends HttpServlet {

    private static final int RETRY_COUNT = 3;
    private static final int RETRY_DELAY_MS = 2000;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String symbol = "TCS";
        String baseUrl = "https://www.nseindia.com";
        String quoteUrl = baseUrl + "/api/quote-equity?symbol=" + symbol;

        ArrayList<LinkedHashMap<String, String>> dataList = new ArrayList<>();

        int attempt = 0;

        while (attempt < RETRY_COUNT) {
            attempt++;

            try {
                /* ---------- STEP 1: GET COOKIES ---------- */
                HttpURLConnection homeConn =
                        (HttpURLConnection) new URL(baseUrl).openConnection();
                homeConn.setRequestProperty("User-Agent", "Mozilla/5.0");
                homeConn.connect();

                String cookies = homeConn.getHeaderField("Set-Cookie");

                /* ---------- STEP 2: FETCH JSON ---------- */
                HttpURLConnection conn =
                        (HttpURLConnection) new URL(quoteUrl).openConnection();
                conn.setRequestProperty("User-Agent", "Mozilla/5.0");
                conn.setRequestProperty("Accept", "application/json");
                conn.setRequestProperty("Referer",
                        baseUrl + "/get-quotes/equity?symbol=" + symbol);
                conn.setRequestProperty("Cookie", cookies);

                if (conn.getResponseCode() != 200) {
                    throw new IOException("HTTP error " + conn.getResponseCode());
                }

                StringBuilder sb = new StringBuilder();
                try (BufferedReader br =
                             new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        sb.append(line);
                    }
                }

                JSONObject json = new JSONObject(sb.toString());

                /* ---------- STEP 3: PARSE JSON ---------- */
                JSONObject priceInfo = json.optJSONObject("priceInfo");
                JSONObject metadata = json.optJSONObject("metadata");
                JSONObject securityInfo = json.optJSONObject("securityInfo");
                JSONObject highLow =
                        priceInfo != null ? priceInfo.optJSONObject("intraDayHighLow") : null;

                LinkedHashMap<String, String> row = new LinkedHashMap<>();

                row.put("Symbol", symbol);
                row.put("Last Price", priceInfo != null ? priceInfo.optString("lastPrice", "-") : "-");
                row.put("Open", priceInfo != null ? priceInfo.optString("open", "-") : "-");
                row.put("High", highLow != null ? highLow.optString("max", "-") : "-");
                row.put("Low", highLow != null ? highLow.optString("min", "-") : "-");
                row.put("Previous Close", priceInfo != null ? priceInfo.optString("previousClose", "-") : "-");
                row.put("Change %", priceInfo != null ? priceInfo.optString("pChange", "-") : "-");
                row.put("Volume", priceInfo != null ? priceInfo.optString("totalTradedVolume", "-") : "-");

                row.put("ISIN", securityInfo != null ? securityInfo.optString("isin", "-") : "-");
                row.put("Listing Date", metadata != null ? metadata.optString("listingDate", "-") : "-");
                row.put("Last Update", metadata != null ? metadata.optString("lastUpdateTime", "-") : "-");
                row.put("Series", metadata != null ? metadata.optString("series", "-") : "-");

                dataList.add(row);

                /* ---------- STEP 4: FORWARD TO JSP ---------- */
                request.setAttribute("dataList", dataList);
                request.setAttribute("symbol", symbol);

                request.getRequestDispatcher("displayparsed.jsp")
                        .forward(request, response);
                return;

            } catch (Exception e) {
                if (attempt >= RETRY_COUNT) {
                    request.setAttribute("errorMsg",
                            "Failed to fetch NSE data: " + e.getMessage());
                    request.setAttribute("symbol", symbol);
                    request.getRequestDispatcher("displayparsed.jsp")
                            .forward(request, response);
                    return;
                }
                try {
                    Thread.sleep(RETRY_DELAY_MS);
                } catch (InterruptedException ignored) {
                }
            }
        }
    }
}
