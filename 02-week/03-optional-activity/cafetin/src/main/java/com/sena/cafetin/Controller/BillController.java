package com.sena.cafetin.Controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sena.cafetin.Entity.Bill;
import com.sena.cafetin.IService.IBillService;

@RestController
@RequestMapping("/bill")
public class BillController {

	@Autowired
	private IBillService service;

	@GetMapping("")
	public ResponseEntity<List<Bill>> getAllBill(){
		return ResponseEntity.ok(service.getAllBill());
	}

	@GetMapping("/{id}")
	public ResponseEntity<Bill> getBillById(@PathVariable Integer id){
		return ResponseEntity.ok(service.getBillById(id));
	}

	@PostMapping("")
	public ResponseEntity<Bill> createBill(@RequestBody Bill bill){
		Bill saved = service.saveBill(bill);
		return ResponseEntity.status(HttpStatus.CREATED).body(saved);
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> deleteBill(@PathVariable Integer id){
		service.deleteBill(id);
		return ResponseEntity.noContent().build();
	}

}
