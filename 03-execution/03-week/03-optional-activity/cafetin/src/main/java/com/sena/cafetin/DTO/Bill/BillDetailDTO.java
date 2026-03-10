package com.sena.cafetin.DTO.Bill;

public class BillDetailDTO {

    private Integer quality;
    private Double price;
    private Double subtotal;
    private Integer billId;
    private Integer productId;

    public BillDetailDTO() {
    }

    public BillDetailDTO(Integer quality, Double price, Double subtotal, Integer billId, Integer productId) {
        this.quality = quality;
        this.price = price;
        this.subtotal = subtotal;
        this.billId = billId;
        this.productId = productId;
    }

    public Integer getQuality() {
        return quality;
    }

    public void setQuality(Integer quality) {
        this.quality = quality;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(Double subtotal) {
        this.subtotal = subtotal;
    }

    public Integer getBillId() {
        return billId;
    }

    public void setBillId(Integer billId) {
        this.billId = billId;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }
}
