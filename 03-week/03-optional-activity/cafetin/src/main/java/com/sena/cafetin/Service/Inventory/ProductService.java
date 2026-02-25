package com.sena.cafetin.Service.Inventory;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sena.cafetin.DTO.Inventory.ProductDTO;
import com.sena.cafetin.Entity.Inventory.Category;
import com.sena.cafetin.Entity.Inventory.Product;
import com.sena.cafetin.IRepository.Inventory.ICategoryRepository;
import com.sena.cafetin.IRepository.Inventory.IProductRepository;
import com.sena.cafetin.IService.Inventory.IProductService;
import com.sena.cafetin.Utils.Inventory.ProductMapper;

@Service
public class ProductService implements IProductService{

	@Autowired
	private IProductRepository repo;

	@Autowired
	private ICategoryRepository categoryRepo;

	public List<Product> getAllProduct(){
		return this.repo.findAll();
	}

	public Product saveProduct(ProductDTO product){
		Category category = categoryRepo.findById(product.getCategoryId())
				.orElseThrow(() -> new RuntimeException("Category not found: " + product.getCategoryId()));
		Product entity = ProductMapper.toEntity(product, category);
		return repo.save(entity);
	}

	public Product updateProduct(Integer id, ProductDTO product){
		Product existing = repo.findById(id)
				.orElseThrow(() -> new RuntimeException("Product not found: " + id));
		Category category = categoryRepo.findById(product.getCategoryId())
				.orElseThrow(() -> new RuntimeException("Category not found: " + product.getCategoryId()));
		ProductMapper.updateEntity(existing, product, category);
		return repo.save(existing);
	}

	public void deleteProduct(Integer id){
		repo.deleteById(id);
	}

	public Product getProductById(Integer id){
		return repo.findById(id).orElse(null);
	}

}
