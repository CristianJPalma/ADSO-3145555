package com.sena.cafetin.IService;

import java.util.List;

import com.sena.cafetin.Entity.BillDetail;

public interface IBillDetailService{

	List<BillDetail> getAllBillDetail();

	BillDetail saveBillDetail(BillDetail billDetail);

	void deleteBillDetail(Integer id);

	BillDetail getBillDetailById(Integer id);

}
