package com.project.model;

import java.util.List;

public class VolumeResult {
    private List<String> dates;
    private List<Double> volumeList;
    private List<Double> volumeMA;
    private double latestVolume;
    private double volumeChangePercent;
    private double highestVolume;
    private double averageVolume;

    public VolumeResult(List<String> dates, List<Double> volumeList, List<Double> volumeMA,
                        double latestVolume, double volumeChangePercent, double highestVolume, double averageVolume) {
        this.dates = dates;
        this.volumeList = volumeList;
        this.volumeMA = volumeMA;
        this.latestVolume = latestVolume;
        this.volumeChangePercent = volumeChangePercent;
        this.highestVolume = highestVolume;
        this.averageVolume = averageVolume;
    }

    // Getters
    public List<String> getDates() { return dates; }
    public List<Double> getVolumeList() { return volumeList; }
    public List<Double> getVolumeMA() { return volumeMA; }
    public double getLatestVolume() { return latestVolume; }
    public double getVolumeChangePercent() { return volumeChangePercent; }
    public double getHighestVolume() { return highestVolume; }
    public double getAverageVolume() { return averageVolume; }
}
