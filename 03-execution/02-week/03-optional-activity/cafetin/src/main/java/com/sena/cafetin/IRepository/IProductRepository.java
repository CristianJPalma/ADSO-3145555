package com.sena.cafetin.IRepository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sena.cafetin.Entity.Product;

@Repository
public interface IProductRepository extends JpaRepository<Product, Integer>{

}
