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

import com.sena.cafetin.Entity.Product;
import com.sena.cafetin.IService.IProductService;

@RestController
@RequestMapping("/product")
public class ProductController {

	@Autowired
	private IProductService service;

	@GetMapping("")
	public ResponseEntity<List<Product>> getAllProduct(){
		return ResponseEntity.ok(service.getAllProduct());
	}

	@GetMapping("/{id}")
	public ResponseEntity<Product> getProductById(@PathVariable Integer id){
		return ResponseEntity.ok(service.getProductById(id));
	}

	@PostMapping("")
	public ResponseEntity<Product> createProduct(@RequestBody Product product){
		Product saved = service.saveProduct(product);
		return ResponseEntity.status(HttpStatus.CREATED).body(saved);
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> deleteProduct(@PathVariable Integer id){
		service.deleteProduct(id);
		return ResponseEntity.noContent().build();
	}

}
