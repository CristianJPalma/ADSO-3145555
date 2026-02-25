package com.sena.cafetin.Service.Security;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sena.cafetin.DTO.Security.UserRoleDTO;
import com.sena.cafetin.Entity.Security.Role;
import com.sena.cafetin.Entity.Security.UserRole;
import com.sena.cafetin.Entity.Security.Users;
import com.sena.cafetin.IRepository.Security.IRoleRepository;
import com.sena.cafetin.IRepository.Security.IUserRepository;
import com.sena.cafetin.IRepository.Security.IUserRoleRepository;
import com.sena.cafetin.IService.Security.IUserRolService;
import com.sena.cafetin.Utils.Security.UserRoleMapper;

@Service
public class UserRoleService implements IUserRolService{

	@Autowired
	private IUserRoleRepository repo;

	@Autowired
	private IUserRepository userRepo;

	@Autowired
	private IRoleRepository roleRepo;

	public List<UserRole> getAllUserRole(){
		return this.repo.findAll();
	}

	public UserRole saveUserRole(UserRoleDTO userRole){
		Users user = userRepo.findById(userRole.getUserId())
				.orElseThrow(() -> new RuntimeException("User not found: " + userRole.getUserId()));
		Role role = roleRepo.findById(userRole.getRoleId())
				.orElseThrow(() -> new RuntimeException("Role not found: " + userRole.getRoleId()));
		UserRole entity = UserRoleMapper.toEntity(userRole, user, role);
		return repo.save(entity);
	}

	public UserRole updateUserRole(Integer id, UserRoleDTO userRole){
		UserRole existing = repo.findById(id)
				.orElseThrow(() -> new RuntimeException("UserRole not found: " + id));
		Users user = userRepo.findById(userRole.getUserId())
				.orElseThrow(() -> new RuntimeException("User not found: " + userRole.getUserId()));
		Role role = roleRepo.findById(userRole.getRoleId())
				.orElseThrow(() -> new RuntimeException("Role not found: " + userRole.getRoleId()));
		UserRoleMapper.updateEntity(existing, userRole, user, role);
		return repo.save(existing);
	}

	public void deleteUserRole(Integer id){
		repo.deleteById(id);
	}

	public UserRole getUserRoleById(Integer id){
		return repo.findById(id).orElse(null);
	}

}
