package com.sena.cafetin.IRepository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sena.cafetin.Entity.Bill;

@Repository
public interface IBillRepository extends JpaRepository<Bill, Integer>{

}
