package com.project.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.HashMap;
import java.util.Map;

/**
 * Reads company info dynamically from company_info.csv
 * Provides symbol → CompanyInfo mapping.
 */
public class CompanyRegistry {

    public static class CompanyInfo {
        public String name;
        public String sector;
        public String description;

        public CompanyInfo(String name, String sector, String description) {
            this.name = name;
            this.sector = sector;
            this.description = description;
        }
    }

    private static final String DATA_PATH =
            "C:\\Users\\ELCOT\\Documents\\NetBeansProjects\\MyFirstServletProject\\data\\company_info.csv";

    private static final Map<String, CompanyInfo> companies = new HashMap<>();

    static {
        loadCompanies();
    }

    private static void loadCompanies() {
        File csvFile = new File(DATA_PATH);
        if (!csvFile.exists()) return;

        try (BufferedReader br = new BufferedReader(new FileReader(csvFile))) {
            String line = br.readLine(); // skip header
            while ((line = br.readLine()) != null) {
                String[] cols = line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");
                if (cols.length < 4) continue;

                String symbol = cols[0].trim();
                String name = cols[1].trim();
                String sector = cols[2].trim();
                String description = cols[3].trim();

                companies.put(symbol, new CompanyInfo(name, sector, description));
            }
        } catch (Exception e) {
            System.err.println("Error reading company_info.csv: " + e.getMessage());
        }
    }

    public static CompanyInfo getCompany(String symbol) {
        return companies.get(symbol);
    }
}