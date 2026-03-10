package com.sena.cafetin.Controller.BillController;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sena.cafetin.DTO.Bill.BillDetailDTO;
import com.sena.cafetin.Entity.Bill.BillDetail;
import com.sena.cafetin.IService.Bill.IBillDetailService;

@RestController
@RequestMapping("/billDetail")
public class BillDetailController {

	@Autowired
	private IBillDetailService service;

	@GetMapping("")
	public ResponseEntity<List<BillDetail>> getAllBillDetail(){
		return ResponseEntity.ok(service.getAllBillDetail());
	}

	@GetMapping("/{id}")
	public ResponseEntity<BillDetail> getBillDetailById(@PathVariable Integer id){
		return ResponseEntity.ok(service.getBillDetailById(id));
	}

	@PostMapping("")
	public ResponseEntity<BillDetail> createBillDetail(@RequestBody BillDetailDTO billDetail){
		BillDetail saved = service.saveBillDetail(billDetail);
		return ResponseEntity.status(HttpStatus.CREATED).body(saved);
	}

	@PutMapping("/{id}")
	public ResponseEntity<BillDetail> updateBillDetail(@PathVariable Integer id, @RequestBody BillDetailDTO billDetail){
		return ResponseEntity.ok(service.updateBillDetail(id, billDetail));
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> deleteBillDetail(@PathVariable Integer id){
		service.deleteBillDetail(id);
		return ResponseEntity.noContent().build();
	}

}
