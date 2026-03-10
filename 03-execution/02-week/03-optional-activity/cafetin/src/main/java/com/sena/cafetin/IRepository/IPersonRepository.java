package com.sena.cafetin.IRepository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sena.cafetin.Entity.Person;

@Repository
public interface IPersonRepository extends JpaRepository<Person, Integer>{

    
}
