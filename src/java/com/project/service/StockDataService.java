package com.project.service;

import com.project.model.StockData;

import java.io.*;
import java.util.*;

public class StockDataService {

    private static final String CLEAN_PATH = "D:/Actual_Company_Datasets/Clean/";

    /**
     * Load full historical data for a company symbol
     */
    public StockData loadStockData(String symbol) throws Exception {
        File csvFile = new File(CLEAN_PATH + symbol + ".csv");
        if (!csvFile.exists()) throw new Exception("CSV not found for " + symbol);

        List<String> dates = new ArrayList<>();
        List<Double> open = new ArrayList<>();
        List<Double> high = new ArrayList<>();
        List<Double> low = new ArrayList<>();
        List<Double> close = new ArrayList<>();
        List<Long> volume = new ArrayList<>();

        try (BufferedReader br = new BufferedReader(new FileReader(csvFile))) {
            br.readLine(); // skip header
            String line;
            while ((line = br.readLine()) != null) {
                String[] cols = line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");
                if (cols.length < 6) continue;

                dates.add(cols[0].replace("\"", "").trim());
                open.add(Double.parseDouble(cols[1].replace("\"", "").replace(",", "")));
                high.add(Double.parseDouble(cols[2].replace("\"", "").replace(",", "")));
                low.add(Double.parseDouble(cols[3].replace("\"", "").replace(",", "")));
                close.add(Double.parseDouble(cols[4].replace("\"", "").replace(",", "")));
                volume.add(Long.parseLong(cols[5].replace("\"", "").replace(",", "")));
            }
        }

        return new StockData(dates, open, high, low, close, volume);
    }

    /**
     * Filter stock data by index range
     */
    public StockData getSubData(StockData data, int startIndex, int endIndex) {
        return new StockData(
                data.getDates().subList(startIndex, endIndex),
                data.getOpen().subList(startIndex, endIndex),
                data.getHigh().subList(startIndex, endIndex),
                data.getLow().subList(startIndex, endIndex),
                data.getClose().subList(startIndex, endIndex),
                data.getVolume().subList(startIndex, endIndex)
        );
    }

    /**
     * Get last N days of stock data
     */
    public StockData getLastNDays(StockData data, int n) {
        int size = data.size();
        int startIndex = Math.max(0, size - n);
        return getSubData(data, startIndex, size);
    }
}
