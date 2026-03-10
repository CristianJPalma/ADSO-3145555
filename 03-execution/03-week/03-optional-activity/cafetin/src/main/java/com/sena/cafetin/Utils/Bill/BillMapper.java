package com.sena.cafetin.Utils.Bill;

import com.sena.cafetin.DTO.Bill.BillDTO;
import com.sena.cafetin.Entity.Bill.Bill;
import com.sena.cafetin.Entity.Security.Users;

public class BillMapper {

    public static Bill toEntity(BillDTO dto, Users user) {
        Bill bill = new Bill();
        bill.setDate(dto.getDate());
        bill.setTotal(dto.getTotal());
        bill.setUser(user);
        return bill;
    }

    public static Bill updateEntity(Bill bill, BillDTO dto, Users user) {
        bill.setDate(dto.getDate());
        bill.setTotal(dto.getTotal());
        bill.setUser(user);
        return bill;
    }
}
