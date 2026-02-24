package com.sena.cafetin.IRepository;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sena.cafetin.Entity.Category;

@Repository
public interface ICategoryRepository extends JpaRepository<Category, Integer>{

}
