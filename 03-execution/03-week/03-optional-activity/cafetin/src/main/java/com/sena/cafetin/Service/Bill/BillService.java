package com.sena.cafetin.Service.Bill;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sena.cafetin.DTO.Bill.BillDTO;
import com.sena.cafetin.Entity.Bill.Bill;
import com.sena.cafetin.Entity.Security.Users;
import com.sena.cafetin.IRepository.Bill.IBillRepository;
import com.sena.cafetin.IRepository.Security.IUserRepository;
import com.sena.cafetin.IService.Bill.IBillService;
import com.sena.cafetin.Utils.Bill.BillMapper;

@Service
public class BillService implements IBillService{

	@Autowired
	private IBillRepository repo;

	@Autowired
	private IUserRepository userRepo;

	public List<Bill> getAllBill(){
		return this.repo.findAll();
	}

	public Bill saveBill(BillDTO bill){
		Users user = userRepo.findById(bill.getUserId())
				.orElseThrow(() -> new RuntimeException("User not found: " + bill.getUserId()));
		Bill entity = BillMapper.toEntity(bill, user);
		return repo.save(entity);
	}

	public Bill updateBill(Integer id, BillDTO bill){
		Bill existing = repo.findById(id)
				.orElseThrow(() -> new RuntimeException("Bill not found: " + id));
		Users user = userRepo.findById(bill.getUserId())
				.orElseThrow(() -> new RuntimeException("User not found: " + bill.getUserId()));
		BillMapper.updateEntity(existing, bill, user);
		return repo.save(existing);
	}

	public void deleteBill(Integer id){
		repo.deleteById(id);
	}

	public Bill getBillById(Integer id){
		return repo.findById(id).orElse(null);
	}

}
