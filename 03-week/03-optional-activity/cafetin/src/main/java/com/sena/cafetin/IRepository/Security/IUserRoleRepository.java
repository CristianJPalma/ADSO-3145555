package com.sena.cafetin.IRepository.Security;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sena.cafetin.Entity.Security.UserRole;

@Repository
public interface IUserRoleRepository extends JpaRepository<UserRole, Integer>{

}
