package com.sena.cafetin.Service.Inventory;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sena.cafetin.DTO.Inventory.CategoryDTO;
import com.sena.cafetin.Entity.Inventory.Category;
import com.sena.cafetin.IRepository.Inventory.ICategoryRepository;
import com.sena.cafetin.IService.Inventory.ICategoryService;
import com.sena.cafetin.Utils.Inventory.CategoryMapper;

@Service
public class CategoryService implements ICategoryService{

	@Autowired
	private ICategoryRepository repo;

	public List<Category> getAllCategory(){
		return this.repo.findAll();
	}

	public Category saveCategory(CategoryDTO category){
		Category entity = CategoryMapper.toEntity(category);
		return repo.save(entity);
	}

	public Category updateCategory(Integer id, CategoryDTO category){
		Category existing = repo.findById(id)
				.orElseThrow(() -> new RuntimeException("Category not found: " + id));
		CategoryMapper.updateEntity(existing, category);
		return repo.save(existing);
	}

	public void deleteCategory(Integer id){
		repo.deleteById(id);
	}

	public Category getCategoryById(Integer id){
		return repo.findById(id).orElse(null);
	}

}
