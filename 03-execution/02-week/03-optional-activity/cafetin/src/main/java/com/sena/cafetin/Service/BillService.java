package com.sena.cafetin.Service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sena.cafetin.Entity.Bill;
import com.sena.cafetin.IRepository.IBillRepository;
import com.sena.cafetin.IService.IBillService;

@Service
public class BillService implements IBillService{

	@Autowired
	private IBillRepository repo;

	public List<Bill> getAllBill(){
		return this.repo.findAll();
	}

	public Bill saveBill(Bill bill){
		return repo.save(bill);
	}

	public void deleteBill(Integer id){
		repo.deleteById(id);
	}

	public Bill getBillById(Integer id){
		return repo.findById(id).orElse(null);
	}

}
