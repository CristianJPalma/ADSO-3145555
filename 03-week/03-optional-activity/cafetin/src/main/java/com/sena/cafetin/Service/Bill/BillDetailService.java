package com.sena.cafetin.Service.Bill;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sena.cafetin.DTO.Bill.BillDetailDTO;
import com.sena.cafetin.Entity.Bill.Bill;
import com.sena.cafetin.Entity.Bill.BillDetail;
import com.sena.cafetin.Entity.Inventory.Product;
import com.sena.cafetin.IRepository.Bill.IBillDetailRepository;
import com.sena.cafetin.IRepository.Bill.IBillRepository;
import com.sena.cafetin.IRepository.Inventory.IProductRepository;
import com.sena.cafetin.IService.Bill.IBillDetailService;
import com.sena.cafetin.Utils.Bill.BillDetailMapper;

@Service
public class BillDetailService implements IBillDetailService{

	@Autowired
	private IBillDetailRepository repo;

	@Autowired
	private IBillRepository billRepo;

	@Autowired
	private IProductRepository productRepo;

	public List<BillDetail> getAllBillDetail(){
		return this.repo.findAll();
	}

	public BillDetail saveBillDetail(BillDetailDTO billDetail){
		Bill bill = billRepo.findById(billDetail.getBillId())
				.orElseThrow(() -> new RuntimeException("Bill not found: " + billDetail.getBillId()));
		Product product = productRepo.findById(billDetail.getProductId())
				.orElseThrow(() -> new RuntimeException("Product not found: " + billDetail.getProductId()));
		BillDetail entity = BillDetailMapper.toEntity(billDetail, bill, product);
		return repo.save(entity);
	}

	public BillDetail updateBillDetail(Integer id, BillDetailDTO billDetail){
		BillDetail existing = repo.findById(id)
				.orElseThrow(() -> new RuntimeException("BillDetail not found: " + id));
		Bill bill = billRepo.findById(billDetail.getBillId())
				.orElseThrow(() -> new RuntimeException("Bill not found: " + billDetail.getBillId()));
		Product product = productRepo.findById(billDetail.getProductId())
				.orElseThrow(() -> new RuntimeException("Product not found: " + billDetail.getProductId()));
		BillDetailMapper.updateEntity(existing, billDetail, bill, product);
		return repo.save(existing);
	}

	public void deleteBillDetail(Integer id){
		repo.deleteById(id);
	}

	public BillDetail getBillDetailById(Integer id){
		return repo.findById(id).orElse(null);
	}

}
