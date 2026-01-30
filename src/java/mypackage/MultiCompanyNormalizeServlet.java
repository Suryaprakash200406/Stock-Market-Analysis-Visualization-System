package mypackage;

import com.project.api.NseApiFetcher;
import com.project.util.CsvNormalizerUtil;
import org.json.JSONObject;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;

@WebServlet("/normalizeAll")
public class MultiCompanyNormalizeServlet extends HttpServlet {

    private static final String RAW_PATH =
            "D:\\Actual_Company_Datasets\\Raw\\";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        File rawRoot = new File(RAW_PATH);
        File[] companyDirs = rawRoot.listFiles(File::isDirectory);

        if (companyDirs == null || companyDirs.length == 0) {
            req.setAttribute("msg", "No company data found to update");
            forwardToIndex(req, resp);
            return;
        }

        for (File companyDir : companyDirs) {

            String symbol = companyDir.getName();
            JSONObject json = null;

            // 🔹 TRY NSE fetch (optional)
            try {
                json = NseApiFetcher.fetch(symbol);
            } catch (Exception e) {
                System.err.println(
                        "NSE fetch failed for " + symbol + ": " + e.getMessage()
                );
            }

            // 🔹 ALWAYS update CSV (offline + optional online)
            try {
                CsvNormalizerUtil.processCompany(symbol, json);
            } catch (Exception e) {
                System.err.println(
                        "CSV update failed for " + symbol + ": " + e.getMessage()
                );
            }
        }

        // ✅ SUCCESS MESSAGE FOR SAME PAGE
        req.setAttribute(
                "msg",
                "All Company Data Updated Successfully"
        );

        forwardToIndex(req, resp);
    }

    // 🔹 Helper method for clean forwarding
    private void forwardToIndex(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws IOException {
        try {
            req.getRequestDispatcher("index.jsp")
               .forward(req, resp);
        } catch (Exception e) {
            throw new IOException(e);
        }
    }
}
