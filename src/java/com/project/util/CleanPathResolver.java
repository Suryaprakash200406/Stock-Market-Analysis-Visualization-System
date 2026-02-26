package com.project.util;

import java.io.File;

/**
 * Returns the absolute clean CSV path for a given company symbol
 * dynamically based on its sector.
 */
public class CleanPathResolver {

    private static final String BASE_PATH =
            "C:\\Users\\ELCOT\\Documents\\NetBeansProjects\\MyFirstServletProject\\data\\Clean";

    /**
     * Get clean CSV file path for a company symbol
     * Example: Clean/IT/TCS.csv
     */
    public static File getCleanFile(String symbol) {

        CompanyRegistry.CompanyInfo info = CompanyRegistry.getCompany(symbol);
        String sector = (info != null && info.sector != null && !info.sector.isEmpty())
                ? info.sector
                : "Others";

        File sectorDir = new File(BASE_PATH, sector);
        if (!sectorDir.exists()) {
            sectorDir.mkdirs();
        }

        return new File(sectorDir, symbol + ".csv");
    }
}