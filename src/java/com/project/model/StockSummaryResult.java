package com.project.model;

public class StockSummaryResult {

    // ===== Raw Important Values =====
    public double latestClose;
    public Double latestMA;
    public double rsi;
    public double momentum;
    public double latestVolume;
    public double volumeChangePercent;
    public double volatility;
    public double maxDrawdown;

    // ===== Scores =====
    public int trendScore;
    public int momentumScore;
    public int volumeScore;
    public int riskScore;
    public int overallScore;

    public StockSummaryResult(
            double latestClose,
            Double latestMA,
            double rsi,
            double momentum,
            double latestVolume,
            double volumeChangePercent,
            double volatility,
            double maxDrawdown,
            int trendScore,
            int momentumScore,
            int volumeScore,
            int riskScore,
            int overallScore
    ) {
        this.latestClose = latestClose;
        this.latestMA = latestMA;
        this.rsi = rsi;
        this.momentum = momentum;
        this.latestVolume = latestVolume;
        this.volumeChangePercent = volumeChangePercent;
        this.volatility = volatility;
        this.maxDrawdown = maxDrawdown;
        this.trendScore = trendScore;
        this.momentumScore = momentumScore;
        this.volumeScore = volumeScore;
        this.riskScore = riskScore;
        this.overallScore = overallScore;
    }
}
