package com.budgetbee.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.budgetbee.config.DBConnection;
import com.budgetbee.model.User;

public class UserDAO {

    public boolean registerUser(User user) {

        String sql =
                "INSERT INTO users(full_name, username, email, phone, password) VALUES(?,?,?,?,?)";

        try {

            Connection conn = DBConnection.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getUsername());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getPassword());

            int rows = ps.executeUpdate();

            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Login validation
    public boolean validateUser(String email, String password) {

        String sql =
                "SELECT * FROM users WHERE email=? AND password=?";

        try {

            Connection conn = DBConnection.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    public boolean updateProfilePicture(
            String email,
            String imagePath) {

        boolean updated = false;

        try {

            Connection conn =
                    DBConnection.getConnection();

            String sql =
            "UPDATE users " +
            "SET profile_picture=? " +
            "WHERE email=?";

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setString(1, imagePath);
            ps.setString(2, email);

            updated =
                    ps.executeUpdate() > 0;

        } catch(Exception e) {
            e.printStackTrace();
        }

        return updated;
    }
    public String getProfilePicture(String email) {

        String picture = null;

        try {

            Connection conn =
                    DBConnection.getConnection();

            String sql =
                    "SELECT profile_picture FROM users WHERE email=?";

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setString(1, email);

            ResultSet rs =
                    ps.executeQuery();

            if(rs.next()) {

                picture =
                        rs.getString("profile_picture");
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        return picture;
    }
    public User getUserByEmail(String email) {

        User user = null;

        try {

            Connection conn = DBConnection.getConnection();

            String sql =
            "SELECT * FROM users WHERE email=?";

            PreparedStatement ps =
            conn.prepareStatement(sql);

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if(rs.next()) {

                user = new User();

                user.setFullName(
                rs.getString("full_name"));

                user.setUsername(
                rs.getString("username"));

                user.setEmail(
                rs.getString("email"));

                user.setPhone(
                rs.getString("phone"));
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        return user;
    }
    public boolean updateProfile(
            String email,
            String fullName,
            String username) {

        boolean updated = false;

        try {

            Connection conn =
                    DBConnection.getConnection();

            String sql =
            "UPDATE users SET full_name=?, username=? WHERE email=?";

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setString(1, fullName);
            ps.setString(2, username);
            ps.setString(3, email);

            updated = ps.executeUpdate() > 0;

        } catch(Exception e) {
            e.printStackTrace();
        }

        return updated;
    }
    public boolean updateEmail(
            String oldEmail,
            String newEmail) {

        boolean updated = false;

        try {

            Connection conn =
                    DBConnection.getConnection();

            String sql =
            "UPDATE users SET email=? WHERE email=?";

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setString(1, newEmail);
            ps.setString(2, oldEmail);

            updated =
                    ps.executeUpdate() > 0;

        } catch(Exception e) {
            e.printStackTrace();
        }

        return updated;
    }
    
    public boolean updatePhone(
            String email,
            String phone) {

        boolean updated = false;

        try {

            Connection conn =
                    DBConnection.getConnection();

            String sql =
            "UPDATE users SET phone=? WHERE email=?";

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setString(1, phone);
            ps.setString(2, email);

            updated =
                    ps.executeUpdate() > 0;

        } catch(Exception e) {
            e.printStackTrace();
        }

        return updated;
    }
    public String getPasswordByEmail(String email){

        String password = null;

        try{

            Connection conn =
                    DBConnection.getConnection();

            String sql =
            "SELECT password FROM users WHERE email=?";

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setString(1,email);

            ResultSet rs =
                    ps.executeQuery();

            if(rs.next()){

                password =
                        rs.getString("password");
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return password;
    }
    public boolean updatePassword(
            String email,
            String newPassword){

        boolean updated = false;

        try{

            Connection conn =
                    DBConnection.getConnection();

            String sql =
            "UPDATE users SET password=? WHERE email=?";

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setString(1,newPassword);
            ps.setString(2,email);

            updated =
                    ps.executeUpdate() > 0;

        }catch(Exception e){
            e.printStackTrace();
        }

        return updated;
    }
    public boolean emailExists(String email){

        boolean exists = false;

        try {

            Connection conn =
                    DBConnection.getConnection();

            String sql =
            "SELECT * FROM users WHERE email=?";

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setString(1,email);

            ResultSet rs =
                    ps.executeQuery();

            exists = rs.next();

        } catch(Exception e){
            e.printStackTrace();
        }

        return exists;
    }
    
}