/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.librarymanagementsystem.util;

/**
 *
 * @author DMC_Studio
 */

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class for database connection
 */
public class DBConnection {
    private static final String JDBC_URL = "jdbc:mysql://localhost:3307/lmsoovp";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = ""; // Change as needed
    private static Connection connection = null;
    
    /**
     * Gets database connection
     * @return Connection object
     * @throws ClassNotFoundException if MySQL JDBC driver not found
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        if (connection == null || connection.isClosed()) {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
        }
        return connection;
    }
    
    /**
     * Closes the current database connection
     */
    public static void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            System.err.println("Error closing database connection: " + e.getMessage());
        }
    }
}