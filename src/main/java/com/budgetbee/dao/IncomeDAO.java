package com.budgetbee.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

import com.budgetbee.config.DBConnection;
import com.budgetbee.model.Income;

public class IncomeDAO {

    public boolean addIncome(Income income) {
        String sql = "INSERT INTO income(user_id, amount, source, income_date, description) VALUES(?,?,?,?,?)";
        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, income.getUserId());
            ps.setDouble(2, income.getAmount());
            ps.setString(3, income.getSource());
            ps.setString(4, income.getIncomeDate());
            ps.setString(5, income.getDescription());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Income> getAllIncome() {
        List<Income> incomeList = new ArrayList<>();
        String sql = "SELECT * FROM income ORDER BY income_id DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Income income = new Income();
                income.setIncomeId(rs.getInt("income_id"));
                income.setUserId(rs.getInt("user_id"));
                income.setAmount(rs.getDouble("amount"));
                income.setSource(rs.getString("source"));
                income.setIncomeDate(rs.getString("income_date"));
                income.setDescription(rs.getString("description"));
                incomeList.add(income);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return incomeList;
    }

    public List<Income> searchIncome(
            String source, String incomeDate, String amount) {
        List<Income> incomeList = new ArrayList<>();
        String sql = "SELECT * FROM income WHERE 1=1";
        if (source != null && !source.isEmpty())
            sql += " AND source LIKE ?";
        if (incomeDate != null && !incomeDate.isEmpty())
            sql += " AND income_date = ?";
        if (amount != null && !amount.isEmpty())
            sql += " AND amount = ?";
        sql += " ORDER BY income_id DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            int index = 1;
            if (source != null && !source.isEmpty())
                ps.setString(index++, "%" + source + "%");
            if (incomeDate != null && !incomeDate.isEmpty())
                ps.setString(index++, incomeDate);
            if (amount != null && !amount.isEmpty())
                ps.setDouble(index++, Double.parseDouble(amount));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Income income = new Income();
                income.setIncomeId(rs.getInt("income_id"));
                income.setUserId(rs.getInt("user_id"));
                income.setAmount(rs.getDouble("amount"));
                income.setSource(rs.getString("source"));
                income.setIncomeDate(rs.getString("income_date"));
                income.setDescription(rs.getString("description"));
                incomeList.add(income);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return incomeList;
    }

