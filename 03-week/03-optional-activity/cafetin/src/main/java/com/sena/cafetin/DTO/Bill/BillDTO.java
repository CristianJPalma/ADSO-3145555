package com.sena.cafetin.DTO.Bill;

import java.time.LocalDateTime;

public class BillDTO {

    private LocalDateTime date;
    private Double total;
    private Integer userId;

    public BillDTO() {
    }

    public BillDTO(LocalDateTime date, Double total, Integer userId) {
        this.date = date;
        this.total = total;
        this.userId = userId;
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

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }
}
