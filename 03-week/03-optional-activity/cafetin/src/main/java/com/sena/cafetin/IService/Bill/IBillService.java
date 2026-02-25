package com.sena.cafetin.IService.Bill;

import java.util.List;

import com.sena.cafetin.DTO.Bill.BillDTO;
import com.sena.cafetin.Entity.Bill.Bill;

public interface IBillService {

	List<Bill> getAllBill();

	Bill saveBill(BillDTO bill);

	Bill updateBill(Integer id, BillDTO bill);

	void deleteBill(Integer id);

	Bill getBillById(Integer id);

}
