package com.project.util;

import java.util.HashMap;
import java.util.Map;

/*
 * This class stores BASIC company information.
 * It does NOT read CSV files.
 * 
 * Easy to extend:
 * Just add a new entry to the map when a new company is added.
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

    private static final Map<String, CompanyInfo> companies = new HashMap<>();

    static {
        // TCS
        companies.put("TCS",
            new CompanyInfo(
                "Tata Consultancy Services",
                "IT Services",
                "India’s largest IT services company providing consulting and software solutions."
            )
        );

        // INFY
        companies.put("INFY",
            new CompanyInfo(
                "Infosys",
                "IT Services",
                "Global leader in digital services and consulting."
            )
        );
    }

    public static CompanyInfo getCompany(String symbol) {
        return companies.get(symbol);
    }
}
