package com.project.service;

import com.project.model.StockData;
import com.project.model.TrendResult;
import com.project.model.StockSummaryResult;


import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class StockAnalyzerService {

    private static final String CLEAN_PATH = "D:/Actual_Company_Datasets/Clean/";
    private static final DateTimeFormatter CSV_DATE_FORMAT = DateTimeFormatter.ofPattern("dd-MMM-yyyy", Locale.ENGLISH);

    private final StockDataService stockDataService = new StockDataService();

    // -------------------- Load full stock data --------------------
    public StockData loadStockData(String symbol) throws Exception {
        return stockDataService.loadStockData(symbol);
    }

    // -------------------- Filter stock data by calendar range --------------------
    public StockData filterByRange(StockData data, String range) {
        List<String> dates = data.getDates();
        List<Double> open = data.getOpen();
        List<Double> high = data.getHigh();
        List<Double> low = data.getLow();
        List<Double> close = data.getClose();
        List<Long> volume = data.getVolume();

        if (dates.isEmpty()) return new StockData(new ArrayList<>(), new ArrayList<>(), new ArrayList<>(),
                new ArrayList<>(), new ArrayList<>(), new ArrayList<>());

        LocalDate lastDate = LocalDate.parse(dates.get(dates.size() - 1), CSV_DATE_FORMAT);
        LocalDate startDate;

        switch (range) {
            case "1M": startDate = lastDate.minusMonths(1); break;
            case "6M": startDate = lastDate.minusMonths(6); break;
            case "1Y": startDate = lastDate.minusYears(1); break;
            case "5Y": startDate = lastDate.minusYears(5); break;
            case "MAX": startDate = LocalDate.parse(dates.get(0), CSV_DATE_FORMAT); break;
            default: startDate = lastDate.minusMonths(1);
        }

        List<String> fDates = new ArrayList<>();
        List<Double> fOpen = new ArrayList<>();
        List<Double> fHigh = new ArrayList<>();
        List<Double> fLow = new ArrayList<>();
        List<Double> fClose = new ArrayList<>();
        List<Long> fVolume = new ArrayList<>();

        for (int i = 0; i < dates.size(); i++) {
            LocalDate d = LocalDate.parse(dates.get(i), CSV_DATE_FORMAT);
            if (!d.isBefore(startDate) && !d.isAfter(lastDate)) {
                fDates.add(dates.get(i));
                fOpen.add(open.get(i));
                fHigh.add(high.get(i));
                fLow.add(low.get(i));
                fClose.add(close.get(i));
                fVolume.add(volume.get(i));
            }
        }

        return new StockData(fDates, fOpen, fHigh, fLow, fClose, fVolume);
    }

    // -------------------- Trend Analysis --------------------
    public TrendResult analyzeTrend(StockData data) {
        List<Double> closeList = data.getClose();
        List<String> dates = data.getDates();
        List<Double> movingAvg = new ArrayList<>();
        int MA_WINDOW = 20;

        for (int i = 0; i < closeList.size(); i++) {
            if (i < MA_WINDOW - 1) movingAvg.add(null);
            else {
                double sum = 0;
                for (int j = i - MA_WINDOW + 1; j <= i; j++) sum += closeList.get(j);
                movingAvg.add(sum / MA_WINDOW);
            }
        }

        double latestClose = closeList.get(closeList.size() - 1);
        double previousClose = closeList.get(closeList.size() - 2);
        double dailyChange = latestClose - previousClose;
        double dailyChangePercent = (dailyChange / previousClose) * 100;

        double oneYearHigh = Collections.max(data.getHigh());
        double oneYearLow = Collections.min(data.getLow());
        double priceOneYearAgo = closeList.get(0);
        double oneYearReturn = ((latestClose - priceOneYearAgo) / priceOneYearAgo) * 100;

        Double latestMA = movingAvg.get(movingAvg.size() - 1);

        // last 10 records for table
        List<Map<String, Object>> recentData = new ArrayList<>();
        int lastTenStart = Math.max(0, closeList.size() - 10);
        for (int i = lastTenStart; i < closeList.size(); i++) {
            Map<String, Object> row = new HashMap<>();
            row.put("date", dates.get(i));
            row.put("open", data.getOpen().get(i));
            row.put("high", data.getHigh().get(i));
            row.put("low", data.getLow().get(i));
            row.put("close", data.getClose().get(i));
            row.put("volume", data.getVolume().get(i));
            recentData.add(row);
        }

        return new TrendResult(dates, closeList, movingAvg, latestClose, dailyChange, dailyChangePercent,
                oneYearHigh, oneYearLow, oneYearReturn, latestMA, recentData);
    }

    // -------------------- Volume Analysis --------------------
    public List<Double> getVolumeMA(List<Long> volumes, int period) {
        List<Double> ma = new ArrayList<>();
        for (int i = 0; i < volumes.size(); i++) {
            if (i < period - 1) ma.add(null);
            else {
                double sum = 0;
                for (int j = i - period + 1; j <= i; j++) sum += volumes.get(j);
                ma.add(sum / period);
            }
        }
        return ma;
    }

    public double getLatestVolume(List<Long> volumes) {
        return volumes.isEmpty() ? 0 : volumes.get(volumes.size() - 1);
    }

    public double getVolumeChangePercent(List<Long> volumes) {
        if (volumes.size() < 2) return 0;
        double last = volumes.get(volumes.size() - 1);
        double prev = volumes.get(volumes.size() - 2);
        return prev == 0 ? 0 : ((last - prev) / prev) * 100;
    }

    public double getHighestVolume(List<Long> volumes) {
        return volumes.isEmpty() ? 0 : Collections.max(volumes);
    }

    public double getAverageVolume(List<Long> volumes) {
        if (volumes.isEmpty()) return 0;
        double sum = 0;
        for (long v : volumes) sum += v;
        return sum / volumes.size();
    }

    // -------------------- Risk Analysis --------------------
    public double getVolatility(List<Double> closes) {
        if (closes.size() < 2) return 0;
        List<Double> returns = new ArrayList<>();
        for (int i = 1; i < closes.size(); i++) {
            double prev = closes.get(i - 1);
            if (prev == 0) continue;
            returns.add((closes.get(i) - prev) / prev);
        }
        double mean = returns.stream().mapToDouble(d -> d).average().orElse(0.0);
        double variance = 0.0;
        for (double r : returns) variance += Math.pow(r - mean, 2);
        variance = returns.size() > 0 ? variance / returns.size() : 0.0;
        return Math.sqrt(variance) * Math.sqrt(252) * 100;
    }

    public double getMaxDrawdown(List<Double> closes) {
        if (closes.isEmpty()) return 0;
        double peak = closes.get(0);
        double maxDD = 0;
        for (double price : closes) {
            if (price > peak) peak = price;
            double dd = ((price - peak) / peak) * 100;
            if (dd < maxDD) maxDD = dd;
        }
        return maxDD;
    }
    
    // -------------------- Drawdown series for chart --------------------
    public List<Double> getDrawdownList(List<Double> closes) {
        List<Double> drawdownList = new ArrayList<>();
        if (closes.isEmpty()) return drawdownList;

        double peak = closes.get(0);    
        for (double price : closes) {
            if (price > peak) peak = price;
            double dd = ((price - peak) / peak) * 100;
            drawdownList.add(dd);
        }
        return drawdownList;
    }


    // -------------------- Momentum & RSI --------------------
    public double getMomentum(List<Double> closes, int period) {
        if (closes.size() < period + 1) return 0;
        double latest = closes.get(closes.size() - 1);
        double past = closes.get(closes.size() - 1 - period);
        return ((latest - past) / past) * 100;
    }

    public double getRSI(List<Double> closes, int period) {
        if (closes.size() < period + 1) return 50;
        double gain = 0, loss = 0;
        for (int i = closes.size() - period - 1; i < closes.size() - 1; i++) {
            double diff = closes.get(i + 1) - closes.get(i);
            if (diff > 0) gain += diff;
            else loss += Math.abs(diff);
        }
        double avgGain = gain / period;
        double avgLoss = loss / period;
        if (avgLoss == 0) return 100;
        double rs = avgGain / avgLoss;
        return 100 - (100 / (1 + rs));
    }

    public String getRSISignal(double rsi) {
        if (rsi > 70) return "Overbought";
        else if (rsi < 30) return "Oversold";
        else return "Neutral";
    }
    
    // ===================== STOCK SUMMARY ANALYSIS =====================
    public StockSummaryResult analyzeStockSummary(String symbol) throws Exception {

        // Load full 1Y data
        StockData fullData = loadStockData(symbol);
        StockData data = filterByRange(fullData, "1Y");

        List<Double> closes = data.getClose();
        List<Long> volumes = data.getVolume();
 
        // ===== Trend Analysis =====
        TrendResult trend = analyzeTrend(data);

        int trendScore = 0;

        if (trend.latestClose > trend.latestMA) trendScore += 40;
        if (trend.oneYearReturn > 0) trendScore += 30;
        if (trend.dailyChangePercent > 0) trendScore += 10;

        double rangePosition = (trend.latestClose - trend.oneYearLow) /
                (trend.oneYearHigh - trend.oneYearLow);

        if (rangePosition > 0.6) trendScore += 20;

        trendScore = Math.min(trendScore, 100);

        // ===== Momentum Analysis =====
        double rsi = getRSI(closes, 14);
        double momentum = getMomentum(closes, 10);

        int momentumScore = 0;

        if (rsi >= 50 && rsi <= 65) momentumScore += 40;
        else if (rsi > 65 && rsi <= 75) momentumScore += 30;
        else if (rsi >= 40) momentumScore += 20;
        else momentumScore += 10;

        if (momentum > 0) momentumScore += 40;
        if (momentum > 5) momentumScore += 20;

        momentumScore = Math.min(momentumScore, 100);

        // ===== Volume Analysis =====
        double latestVolume = getLatestVolume(volumes);
        double avgVolume = getAverageVolume(volumes);
        double volumeChange = getVolumeChangePercent(volumes);

        int volumeScore = 0;

        if (latestVolume > avgVolume) volumeScore += 50;
        if (volumeChange > 0) volumeScore += 30;
        if (volumeChange > 10) volumeScore += 20;

        volumeScore = Math.min(volumeScore, 100);

        // ===== Risk Analysis =====
        double volatility = getVolatility(closes);
        double maxDrawdown = getMaxDrawdown(closes);

        int riskScore;

        if (volatility < 20) riskScore = 85;
        else if (volatility < 30) riskScore = 65;
        else if (volatility < 40) riskScore = 45;
        else riskScore = 25;

        if (maxDrawdown < -40) riskScore -= 15;
        else if (maxDrawdown < -30) riskScore -= 10;
        else if (maxDrawdown < -20) riskScore -= 5;

        riskScore = Math.max(0, riskScore);

        // ===== Overall Score =====
        int overallScore = (trendScore + momentumScore + volumeScore + riskScore) / 4;

        return new StockSummaryResult(
                trend.latestClose,
                trend.latestMA,
                rsi,
                momentum,
                latestVolume,
                volumeChange,
                volatility,
                maxDrawdown,
                trendScore,
                momentumScore,
                volumeScore,
                riskScore,
                overallScore
        );
    }

    // ============================================================
    // ================== VIEW & EXPORT METHODS ===================
    // ============================================================

    public LocalDate getFirstRecordDate(String symbol) throws Exception {
        StockData data = loadStockData(symbol);
        if (data.getDates().isEmpty()) return null;
        return LocalDate.parse(data.getDates().get(0), CSV_DATE_FORMAT);
    }

    public LocalDate getLastRecordDate(String symbol) throws Exception {
        StockData data = loadStockData(symbol);
        if (data.getDates().isEmpty()) return null;
        return LocalDate.parse(
                data.getDates().get(data.getDates().size() - 1),
                CSV_DATE_FORMAT
        );
    }

    public List<Map<String, String>> getRecordsByRange(
            String symbol,
            String range) throws Exception {

        StockData fullData = loadStockData(symbol);
        StockData filtered = filterByRange(fullData, range);

        return convertToMapListDescending(filtered);
    }

    public List<Map<String, String>> getRecordsBetweenDates(
            String symbol,
            LocalDate from,
            LocalDate to) throws Exception {

        StockData data = loadStockData(symbol);
        List<Map<String, String>> records = new ArrayList<>();

        for (int i = 0; i < data.getDates().size(); i++) {

            LocalDate current =
                    LocalDate.parse(data.getDates().get(i), CSV_DATE_FORMAT);

            if (!current.isBefore(from) && !current.isAfter(to)) {

                Map<String, String> row = new LinkedHashMap<>();

                row.put("date", data.getDates().get(i));
                row.put("open", String.valueOf(data.getOpen().get(i)));
                row.put("high", String.valueOf(data.getHigh().get(i)));
                row.put("low", String.valueOf(data.getLow().get(i)));
                row.put("close", String.valueOf(data.getClose().get(i)));
                row.put("volume", String.valueOf(data.getVolume().get(i)));

                records.add(row);
            }
        }

        Collections.reverse(records);
        return records;
    }

    private List<Map<String, String>> convertToMapListDescending(
            StockData data) {

        List<Map<String, String>> records = new ArrayList<>();

        for (int i = 0; i < data.getDates().size(); i++) {

            Map<String, String> row = new LinkedHashMap<>();

            row.put("date", data.getDates().get(i));
            row.put("open", String.valueOf(data.getOpen().get(i)));
            row.put("high", String.valueOf(data.getHigh().get(i)));
            row.put("low", String.valueOf(data.getLow().get(i)));
            row.put("close", String.valueOf(data.getClose().get(i)));
            row.put("volume", String.valueOf(data.getVolume().get(i)));

            records.add(row);
        }

        Collections.reverse(records);
        return records;
    }

}
