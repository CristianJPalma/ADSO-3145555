package com.sena.cafetin.IService.Security;

import java.util.List;

import com.sena.cafetin.DTO.Security.UsersDTO;
import com.sena.cafetin.Entity.Security.Users;

public interface IUserService {

	List<Users> getAllUsers();

	Users saveUsers(UsersDTO users);

	Users updateUsers(Integer id, UsersDTO users);

	void deleteUsers(Integer id);

	Users getUsersById(Integer id);

}
