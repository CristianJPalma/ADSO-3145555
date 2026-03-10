package com.sena.cafetin.IService;

import java.util.List;

import com.sena.cafetin.Entity.Role;

public interface IRoleService {

	List<Role> getAllRole();

	Role saveRole(Role role);

	void deleteRole(Integer id);

	Role getRoleById(Integer id);

}
