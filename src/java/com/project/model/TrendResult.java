package com.project.model;

import java.util.List;
import java.util.Map;

public class TrendResult {
    public List<String> dates;
    public List<Double> closeList;
    public List<Double> movingAvg;
    public double latestClose;
    public double dailyChange;
    public double dailyChangePercent;
    public double oneYearHigh;
    public double oneYearLow;
    public double oneYearReturn;
    public Double latestMA;
    public List<Map<String, Object>> recentData;

    public TrendResult(List<String> dates, List<Double> closeList, List<Double> movingAvg,
                       double latestClose, double dailyChange, double dailyChangePercent,
                       double oneYearHigh, double oneYearLow, double oneYearReturn,
                       Double latestMA, List<Map<String, Object>> recentData) {
        this.dates = dates;
        this.closeList = closeList;
        this.movingAvg = movingAvg;
        this.latestClose = latestClose;
        this.dailyChange = dailyChange;
        this.dailyChangePercent = dailyChangePercent;
        this.oneYearHigh = oneYearHigh;
        this.oneYearLow = oneYearLow;
        this.oneYearReturn = oneYearReturn;
        this.latestMA = latestMA;
        this.recentData = recentData;
    }
}
