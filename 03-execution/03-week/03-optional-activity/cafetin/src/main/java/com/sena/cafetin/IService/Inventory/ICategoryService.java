package com.sena.cafetin.IService.Inventory;

import java.util.List;

import com.sena.cafetin.DTO.Inventory.CategoryDTO;
import com.sena.cafetin.Entity.Inventory.Category;

public interface ICategoryService {

	List<Category> getAllCategory();

	Category saveCategory(CategoryDTO category);

	Category updateCategory(Integer id, CategoryDTO category);

	void deleteCategory(Integer id);

	Category getCategoryById(Integer id);

}
