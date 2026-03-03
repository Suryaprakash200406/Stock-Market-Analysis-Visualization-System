package com.project.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.*;

/**
 * Reads company info dynamically from company_info.csv
 * Provides symbol → CompanyInfo mapping.
 */
public class CompanyRegistry {

    public static class CompanyInfo {
        public String symbol;
        public String name;
        public String sector;
        public String description;

        public CompanyInfo(String symbol, String name,
                           String sector, String description) {
            this.symbol = symbol;
            this.name = name;
            this.sector = sector;
            this.description = description;
        }
    }

    private static final String DATA_PATH =
            "C:\\Users\\ELCOT\\Documents\\NetBeansProjects\\MyFirstServletProject\\data\\company_info.csv";

    // LinkedHashMap → preserves CSV order
    private static final Map<String, CompanyInfo> companies =
            new LinkedHashMap<>();

    static {
        loadCompanies();
    }

    /**
     * Load companies from CSV file
     */
    private static void loadCompanies() {

        companies.clear();

        File csvFile = new File(DATA_PATH);
        if (!csvFile.exists()) return;

        try (BufferedReader br = new BufferedReader(new FileReader(csvFile))) {

            br.readLine(); // skip header

            String line;
            while ((line = br.readLine()) != null) {

                String[] cols = line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");
                if (cols.length < 4) continue;

                String symbol = cols[0].trim();
                String name = cols[1].trim();
                String sector = cols[2].trim();
                String description = cols[3].trim();

                companies.put(symbol,
                        new CompanyInfo(symbol, name, sector, description));
            }

        } catch (Exception e) {
            System.err.println("Error reading company_info.csv: " + e.getMessage());
        }
    }

    /**
     * Get info for a single company
     */
    public static CompanyInfo getCompany(String symbol) {
        return companies.get(symbol);
    }

    /**
     * Get all companies as Map
     */
    public static Map<String, CompanyInfo> getCompanyMap() {
        return companies;
    }

    /**
     * Get all companies as List (for dropdowns)
     */
    public static List<CompanyInfo> getAllCompanies() {
        return new ArrayList<>(companies.values());
    }

    /**
     * Reload data (useful after admin adds new company)
     */
    public static void reload() {
        loadCompanies();
    }
    
    /**
    * Get all company symbols by sector
    */
    public static List<String> getSymbolsBySector(String sector) {

        List<String> symbols = new ArrayList<>();

        if (sector == null) return symbols;

        companies.forEach((symbol, info) -> {
            if (info.sector != null &&
                info.sector.equalsIgnoreCase(sector)) {
                symbols.add(symbol);
            }
        });

        return symbols;
    }
}