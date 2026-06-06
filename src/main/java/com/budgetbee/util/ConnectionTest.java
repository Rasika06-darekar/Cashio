package com.budgetbee.util;

import java.sql.Connection;
import com.budgetbee.config.DBConnection;

public class ConnectionTest {

    public static void main(String[] args) {

        Connection conn = DBConnection.getConnection();

        if (conn != null) {
            System.out.println("Database Connected");
        } else {
            System.out.println("Connection Failed");
        }
    }
}