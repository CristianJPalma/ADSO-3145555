package com.sena.cafetin.IService.Bill;

import java.util.List;

import com.sena.cafetin.DTO.Bill.BillDetailDTO;
import com.sena.cafetin.Entity.Bill.BillDetail;

public interface IBillDetailService{

	List<BillDetail> getAllBillDetail();

	BillDetail saveBillDetail(BillDetailDTO billDetail);

	BillDetail updateBillDetail(Integer id, BillDetailDTO billDetail);

	void deleteBillDetail(Integer id);

	BillDetail getBillDetailById(Integer id);

}
