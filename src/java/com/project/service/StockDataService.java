package com.project.service;

import com.project.model.StockData;
import com.project.util.CleanPathResolver;

import java.io.*;
import java.util.*;

public class StockDataService {

    /**
     * Load full historical data for a company symbol using CleanPathResolver
     */
    public StockData loadStockData(String symbol) throws Exception {
        // Get exact CSV file path from CleanPathResolver
        File csvFile = CleanPathResolver.getCleanFile(symbol);
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
                // CSV can have quoted values with commas
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

    // -------------------- Subset helpers --------------------
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

    public StockData getLastNDays(StockData data, int n) {
        int size = data.size();
        int startIndex = Math.max(0, size - n);
        return getSubData(data, startIndex, size);
    }
}