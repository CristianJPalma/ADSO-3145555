package com.sena.cafetin.Service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sena.cafetin.Entity.Role;
import com.sena.cafetin.IRepository.IRoleRepository;
import com.sena.cafetin.IService.IRoleService;

@Service
public class RoleService implements IRoleService{

	@Autowired
	private IRoleRepository repo;

	public List<Role> getAllRole(){
		return this.repo.findAll();
	}

	public Role saveRole(Role role){
		return repo.save(role);
	}

	public void deleteRole(Integer id){
		repo.deleteById(id);
	}

	public Role getRoleById(Integer id){
		return repo.findById(id).orElse(null);
	}

}
