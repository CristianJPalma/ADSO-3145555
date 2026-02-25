package com.sena.cafetin.IRepository.Inventory;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sena.cafetin.Entity.Inventory.Category;

@Repository
public interface ICategoryRepository extends JpaRepository<Category, Integer>{

}
