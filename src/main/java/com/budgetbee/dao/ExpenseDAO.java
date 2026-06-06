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
import com.budgetbee.model.Expense;

public class ExpenseDAO {

    public boolean addExpense(Expense expense) {
        String sql =
            "INSERT INTO expenses(user_id, amount, category, expense_date, description) VALUES(?,?,?,?,?)";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, expense.getUserId());
            ps.setDouble(2, expense.getAmount());
            ps.setString(3, expense.getCategory());
            ps.setString(4, expense.getExpenseDate());
            ps.setString(5, expense.getDescription());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Expense> getAllExpenses() {
        List<Expense> expenseList = new ArrayList<>();
        String sql = "SELECT * FROM expenses ORDER BY expense_id DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Expense expense = new Expense();
                expense.setExpenseId(rs.getInt("expense_id"));
                expense.setUserId(rs.getInt("user_id"));
                expense.setAmount(rs.getDouble("amount"));
                expense.setCategory(rs.getString("category"));
                expense.setExpenseDate(rs.getString("expense_date"));
                expense.setDescription(rs.getString("description"));
                expenseList.add(expense);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return expenseList;
    }

    public List<Expense> searchExpense(String category, String expenseDate, String amount) {
        List<Expense> expenseList = new ArrayList<>();
        String sql = "SELECT * FROM expenses WHERE 1=1";
        if (category != null && !category.isEmpty()) sql += " AND category LIKE ?";
        if (expenseDate != null && !expenseDate.isEmpty()) sql += " AND expense_date = ?";
        if (amount != null && !amount.isEmpty()) sql += " AND amount = ?";
        sql += " ORDER BY expense_id DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            int index = 1;
            if (category != null && !category.isEmpty()) ps.setString(index++, "%" + category + "%");
            if (expenseDate != null && !expenseDate.isEmpty()) ps.setString(index++, expenseDate);
            if (amount != null && !amount.isEmpty()) ps.setDouble(index++, Double.parseDouble(amount));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Expense expense = new Expense();
                expense.setExpenseId(rs.getInt("expense_id"));
                expense.setUserId(rs.getInt("user_id"));
                expense.setAmount(rs.getDouble("amount"));
                expense.setCategory(rs.getString("category"));
                expense.setExpenseDate(rs.getString("expense_date"));
                expense.setDescription(rs.getString("description"));
                expenseList.add(expense);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return expenseList;
    }

