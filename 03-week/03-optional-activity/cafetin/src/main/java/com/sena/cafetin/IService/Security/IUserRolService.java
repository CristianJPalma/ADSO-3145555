package com.sena.cafetin.IService.Security;

import java.util.List;

import com.sena.cafetin.DTO.Security.UserRoleDTO;
import com.sena.cafetin.Entity.Security.UserRole;

public interface IUserRolService {

	List<UserRole> getAllUserRole();

	UserRole saveUserRole(UserRoleDTO userRole);

	UserRole updateUserRole(Integer id, UserRoleDTO userRole);

	void deleteUserRole(Integer id);

	UserRole getUserRoleById(Integer id);

}
