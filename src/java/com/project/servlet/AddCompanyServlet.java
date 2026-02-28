package com.project.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import java.util.Collection;

@MultipartConfig
public class AddCompanyServlet extends HttpServlet {

    private static final String BASE_PATH =
            "C:\\Users\\ELCOT\\Documents\\NetBeansProjects\\MyFirstServletProject\\data";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String symbol = request.getParameter("symbol").trim().toUpperCase();
        String name = request.getParameter("name").trim();
        String sector = request.getParameter("sector");
        String description = request.getParameter("description").trim();

        // ---------- 1. Append to company_info.csv ----------

        File infoFile = new File(BASE_PATH, "company_info.csv");

        // Ensure file exists
        if (!infoFile.exists()) {
            infoFile.getParentFile().mkdirs();
            infoFile.createNewFile();
        }

        // Debug log (check Tomcat console)
           System.out.println("Updating company_info.csv at: "
                + infoFile.getAbsolutePath());

        try (BufferedWriter bw =
                     new BufferedWriter(new FileWriter(infoFile, true))) {

            bw.write(symbol + "," + name + "," + sector + "," + description);
            bw.newLine();
            bw.flush();
        }

        // ---------- 2. Create Raw/SYMBOL folder ----------

        Path companyRawDir = Paths.get(BASE_PATH, "Raw", symbol);

        if (!Files.exists(companyRawDir)) {
            Files.createDirectories(companyRawDir);
        }

        // ---------- 3. Save uploaded CSV files ----------

        Collection<Part> parts = request.getParts();

        for (Part part : parts) {

            if ("csvFiles".equals(part.getName()) && part.getSize() > 0) {

                String fileName = Paths.get(part.getSubmittedFileName())
                                       .getFileName().toString();

                if (!fileName.toLowerCase().endsWith(".csv")) {
                    continue; // skip non-csv
                }

                Path filePath = companyRawDir.resolve(fileName);

                part.write(filePath.toString());
            }
        }

        // ---------- Success message ----------

        request.setAttribute("success", "Company added successfully!");
        request.getRequestDispatcher("add_company.jsp")
               .forward(request, response);
    }
}