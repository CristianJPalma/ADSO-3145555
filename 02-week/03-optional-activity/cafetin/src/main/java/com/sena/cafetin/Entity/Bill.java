package com.sena.cafetin.Entity;

import java.time.LocalDateTime;
import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;

@Entity(name = "bill")
public class Bill {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "date")
    private LocalDateTime date;
    
    @Column(name = "total")
    private Double total;
    
    @ManyToOne
    @JoinColumn(name = "id_user")
    private Users users;

    @OneToMany(mappedBy = "bill")
    private List<BillDetail> billDetails;

    
    public Bill() {
    }

    public Bill(int id, LocalDateTime date, Double total, Users user, List<BillDetail> bill_details) {
        this.id = id;
        this.date = date;
        this.total = total;
        this.users = users;
        this.billDetails = billDetails;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public LocalDateTime getDate() {
        return date;
    }

    public void setDate(LocalDateTime date) {
        this.date = date;
    }

    public Double getTotal() {
        return total;
    }

    public void setTotal(Double total) {
        this.total = total;
    }

    public Users getUser() {
        return users;
    }

    public void setUser(Users user) {
        this.users = user;
    }

    public List<BillDetail> getBill_details() {
        return billDetails;
    }

    public void setBill_details(List<BillDetail> bill_details) {
        this.billDetails = bill_details;
    }


    
}