    public boolean deleteIncome(int incomeId) {
        String sql = "DELETE FROM income WHERE income_id = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, incomeId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public double getTotalIncome() {
        double totalIncome = 0;
        String sql = "SELECT SUM(amount) AS total FROM income";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) totalIncome = rs.getDouble("total");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return totalIncome;
    }

    public List<Double> getDailyIncomeByMonth(int month, int year) {
        List<Double> dailyIncome = new ArrayList<>();
        for (int i = 0; i < 31; i++) dailyIncome.add(0.0);
        String sql =
            "SELECT DAY(income_date) day_no, SUM(amount) total " +
            "FROM income WHERE MONTH(income_date)=? " +
            "AND YEAR(income_date)=? " +
            "GROUP BY DAY(income_date)";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, month);
            ps.setInt(2, year);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int day = rs.getInt("day_no");
                double amount = rs.getDouble("total");
                dailyIncome.set(day - 1, amount);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dailyIncome;
    }

    public List<Double> getLast7DaysIncome() {
        List<Double> data = new ArrayList<>();
        for (int i = 0; i < 7; i++) data.add(0.0);
        String sql =
            "SELECT DATE(income_date) d, SUM(amount) total " +
            "FROM income " +
            "WHERE income_date >= CURDATE() - INTERVAL 6 DAY " +
            "GROUP BY DATE(income_date) " +
            "ORDER BY DATE(income_date)";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                java.sql.Date date = rs.getDate("d");
                double amount = rs.getDouble("total");
                long diff = ChronoUnit.DAYS.between(date.toLocalDate(), LocalDate.now());
                int index = 6 - (int) diff;
                if (index >= 0 && index < 7)
                    data.set(index, amount);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return data;
    }

    public List<Double> getIncomeByDateRange(
            LocalDate startDate, LocalDate endDate) {

        long days = ChronoUnit.DAYS.between(startDate, endDate) + 1;
        List<Double> data = new ArrayList<>();
        for (int i = 0; i < days; i++) data.add(0.0);

        String sql =
            "SELECT income_date d, SUM(amount) total " +
            "FROM income " +
            "WHERE income_date >= ? AND income_date <= ? " +
            "GROUP BY income_date " +
            "ORDER BY income_date";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, startDate.toString());
            ps.setString(2, endDate.toString());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                java.sql.Date date = rs.getDate("d");
                double amount = rs.getDouble("total");
                long diff = ChronoUnit.DAYS.between(startDate, date.toLocalDate());
                int index = (int) diff;
                if (index >= 0 && index < data.size())
                    data.set(index, amount);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return data;
    }

    public List<Income> getLatestIncome(int limit) {
        List<Income> list = new ArrayList<>();
        String sql =
            "SELECT * FROM income ORDER BY income_id DESC LIMIT ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Income income = new Income();
                income.setIncomeId(rs.getInt("income_id"));
                income.setUserId(rs.getInt("user_id"));
                income.setAmount(rs.getDouble("amount"));
                income.setSource(rs.getString("source"));
                income.setIncomeDate(rs.getString("income_date"));
                income.setDescription(rs.getString("description"));
                list.add(income);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Income getIncomeById(int incomeId) {
        Income income = null;
        String sql = "SELECT * FROM income WHERE income_id=?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, incomeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                income = new Income();
                income.setIncomeId(rs.getInt("income_id"));
                income.setUserId(rs.getInt("user_id"));
                income.setAmount(rs.getDouble("amount"));
                income.setSource(rs.getString("source"));
                income.setIncomeDate(rs.getString("income_date"));
                income.setDescription(rs.getString("description"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return income;
    }

    public boolean updateIncome(Income income) {
        String sql =
            "UPDATE income SET amount=?, source=?, " +
            "income_date=?, description=? WHERE income_id=?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setDouble(1, income.getAmount());
            ps.setString(2, income.getSource());
            ps.setString(3, income.getIncomeDate());
            ps.setString(4, income.getDescription());
            ps.setInt(5, income.getIncomeId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public double getMonthlyTotal(int month, int year) {
        double total = 0;
        String sql =
            "SELECT COALESCE(SUM(amount), 0) AS total " +
            "FROM income " +
            "WHERE MONTH(income_date) = ? " +
            "AND YEAR(income_date) = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, month);
            ps.setInt(2, year);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) total = rs.getDouble("total");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    public List<Income> getLatestIncomeByMonth(
            int limit, int month, int year) {
        List<Income> list = new ArrayList<>();
        String sql =
            "SELECT * FROM income " +
            "WHERE MONTH(income_date) = ? " +
            "AND YEAR(income_date) = ? " +
            "ORDER BY income_id DESC LIMIT ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, month);
            ps.setInt(2, year);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Income income = new Income();
                income.setIncomeId(rs.getInt("income_id"));
                income.setUserId(rs.getInt("user_id"));
                income.setAmount(rs.getDouble("amount"));
                income.setSource(rs.getString("source"));
                income.setIncomeDate(rs.getString("income_date"));
                income.setDescription(rs.getString("description"));
                list.add(income);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public double getTotalIncomeByDateRange(LocalDate startDate, LocalDate endDate) {
        double total = 0;
        String sql = "SELECT COALESCE(SUM(amount), 0) AS total FROM income " +
                     "WHERE income_date >= ? AND income_date <= ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, startDate.toString());
            ps.setString(2, endDate.toString());
            System.out.println("[INCOME] Query: " + sql);
            System.out.println("[INCOME] Range: " + startDate + " to " + endDate);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getDouble("total");
                System.out.println("[INCOME] Total: " + total);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    public List<Double> getDailyIncomeByDateRange(LocalDate startDate, LocalDate endDate) {
        List<Double> dailyData = new ArrayList<>();
        String sql = "SELECT income_date d, SUM(amount) total FROM income " +
                     "WHERE income_date >= ? AND income_date <= ? " +
                     "GROUP BY income_date ORDER BY income_date";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, startDate.toString());
            ps.setString(2, endDate.toString());
            
            ResultSet rs = ps.executeQuery();
            int count = 0;
            while (rs.next()) {
                dailyData.add(rs.getDouble("total"));
                count++;
            }
            System.out.println("[INCOME] Daily records: " + count);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dailyData;
    }
}
