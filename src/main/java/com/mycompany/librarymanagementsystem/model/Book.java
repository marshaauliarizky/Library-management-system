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

public class Book {
    private int id;
    private String title;
    private String synopsis;
    private String author;
    private String isbn;
    private int publicationYear;
    private String publisher;
    private int availableCopies;
    private int totalCopies;
    private Timestamp addedDate;
    private String status;
    
    // Constructors
    public Book() {
    }
    
    public Book(int id, String title, String synopsis, String author, String isbn, int publicationYear, 
                String publisher, int availableCopies, int totalCopies, 
                Timestamp addedDate, String status) {
        this.id = id;
        this.title = title;
        this.synopsis = synopsis;
        this.author = author;
        this.isbn = isbn;
        this.publicationYear = publicationYear;
        this.publisher = publisher;
        this.availableCopies = availableCopies;
        this.totalCopies = totalCopies;
        this.addedDate = addedDate;
        this.status = status;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getSynopsis() {
    return synopsis;
    }

    public void setSynopsis(String synopsis) {
        this.synopsis = synopsis;
    }

    public String getAuthor() {
        return author;
    }
    
    public void setAuthor(String author) {
        this.author = author;
    }
    
    public String getIsbn() {
        return isbn;
    }
    
    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }
    
    public int getPublicationYear() {
        return publicationYear;
    }
    
    public void setPublicationYear(int publicationYear) {
        this.publicationYear = publicationYear;
    }
    
    public String getPublisher() {
        return publisher;
    }
    
    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }
    
    public int getAvailableCopies() {
        return availableCopies;
    }
    
    public void setAvailableCopies(int availableCopies) {
        this.availableCopies = availableCopies;
    }
    
    public int getTotalCopies() {
        return totalCopies;
    }
    
    public void setTotalCopies(int totalCopies) {
        this.totalCopies = totalCopies;
    }
    
    public Timestamp getAddedDate() {
        return addedDate;
    }
    
    public void setAddedDate(Timestamp addedDate) {
        this.addedDate = addedDate;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
}