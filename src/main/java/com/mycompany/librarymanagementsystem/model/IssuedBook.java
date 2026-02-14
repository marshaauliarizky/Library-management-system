/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.librarymanagementsystem.model;

/**
 *
 * @author DMC_Studio
 */
import java.sql.Timestamp;

public class IssuedBook {
    private int id;
    private int bookId;
    private int memberId;
    private Timestamp dateIssued;
    private Timestamp dueDate;
    private Timestamp dateReturned;
    private String returnStatus;
    private String extensionStatus;
    
    // Additional fields for joined data
    private String bookTitle;
    private String memberName;
    
    // Constructors
    public IssuedBook() {
    }
    
    public IssuedBook(int id, int bookId, int memberId, Timestamp dateIssued, 
                     Timestamp dueDate, Timestamp dateReturned, 
                     String returnStatus, String extensionStatus) {
        this.id = id;
        this.bookId = bookId;
        this.memberId = memberId;
        this.dateIssued = dateIssued;
        this.dueDate = dueDate;
        this.dateReturned = dateReturned;
        this.returnStatus = returnStatus;
        this.extensionStatus = extensionStatus;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getBookId() {
        return bookId;
    }
    
    public void setBookId(int bookId) {
        this.bookId = bookId;
    }
    
    public int getMemberId() {
        return memberId;
    }
    
    public void setMemberId(int memberId) {
        this.memberId = memberId;
    }
    
    public Timestamp getDateIssued() {
        return dateIssued;
    }
    
    public void setDateIssued(Timestamp dateIssued) {
        this.dateIssued = dateIssued;
    }
    
    public Timestamp getDueDate() {
        return dueDate;
    }
    
    public void setDueDate(Timestamp dueDate) {
        this.dueDate = dueDate;
    }
    
    public Timestamp getDateReturned() {
        return dateReturned;
    }
    
    public void setDateReturned(Timestamp dateReturned) {
        this.dateReturned = dateReturned;
    }
    
    public String getReturnStatus() {
        return returnStatus;
    }
    
    public void setReturnStatus(String returnStatus) {
        this.returnStatus = returnStatus;
    }
    
    public String getExtensionStatus() {
        return extensionStatus;
    }
    
    public void setExtensionStatus(String extensionStatus) {
        this.extensionStatus = extensionStatus;
    }
    
    public String getBookTitle() {
        return bookTitle;
    }
    
    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }
    
    public String getMemberName() {
        return memberName;
    }
    
    public void setMemberName(String memberName) {
        this.memberName = memberName;
    }
}
