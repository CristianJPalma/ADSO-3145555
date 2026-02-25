package com.sena.cafetin.Utils.Bill;

import com.sena.cafetin.DTO.Bill.BillDetailDTO;
import com.sena.cafetin.Entity.Bill.Bill;
import com.sena.cafetin.Entity.Bill.BillDetail;
import com.sena.cafetin.Entity.Inventory.Product;

public class BillDetailMapper {

    public static BillDetail toEntity(BillDetailDTO dto, Bill bill, Product product) {
        BillDetail detail = new BillDetail();
        detail.setQuality(dto.getQuality());
        detail.setPrice(dto.getPrice());
        detail.setSubtotal(dto.getSubtotal());
        detail.setBill(bill);
        detail.setProduct(product);
        return detail;
    }

    public static BillDetail updateEntity(BillDetail detail, BillDetailDTO dto, Bill bill, Product product) {
        detail.setQuality(dto.getQuality());
        detail.setPrice(dto.getPrice());
        detail.setSubtotal(dto.getSubtotal());
        detail.setBill(bill);
        detail.setProduct(product);
        return detail;
    }
}
