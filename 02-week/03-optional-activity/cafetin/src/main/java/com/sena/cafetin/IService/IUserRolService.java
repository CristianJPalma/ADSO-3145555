package com.sena.cafetin.IService;

import java.util.List;

import com.sena.cafetin.Entity.UserRole;

public interface IUserRolService {

	List<UserRole> getAllUserRole();

	UserRole saveUserRole(UserRole userRole);

	void deleteUserRole(Integer id);

	UserRole getUserRoleById(Integer id);

}
