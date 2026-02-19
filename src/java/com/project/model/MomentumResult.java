package com.project.model;

import java.util.List;

public class MomentumResult {
    private double momentum10;
    private double momentum20;
    private double rsi;
    private String rsiSignal;
    private List<Double> rsiValues;
    private List<String> chartDates;

    public MomentumResult(double momentum10, double momentum20, double rsi, String rsiSignal,
                          List<Double> rsiValues, List<String> chartDates) {
        this.momentum10 = momentum10;
        this.momentum20 = momentum20;
        this.rsi = rsi;
        this.rsiSignal = rsiSignal;
        this.rsiValues = rsiValues;
        this.chartDates = chartDates;
    }

    // Getters
    public double getMomentum10() { return momentum10; }
    public double getMomentum20() { return momentum20; }
    public double getRsi() { return rsi; }
    public String getRsiSignal() { return rsiSignal; }
    public List<Double> getRsiValues() { return rsiValues; }
    public List<String> getChartDates() { return chartDates; }
}
