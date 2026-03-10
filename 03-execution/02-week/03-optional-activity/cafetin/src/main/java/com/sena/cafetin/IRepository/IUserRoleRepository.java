package com.sena.cafetin.IRepository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sena.cafetin.Entity.UserRole;

@Repository
public interface IUserRoleRepository extends JpaRepository<UserRole, Integer>{

}
