package com.project.model;

import java.util.List;

public class StockData {

    private List<String> dates;
    private List<Double> open;
    private List<Double> high;
    private List<Double> low;
    private List<Double> close;
    private List<Long> volume;

    public StockData(List<String> dates, List<Double> open, List<Double> high,
                     List<Double> low, List<Double> close, List<Long> volume) {
        this.dates = dates;
        this.open = open;
        this.high = high;
        this.low = low;
        this.close = close;
        this.volume = volume;
    }

    public List<String> getDates() { return dates; }
    public List<Double> getOpen() { return open; }
    public List<Double> getHigh() { return high; }
    public List<Double> getLow() { return low; }
    public List<Double> getClose() { return close; }
    public List<Long> getVolume() { return volume; }

    // ---------------- Utility Methods ----------------

    public int size() {
        return dates != null ? dates.size() : 0;
    }

    public double getLatestClose() {
        return close.get(close.size() - 1);
    }

    public double getPreviousClose() {
        return close.size() > 1 ? close.get(close.size() - 2) : close.get(0);
    }

    public double getClose(int index) {
        return close.get(index);
    }

    public long getVolume(int index) {
        return volume.get(index);
    }

    public String getDate(int index) {
        return dates.get(index);
    }
}
