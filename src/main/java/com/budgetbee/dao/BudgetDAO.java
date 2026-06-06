package com.budgetbee.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.budgetbee.config.DBConnection;

public class BudgetDAO {

    public double getCurrentBudget() {

        double budget = 0;

        try {

            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(
                    "SELECT monthly_budget FROM budget ORDER BY budget_id DESC LIMIT 1");

            ResultSet rs =
                    ps.executeQuery();

            if(rs.next()) {

                budget =
                        rs.getDouble("monthly_budget");
            }

        } catch(Exception e) {

            e.printStackTrace();
        }

        System.out.println(
                "Budget From DB = " + budget);

        return budget;
    }

    public boolean saveBudget(double budgetAmount) {

        boolean status = false;

        try {

            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(
                    "INSERT INTO budget(user_id, monthly_budget, month_name, year_value) VALUES(?,?,?,?)");

            ps.setInt(1, 1);

            ps.setDouble(2, budgetAmount);

            ps.setString(
                    3,
                    java.time.LocalDate.now()
                    .getMonth()
                    .toString());

            ps.setInt(
                    4,
                    java.time.LocalDate.now()
                    .getYear());

            status =
                    ps.executeUpdate() > 0;

            System.out.println(
                    "Budget Saved = " + budgetAmount);

        } catch(Exception e) {

            e.printStackTrace();
        }

        return status;
    }
}