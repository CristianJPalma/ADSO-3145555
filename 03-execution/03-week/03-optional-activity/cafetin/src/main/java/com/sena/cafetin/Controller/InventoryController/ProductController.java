package com.sena.cafetin.Controller.InventoryController;

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

import com.sena.cafetin.DTO.Inventory.ProductDTO;
import com.sena.cafetin.Entity.Inventory.Product;
import com.sena.cafetin.IService.Inventory.IProductService;

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
	public ResponseEntity<Product> createProduct(@RequestBody ProductDTO product){
		Product saved = service.saveProduct(product);
		return ResponseEntity.status(HttpStatus.CREATED).body(saved);
	}

	@PutMapping("/{id}")
	public ResponseEntity<Product> updateProduct(@PathVariable Integer id, @RequestBody ProductDTO product){
		return ResponseEntity.ok(service.updateProduct(id, product));
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> deleteProduct(@PathVariable Integer id){
		service.deleteProduct(id);
		return ResponseEntity.noContent().build();
	}

}
