package com.sena.cafetin.IService;

import java.util.List;

import com.sena.cafetin.Entity.Bill;

public interface IBillService {

	List<Bill> getAllBill();

	Bill saveBill(Bill bill);

	void deleteBill(Integer id);

	Bill getBillById(Integer id);

}
