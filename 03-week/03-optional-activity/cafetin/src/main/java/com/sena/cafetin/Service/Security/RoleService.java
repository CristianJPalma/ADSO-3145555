package com.sena.cafetin.Service.Security;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sena.cafetin.DTO.Security.RoleDTO;
import com.sena.cafetin.Entity.Security.Role;
import com.sena.cafetin.IRepository.Security.IRoleRepository;
import com.sena.cafetin.IService.Security.IRoleService;
import com.sena.cafetin.Utils.Security.RoleMapper;

@Service
public class RoleService implements IRoleService{

	@Autowired
	private IRoleRepository repo;

	public List<Role> getAllRole(){
		return this.repo.findAll();
	}

	public Role saveRole(RoleDTO role){
		Role entity = RoleMapper.toEntity(role);
		return repo.save(entity);
	}

	public Role updateRole(Integer id, RoleDTO role){
		Role existing = repo.findById(id)
				.orElseThrow(() -> new RuntimeException("Role not found: " + id));
		RoleMapper.updateEntity(existing, role);
		return repo.save(existing);
	}

	public void deleteRole(Integer id){
		repo.deleteById(id);
	}

	public Role getRoleById(Integer id){
		return repo.findById(id).orElse(null);
	}

}
