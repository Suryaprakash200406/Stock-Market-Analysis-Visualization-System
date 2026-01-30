package com.project.util; // same package as DBConnection

import java.sql.Connection;

public class TestDB {
    public static void main(String[] args) {
        try {
            Connection con = DBConnection.getConnection();
            if (con != null && !con.isClosed()) {
                System.out.println("Database connection SUCCESSFUL!");
            } else {
                System.out.println("Database connection FAILED!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error connecting to DB: " + e.getMessage());
        }
    }
}
