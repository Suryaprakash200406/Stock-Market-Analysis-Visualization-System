package com.project.model;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public class ViewExportResult {

    private List<Map<String, String>> records;
    private LocalDate firstDate;
    private LocalDate lastDate;
    private String range;
    private LocalDate from;
    private LocalDate to;

    public ViewExportResult(
            List<Map<String, String>> records,
            LocalDate firstDate,
            LocalDate lastDate,
            String range,
            LocalDate from,
            LocalDate to) {

        this.records = records;
        this.firstDate = firstDate;
        this.lastDate = lastDate;
        this.range = range;
        this.from = from;
        this.to = to;
    }

    public List<Map<String, String>> getRecords() { return records; }
    public LocalDate getFirstDate() { return firstDate; }
    public LocalDate getLastDate() { return lastDate; }
    public String getRange() { return range; }
    public LocalDate getFrom() { return from; }
    public LocalDate getTo() { return to; }

    public int getRecordCount() {
        return records == null ? 0 : records.size();
    }
}