    public boolean deleteExpense(int expenseId) {
        String sql = "DELETE FROM expenses WHERE expense_id = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, expenseId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public double getTotalExpense() {
        double totalExpense = 0;
        String sql = "SELECT SUM(amount) AS total FROM expenses";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) totalExpense = rs.getDouble("total");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return totalExpense;
    }

    public List<Double> getDailyExpenseByMonth(int month, int year) {
        List<Double> dailyExpenses = new ArrayList<>();
        for (int i = 0; i < 31; i++) dailyExpenses.add(0.0);
        String sql =
            "SELECT DAY(expense_date) day_no, SUM(amount) total " +
            "FROM expenses WHERE MONTH(expense_date)=? AND YEAR(expense_date)=? " +
            "GROUP BY DAY(expense_date)";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, month);
            ps.setInt(2, year);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int day = rs.getInt("day_no");
                double amount = rs.getDouble("total");
                dailyExpenses.set(day - 1, amount);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dailyExpenses;
    }

    public List<Double> getLast7DaysExpense() {
        List<Double> data = new ArrayList<>();
        for (int i = 0; i < 7; i++) data.add(0.0);
        String sql =
            "SELECT expense_date d, SUM(amount) total " +
            "FROM expenses " +
            "WHERE expense_date >= CURDATE() - INTERVAL 6 DAY " +
            "GROUP BY expense_date ORDER BY expense_date";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                java.sql.Date date = rs.getDate("d");
                double amount = rs.getDouble("total");
                long diff = ChronoUnit.DAYS.between(date.toLocalDate(), LocalDate.now());
                int index = 6 - (int) diff;
                if (index >= 0 && index < 7) data.set(index, amount);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("Expense Data Final = " + data);
        return data;
    }

    public List<Double> getExpenseByDateRange(
            LocalDate startDate, LocalDate endDate) {

        long days = ChronoUnit.DAYS.between(startDate, endDate) + 1;
        List<Double> data = new ArrayList<>();
        for (int i = 0; i < days; i++) data.add(0.0);

        String sql =
            "SELECT expense_date d, SUM(amount) total " +
            "FROM expenses " +
            "WHERE expense_date >= ? AND expense_date <= ? " +
            "GROUP BY expense_date ORDER BY expense_date";

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

    public List<Expense> getLatestExpense(int limit) {
        List<Expense> list = new ArrayList<>();
        String sql = "SELECT * FROM expenses ORDER BY expense_id DESC LIMIT ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Expense expense = new Expense();
                expense.setExpenseId(rs.getInt("expense_id"));
                expense.setUserId(rs.getInt("user_id"));
                expense.setAmount(rs.getDouble("amount"));
                expense.setCategory(rs.getString("category"));
                expense.setExpenseDate(rs.getString("expense_date"));
                expense.setDescription(rs.getString("description"));
                list.add(expense);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Expense getExpenseById(int expenseId) {
        Expense expense = null;
        String sql = "SELECT * FROM expenses WHERE expense_id=?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, expenseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                expense = new Expense();
                expense.setExpenseId(rs.getInt("expense_id"));
                expense.setAmount(rs.getDouble("amount"));
                expense.setCategory(rs.getString("category"));
                expense.setExpenseDate(rs.getString("expense_date"));
                expense.setDescription(rs.getString("description"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return expense;
    }

    public boolean updateExpense(Expense expense) {
        String sql =
            "UPDATE expenses SET amount=?, category=?, expense_date=?, description=? WHERE expense_id=?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setDouble(1, expense.getAmount());
            ps.setString(2, expense.getCategory());
            ps.setString(3, expense.getExpenseDate());
            ps.setString(4, expense.getDescription());
            ps.setInt(5, expense.getExpenseId());
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
            "FROM expenses " +
            "WHERE MONTH(expense_date) = ? " +
            "AND YEAR(expense_date) = ?";
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

    public List<Expense> getLatestExpenseByMonth(
            int limit, int month, int year) {
        List<Expense> list = new ArrayList<>();
        String sql =
            "SELECT * FROM expenses " +
            "WHERE MONTH(expense_date) = ? " +
            "AND YEAR(expense_date) = ? " +
            "ORDER BY expense_id DESC LIMIT ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, month);
            ps.setInt(2, year);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Expense expense = new Expense();
                expense.setExpenseId(rs.getInt("expense_id"));
                expense.setUserId(rs.getInt("user_id"));
                expense.setAmount(rs.getDouble("amount"));
                expense.setCategory(rs.getString("category"));
                expense.setExpenseDate(rs.getString("expense_date"));
                expense.setDescription(rs.getString("description"));
                list.add(expense);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public double getTotalExpenseByDateRange(LocalDate startDate, LocalDate endDate) {
        double total = 0;
        String sql = "SELECT COALESCE(SUM(amount), 0) AS total FROM expenses " +
                     "WHERE expense_date >= ? AND expense_date <= ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, startDate.toString());
            ps.setString(2, endDate.toString());
            System.out.println("[EXPENSE] Query: " + sql);
            System.out.println("[EXPENSE] Range: " + startDate + " to " + endDate);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getDouble("total");
                System.out.println("[EXPENSE] Total: " + total);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    public List<Double> getDailyExpenseByDateRange(LocalDate startDate, LocalDate endDate) {
        List<Double> dailyData = new ArrayList<>();
        String sql = "SELECT expense_date d, SUM(amount) total FROM expenses " +
                     "WHERE expense_date >= ? AND expense_date <= ? " +
                     "GROUP BY expense_date ORDER BY expense_date";
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
            System.out.println("[EXPENSE] Daily records: " + count);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dailyData;
    }
}
