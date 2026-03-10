package com.sena.cafetin.IService;

import java.util.List;

import com.sena.cafetin.Entity.Category;

public interface ICategoryService {

	List<Category> getAllCategory();

	Category saveCategory(Category category);

	void deleteCategory(Integer id);

	Category getCategoryById(Integer id);

}
