package com.sena.cafetin.IService;

import java.util.List;

import com.sena.cafetin.Entity.Product;

public interface IProductService {

	List<Product> getAllProduct();

	Product saveProduct(Product product);

	void deleteProduct(Integer id);

	Product getProductById(Integer id);

}
