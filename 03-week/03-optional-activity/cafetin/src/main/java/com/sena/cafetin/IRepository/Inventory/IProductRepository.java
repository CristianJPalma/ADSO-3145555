package com.sena.cafetin.IRepository.Inventory;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sena.cafetin.Entity.Inventory.Product;

@Repository
public interface IProductRepository extends JpaRepository<Product, Integer>{

}
