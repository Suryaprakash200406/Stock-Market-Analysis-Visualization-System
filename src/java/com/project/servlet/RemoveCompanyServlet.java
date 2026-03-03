package com.project.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import java.util.*;

public class RemoveCompanyServlet extends HttpServlet {

    private static final String BASE_PATH = "C:\\Users\\ELCOT\\Documents\\NetBeansProjects\\MyFirstServletProject\\data";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String symbol = request.getParameter("symbol").trim().toUpperCase();

        File infoFile = new File(BASE_PATH, "company_info.csv");
        if(!infoFile.exists()){
            request.setAttribute("message", "company_info.csv not found!");
            request.setAttribute("messageType","error");
            request.getRequestDispatcher("remove_company.jsp").forward(request,response);
            return;
        }

        List<String> allLines = new ArrayList<>();
        String companyName = null;
        String sectorName = null;

        try(BufferedReader br = new BufferedReader(new FileReader(infoFile))){
            String line;
            while((line = br.readLine())!=null){
                String[] arr = line.split(",",4);
                if(arr.length>=3){
                    if(arr[0].trim().equalsIgnoreCase(symbol)){
                        companyName = arr[1].trim();
                        sectorName = arr[2].trim();
                        // skip this line (deleting)
                        continue;
                    }
                }
                allLines.add(line);
            }
        }

        if(companyName==null){
            request.setAttribute("message", "Company not found!");
            request.setAttribute("messageType","error");
            request.getRequestDispatcher("remove_company.jsp").forward(request,response);
            return;
        }

        // 1. Delete Raw folder recursively
        Path rawFolder = Paths.get(BASE_PATH,"Raw", symbol);
        deleteDirectoryRecursively(rawFolder);

        // 2. Delete Clean CSV file
        Path cleanFile = Paths.get(BASE_PATH,"Clean", sectorName, symbol+".csv");
        Files.deleteIfExists(cleanFile);

        // 3. Rewrite company_info.csv without the deleted line
        try(BufferedWriter bw = new BufferedWriter(new FileWriter(infoFile,false))){
            for(String l: allLines){
                bw.write(l);
                bw.newLine();
            }
            bw.flush();
        }

        String message = companyName + " (" + symbol + ") deleted successfully from " + sectorName + ".";
        request.setAttribute("message", message);
        request.setAttribute("messageType","success");

        request.getRequestDispatcher("remove_company.jsp").forward(request,response);
    }

    private void deleteDirectoryRecursively(Path path) throws IOException{
        if(Files.exists(path)){
            Files.walk(path)
                .sorted(Comparator.reverseOrder())
                .map(Path::toFile)
                .forEach(File::delete);
        }
    }
}