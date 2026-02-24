package com.sena.cafetin.Service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sena.cafetin.Entity.UserRole;
import com.sena.cafetin.IRepository.IUserRoleRepository;
import com.sena.cafetin.IService.IUserRolService;

@Service
public class UserRoleService implements IUserRolService{

	@Autowired
	private IUserRoleRepository repo;

	public List<UserRole> getAllUserRole(){
		return this.repo.findAll();
	}

	public UserRole saveUserRole(UserRole userRole){
		return repo.save(userRole);
	}

	public void deleteUserRole(Integer id){
		repo.deleteById(id);
	}

	public UserRole getUserRoleById(Integer id){
		return repo.findById(id).orElse(null);
	}

}
