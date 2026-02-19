package com.project.servlet;

import com.project.model.ViewExportResult;
import com.project.service.StockAnalyzerService;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public class ViewExportServlet extends HttpServlet {

    private final StockAnalyzerService service =
            new StockAnalyzerService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String symbol = request.getParameter("symbol");
        String range = request.getParameter("range");
        String fromStr = request.getParameter("from");
        String toStr = request.getParameter("to");
        String download = request.getParameter("download");

        if (symbol == null || symbol.isEmpty()) {
            response.sendError(400, "Symbol required");
            return;
        }

        try {

            // ===== Default Range =====
            if ((range == null || range.isEmpty())
                    && (fromStr == null || fromStr.isEmpty())) {

                range = "1M";
            }

            // ===== Get first & last available dates =====
            LocalDate firstDate = service.getFirstRecordDate(symbol);
            LocalDate lastDate = service.getLastRecordDate(symbol);

            List<Map<String, String>> records;

            LocalDate from = null;
            LocalDate to = null;

            // ===== Custom Range =====
            if (fromStr != null && !fromStr.isEmpty()
                    && toStr != null && !toStr.isEmpty()) {

                from = LocalDate.parse(fromStr);
                to = LocalDate.parse(toStr);

                records = service.getRecordsBetweenDates(
                        symbol, from, to);

                range = ""; // Clear range selection
            }
            // ===== Predefined Range =====
            else {
                records = service.getRecordsByRange(symbol, range);
            }

            // =================================================
            // DOWNLOAD MODE
            // =================================================
            if ("true".equals(download)) {

                response.setContentType("text/csv");
                response.setHeader("Content-Disposition",
                        "attachment; filename=\"" + symbol + "_data.csv\"");

                PrintWriter out = response.getWriter();

                out.println("Date,Open,High,Low,Close,Volume");

                for (Map<String, String> row : records) {
                    out.println(
                            row.get("date") + "," +
                            row.get("open") + "," +
                            row.get("high") + "," +
                            row.get("low") + "," +
                            row.get("close") + "," +
                            row.get("volume")
                    );
                }

                return;
            }

            // =================================================
            // VIEW MODE
            // =================================================
            ViewExportResult result = new ViewExportResult(
                    records,
                    firstDate,
                    lastDate,
                    range,
                    from,
                    to
            );

            request.setAttribute("result", result);
            request.setAttribute("symbol", symbol);

            request.getRequestDispatcher("/view_export.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
