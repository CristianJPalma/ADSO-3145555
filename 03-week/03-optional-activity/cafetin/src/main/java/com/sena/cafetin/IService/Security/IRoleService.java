package com.sena.cafetin.IService.Security;

import java.util.List;

import com.sena.cafetin.DTO.Security.RoleDTO;
import com.sena.cafetin.Entity.Security.Role;

public interface IRoleService {

	List<Role> getAllRole();

	Role saveRole(RoleDTO role);

	Role updateRole(Integer id, RoleDTO role);

	void deleteRole(Integer id);

	Role getRoleById(Integer id);

}
