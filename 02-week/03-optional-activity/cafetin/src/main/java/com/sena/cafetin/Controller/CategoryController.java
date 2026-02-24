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

import com.sena.cafetin.Entity.Category;
import com.sena.cafetin.IService.ICategoryService;

@RestController
@RequestMapping("/category")
public class CategoryController {

	@Autowired
	private ICategoryService service;

	@GetMapping("")
	public ResponseEntity<List<Category>> getAllCategory(){
		return ResponseEntity.ok(service.getAllCategory());
	}

	@GetMapping("/{id}")
	public ResponseEntity<Category> getCategoryById(@PathVariable Integer id){
		return ResponseEntity.ok(service.getCategoryById(id));
	}

	@PostMapping("")
	public ResponseEntity<Category> createCategory(@RequestBody Category category){
		Category saved = service.saveCategory(category);
		return ResponseEntity.status(HttpStatus.CREATED).body(saved);
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> deleteCategory(@PathVariable Integer id){
		service.deleteCategory(id);
		return ResponseEntity.noContent().build();
	}

}
