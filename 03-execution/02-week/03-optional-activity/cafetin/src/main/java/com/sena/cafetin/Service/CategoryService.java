package com.sena.cafetin.Service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sena.cafetin.Entity.Category;
import com.sena.cafetin.IRepository.ICategoryRepository;
import com.sena.cafetin.IService.ICategoryService;

@Service
public class CategoryService implements ICategoryService{

	@Autowired
	private ICategoryRepository repo;

	public List<Category> getAllCategory(){
		return this.repo.findAll();
	}

	public Category saveCategory(Category category){
		return repo.save(category);
	}

	public void deleteCategory(Integer id){
		repo.deleteById(id);
	}

	public Category getCategoryById(Integer id){
		return repo.findById(id).orElse(null);
	}

}
