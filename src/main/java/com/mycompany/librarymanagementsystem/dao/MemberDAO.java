/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.librarymanagementsystem.dao;

/**
 *
 * @author DMC_Studio
 */
import com.mycompany.librarymanagementsystem.util.DBConnection;
import com.mycompany.librarymanagementsystem.util.PasswordUtil;
import com.mycompany.librarymanagementsystem.model.Member;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MemberDAO {
    
    /**
     * Get all members
     * @return List of all members
     */
    public List<Member> getAllMembers() {
        List<Member> members = new ArrayList<>();
        String sql = "SELECT * FROM members ORDER BY id DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Member member = new Member();
                member.setId(rs.getInt("id"));
                member.setName(rs.getString("name"));
                member.setUsername(rs.getString("username"));
                member.setPassword(rs.getString("password"));
                member.setPhoneNumber(rs.getString("phone_number"));
                member.setRegisterDate(rs.getTimestamp("register_date"));
                member.setStatus(rs.getString("status"));
                members.add(member);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return members;
    }
    
    /**
     * Get a member by ID
     * @param id Member ID
     * @return Member object or null if not found
     */
    public Member getMemberById(int id) {
        String sql = "SELECT * FROM members WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Member member = new Member();
                    member.setId(rs.getInt("id"));
                    member.setName(rs.getString("name"));
                    member.setUsername(rs.getString("username"));
                    member.setPassword(rs.getString("password"));
                    member.setPhoneNumber(rs.getString("phone_number"));
                    member.setRegisterDate(rs.getTimestamp("register_date"));
                    member.setStatus(rs.getString("status"));
                    return member;
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get a member by username
     * @param username Member's username
     * @return Member object or null if not found
     */
    public Member getMemberByUsername(String username) {
        String sql = "SELECT * FROM members WHERE username = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Member member = new Member();
                    member.setId(rs.getInt("id"));
                    member.setName(rs.getString("name"));
                    member.setUsername(rs.getString("username"));
                    member.setPassword(rs.getString("password"));
                    member.setPhoneNumber(rs.getString("phone_number"));
                    member.setRegisterDate(rs.getTimestamp("register_date"));
                    member.setStatus(rs.getString("status"));
                    return member;
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Authenticate member login
     * @param username Username
     * @param password Password (not hashed)
     * @return Member object if authentication successful, null otherwise
     */
    public Member authenticateMember(String username, String password) {
        Member member = getMemberByUsername(username);
        
        if (member != null && PasswordUtil.verifyPassword(password, member.getPassword())) {
            return member;
        }
        
        return null;
    }
    
    /**
     * Add a new member
     * @param member Member object to add
     * @return true if successful, false otherwise
     */
    
    /**
 * Get active members (status = ACTIVE)
 * @return List of active members
 */
public List<Member> getActiveMembers() {
    List<Member> members = new ArrayList<>();
    String sql = "SELECT * FROM members WHERE status = 'ACTIVE' ORDER BY id DESC";
    
    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery(sql)) {
        
        while (rs.next()) {
            Member member = new Member();
            member.setId(rs.getInt("id"));
            member.setName(rs.getString("name"));
            member.setUsername(rs.getString("username"));
            member.setPassword(rs.getString("password"));
            member.setPhoneNumber(rs.getString("phone_number"));
            member.setRegisterDate(rs.getTimestamp("register_date"));
            member.setStatus(rs.getString("status"));
            members.add(member);
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    }
    
    return members;
}
    public boolean addMember(Member member) {
        String sql = "INSERT INTO members (name, username, password, phone_number, status) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, member.getName());
            stmt.setString(2, member.getUsername());
            // Hash the password before storing
            stmt.setString(3, PasswordUtil.hashPassword(member.getPassword()));
            stmt.setString(4, member.getPhoneNumber());
            stmt.setString(5, "ACTIVE");
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update a member
     * @param member Member object with updated values
     * @param updatePassword Whether to update the password
     * @return true if successful, false otherwise
     */
    public boolean updateMember(Member member, boolean updatePassword) {
        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("UPDATE members SET name = ?, username = ?, ");
        
        if (updatePassword) {
            sqlBuilder.append("password = ?, ");
        }
        
        sqlBuilder.append("phone_number = ?, status = ? WHERE id = ?");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sqlBuilder.toString())) {
            
            stmt.setString(1, member.getName());
            stmt.setString(2, member.getUsername());
            
            int paramIndex = 3;
            
            if (updatePassword) {
                stmt.setString(paramIndex++, PasswordUtil.hashPassword(member.getPassword()));
            }
            
            stmt.setString(paramIndex++, member.getPhoneNumber());
            stmt.setString(paramIndex++, member.getStatus());
            stmt.setInt(paramIndex, member.getId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete a member
     * @param id Member ID to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteMember(int id) {
        String sql = "DELETE FROM members WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Search members by name or username
     * @param keyword Search keyword
     * @return List of matching members
     */
    public List<Member> searchMembers(String keyword) {
        List<Member> members = new ArrayList<>();
        String sql = "SELECT * FROM members WHERE name LIKE ? OR username LIKE ? OR phone_number LIKE ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchTerm = "%" + keyword + "%";
            stmt.setString(1, searchTerm);
            stmt.setString(2, searchTerm);
            stmt.setString(3, searchTerm);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Member member = new Member();
                    member.setId(rs.getInt("id"));
                    member.setName(rs.getString("name"));
                    member.setUsername(rs.getString("username"));
                    member.setPassword(rs.getString("password"));
                    member.setPhoneNumber(rs.getString("phone_number"));
                    member.setRegisterDate(rs.getTimestamp("register_date"));
                    member.setStatus(rs.getString("status"));
                    members.add(member);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return members;
    }
    
    /**
     * Get total count of members
     * @return Total number of members
     */
    public int getTotalMembersCount() {
        String sql = "SELECT COUNT(*) FROM members";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
}
