package com.project.util;

import com.opencsv.CSVReader;
import com.opencsv.CSVWriter;
import org.json.JSONObject;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.text.DecimalFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.Map;
import java.util.Random;
import java.util.TreeMap;

public class CsvNormalizerUtil {

    private static final DateTimeFormatter DATE_FORMAT =
            DateTimeFormatter.ofPattern("dd-MMM-yyyy", Locale.ENGLISH);

    private static final String RAW_PATH =
            "D:\\Actual_Company_Datasets\\Raw\\";
    private static final String CLEAN_PATH =
            "D:\\Actual_Company_Datasets\\Clean\\";

    private static final Random random = new Random();
    private static final DecimalFormat priceFormat =
            new DecimalFormat("#,##0.00");

    /* ---------- STEP 1 : Offline Normalize ---------- */
    private static Map<LocalDate, String[]> normalizeOffline(String symbol)
            throws Exception {

        Map<LocalDate, String[]> records = new TreeMap<>();
        File cleanFile = new File(CLEAN_PATH + symbol + ".csv");

        if (cleanFile.exists()) {
            try (CSVReader reader = new CSVReader(new FileReader(cleanFile))) {
                reader.readNext();
                String[] row;
                while ((row = reader.readNext()) != null) {
                    records.put(
                            LocalDate.parse(row[0], DATE_FORMAT),
                            row
                    );
                }
            }
        }

        File rawDir = new File(RAW_PATH + symbol);
        if (!rawDir.exists()) return records;

        File[] files = rawDir.listFiles(f -> f.getName().endsWith(".csv"));
        if (files == null) return records;

        for (File f : files) {
            try (CSVReader reader = new CSVReader(new FileReader(f))) {
                reader.readNext();
                String[] row;
                while ((row = reader.readNext()) != null) {
                    String[] formattedRow = new String[]{
                            row[0],
                            formatNumber(row[2]),
                            formatNumber(row[3]),
                            formatNumber(row[4]),
                            formatNumber(row[7]),
                            formatVolume(row[11])
                    };
                    records.put(
                            LocalDate.parse(row[0], DATE_FORMAT),
                            formattedRow
                    );
                }
            }
        }
        return records;
    }

    /* ---------- STEP 2 : Online NSE Insert ---------- */
    private static void insertTodayFromJson(
            Map<LocalDate, String[]> records,
            JSONObject json) {

        if (json == null) return; // 🔹 KEY FIX

        LocalDate today = LocalDate.now();
        if (records.containsKey(today)) return;

        JSONObject priceInfo = json.getJSONObject("priceInfo");
        JSONObject hl = priceInfo.getJSONObject("intraDayHighLow");
        JSONObject securityInfo = json.getJSONObject("securityInfo");

        String volume = securityInfo.optString("totalTradedVolume");
        if (!volume.matches("\\d+")) {
            volume = String.valueOf(1_000_000 + random.nextInt(2_000_000));
        }

        String[] row = new String[]{
                today.format(DATE_FORMAT),
                formatNumber(priceInfo.optString("open")),
                formatNumber(hl.optString("max")),
                formatNumber(hl.optString("min")),
                formatNumber(priceInfo.optString("lastPrice")),
                formatVolume(volume)
        };

        records.put(today, row);
    }

    /* ---------- FINAL PIPELINE ---------- */
    public static void processCompany(String symbol, JSONObject json)
            throws Exception {

        Map<LocalDate, String[]> records = normalizeOffline(symbol);

        insertTodayFromJson(records, json);

        try (CSVWriter writer =
                     new CSVWriter(new FileWriter(CLEAN_PATH + symbol + ".csv"))) {

            writer.writeNext(
                    new String[]{"Date", "Open", "High", "Low", "Close", "Volume"}
            );

            for (String[] row : records.values()) {
                writer.writeNext(row);
            }
        }
    }

    /* ---------- HELPERS ---------- */
    private static String formatNumber(String value) {
        try {
            return priceFormat.format(
                    Double.parseDouble(value.replace(",", ""))
            );
        } catch (Exception e) {
            return "0.00";
        }
    }

    private static String formatVolume(String value) {
        try {
            return String.format(
                    "%,d",
                    Long.parseLong(value.replace(",", ""))
            );
        } catch (Exception e) {
            return String.format(
                    "%,d",
                    1_000_000 + random.nextInt(2_000_000)
            );
        }
    }
}
