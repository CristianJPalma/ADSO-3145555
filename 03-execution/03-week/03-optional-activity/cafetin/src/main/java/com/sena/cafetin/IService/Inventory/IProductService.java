package com.sena.cafetin.IService.Inventory;

import java.util.List;

import com.sena.cafetin.DTO.Inventory.ProductDTO;
import com.sena.cafetin.Entity.Inventory.Product;

public interface IProductService {

	List<Product> getAllProduct();

	Product saveProduct(ProductDTO product);

	Product updateProduct(Integer id, ProductDTO product);

	void deleteProduct(Integer id);

	Product getProductById(Integer id);

}
