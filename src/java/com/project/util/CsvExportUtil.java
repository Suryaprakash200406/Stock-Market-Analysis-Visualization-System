package com.project.util;

import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

public class CsvExportUtil {

    public static void exportToCsv(List<Map<String, String>> data,
                                   String symbol,
                                   HttpServletResponse response) throws Exception {

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition",
                "attachment; filename=" + symbol + "_data.csv");

        PrintWriter writer = response.getWriter();

        writer.println("Date,Open,High,Low,Close,Volume");

        for (Map<String, String> row : data) {
            writer.println(
                    row.get("date") + "," +
                    row.get("open") + "," +
                    row.get("high") + "," +
                    row.get("low") + "," +
                    row.get("close") + "," +
                    row.get("volume")
            );
        }

        writer.flush();
        writer.close();
    }
}
