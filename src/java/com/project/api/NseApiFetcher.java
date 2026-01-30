package com.project.api;

import org.json.JSONObject;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class NseApiFetcher {

    /**
     * Fetch NSE JSON data for the given company symbol.
     * @param symbol Company symbol, e.g., "TCS"
     * @return JSONObject containing NSE data
     * @throws Exception if HTTP request fails
     */
    public static JSONObject fetch(String symbol) throws Exception {

        String BASE_URL = "https://www.nseindia.com";

        // Step 1: get cookies
        HttpURLConnection homeConn =
                (HttpURLConnection) new URL(BASE_URL).openConnection();
        homeConn.setRequestProperty("User-Agent", "Mozilla/5.0");
        homeConn.connect();
        String cookies = homeConn.getHeaderField("Set-Cookie");

        // Step 2: Fetch JSON from NSE
        String quoteUrl = BASE_URL + "/api/quote-equity?symbol=" + symbol;
        HttpURLConnection conn =
                (HttpURLConnection) new URL(quoteUrl).openConnection();
        conn.setRequestProperty("User-Agent", "Mozilla/5.0");
        conn.setRequestProperty("Accept", "application/json");
        conn.setRequestProperty("Referer", BASE_URL + "/get-quotes/equity?symbol=" + symbol);
        conn.setRequestProperty("Cookie", cookies);

        if (conn.getResponseCode() != 200) {
            throw new RuntimeException("HTTP error " + conn.getResponseCode());
        }

        StringBuilder sb = new StringBuilder();
        try (BufferedReader br =
                     new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
        }

        return new JSONObject(sb.toString());
    }
}
