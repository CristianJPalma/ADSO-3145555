package com.sena.cafetin.IService;

import java.util.List;

import com.sena.cafetin.Entity.Users;

public interface IUserService {

	List<Users> getAllUsers();

	Users saveUsers(Users users);

	void deleteUsers(Integer id);

	Users getUsersById(Integer id);

}
