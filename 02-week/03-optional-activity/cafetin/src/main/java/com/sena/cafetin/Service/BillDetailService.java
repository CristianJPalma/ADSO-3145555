package com.sena.cafetin.Service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sena.cafetin.Entity.BillDetail;
import com.sena.cafetin.IRepository.IBillDetailRepository;
import com.sena.cafetin.IService.IBillDetailService;

@Service
public class BillDetailService implements IBillDetailService{

	@Autowired
	private IBillDetailRepository repo;

	public List<BillDetail> getAllBillDetail(){
		return this.repo.findAll();
	}

	public BillDetail saveBillDetail(BillDetail billDetail){
		return repo.save(billDetail);
	}

	public void deleteBillDetail(Integer id){
		repo.deleteById(id);
	}

	public BillDetail getBillDetailById(Integer id){
		return repo.findById(id).orElse(null);
	}

}
