package com.sena.cafetin.IRepository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sena.cafetin.Entity.BillDetail;

@Repository
public interface IBillDetailRepository extends JpaRepository<BillDetail, Integer>{

}
