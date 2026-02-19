package com.project.model;

public class RiskResult {
    private double volatility;
    private double maxDrawdown;
    private double high1Y;
    private double low1Y;
    private String riskCategory;

    public RiskResult(double volatility, double maxDrawdown, double high1Y, double low1Y, String riskCategory) {
        this.volatility = volatility;
        this.maxDrawdown = maxDrawdown;
        this.high1Y = high1Y;
        this.low1Y = low1Y;
        this.riskCategory = riskCategory;
    }

    // Getters
    public double getVolatility() { return volatility; }
    public double getMaxDrawdown() { return maxDrawdown; }
    public double getHigh1Y() { return high1Y; }
    public double getLow1Y() { return low1Y; }
    public String getRiskCategory() { return riskCategory; }
}
