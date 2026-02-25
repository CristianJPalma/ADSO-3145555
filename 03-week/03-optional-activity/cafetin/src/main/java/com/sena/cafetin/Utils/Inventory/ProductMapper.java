package com.sena.cafetin.Utils.Inventory;

import com.sena.cafetin.DTO.Inventory.ProductDTO;
import com.sena.cafetin.Entity.Inventory.Category;
import com.sena.cafetin.Entity.Inventory.Product;

public class ProductMapper {

    public static Product toEntity(ProductDTO dto, Category category) {
        Product product = new Product();
        product.setName(dto.getName());
        product.setDescription(dto.getDescription());
        product.setPrice(dto.getPrice());
        product.setCategory(category);
        return product;
    }

    public static Product updateEntity(Product product, ProductDTO dto, Category category) {
        product.setName(dto.getName());
        product.setDescription(dto.getDescription());
        product.setPrice(dto.getPrice());
        product.setCategory(category);
        return product;
    }
}
