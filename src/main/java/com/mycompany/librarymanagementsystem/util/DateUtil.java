/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.librarymanagementsystem.util;

/**
 *
 * @author DMC_Studio
 */
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * Utility class for date operations
 */
public class DateUtil {
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");
    
    /**
     * Convert string date to Timestamp
     * @param dateString Date string in yyyy-MM-dd format
     * @return Timestamp object
     * @throws ParseException if date format is invalid
     */
    public static Timestamp parseDate(String dateString) throws ParseException {
        Date date = DATE_FORMAT.parse(dateString);
        return new Timestamp(date.getTime());
    }
    
    /**
     * Format Timestamp to string date
     * @param timestamp Timestamp to format
     * @return Formatted date string (yyyy-MM-dd)
     */
    public static String formatDate(Timestamp timestamp) {
        if (timestamp == null) {
            return "";
        }
        return DATE_FORMAT.format(new Date(timestamp.getTime()));
    }
    
    /**
     * Calculate due date (default 14 days from now)
     * @return Timestamp for due date
     */
    public static Timestamp calculateDueDate() {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_MONTH, 14);
        return new Timestamp(calendar.getTimeInMillis());
    }
    
    /**
     * Calculate due date with custom days
     * @param days Number of days to add
     * @return Timestamp for due date
     */
    public static Timestamp calculateDueDate(int days) {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_MONTH, days);
        return new Timestamp(calendar.getTimeInMillis());
    }
    
    /**
     * Check if a date is overdue
     * @param dueDate Due date to check
     * @return true if overdue, false otherwise
     */
    public static boolean isOverdue(Timestamp dueDate) {
        return dueDate.before(new Timestamp(System.currentTimeMillis()));
    }
}

