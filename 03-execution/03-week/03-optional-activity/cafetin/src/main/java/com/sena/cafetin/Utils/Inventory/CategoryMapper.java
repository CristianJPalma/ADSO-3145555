package com.sena.cafetin.Utils.Inventory;

import com.sena.cafetin.DTO.Inventory.CategoryDTO;
import com.sena.cafetin.Entity.Inventory.Category;

public class CategoryMapper {

    public static Category toEntity(CategoryDTO dto) {
        Category category = new Category();
        category.setName(dto.getName());
        category.setDescription(dto.getDescription());
        return category;
    }

    public static Category updateEntity(Category category, CategoryDTO dto) {
        category.setName(dto.getName());
        category.setDescription(dto.getDescription());
        return category;
    }
}
