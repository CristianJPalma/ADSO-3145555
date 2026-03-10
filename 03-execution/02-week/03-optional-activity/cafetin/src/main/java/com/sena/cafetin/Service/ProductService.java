package com.sena.cafetin.Service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sena.cafetin.Entity.Product;
import com.sena.cafetin.IRepository.IProductRepository;
import com.sena.cafetin.IService.IProductService;

@Service
public class ProductService implements IProductService{

	@Autowired
	private IProductRepository repo;

	public List<Product> getAllProduct(){
		return this.repo.findAll();
	}

	public Product saveProduct(Product product){
		return repo.save(product);
	}

	public void deleteProduct(Integer id){
		repo.deleteById(id);
	}

	public Product getProductById(Integer id){
		return repo.findById(id).orElse(null);
	}

}
