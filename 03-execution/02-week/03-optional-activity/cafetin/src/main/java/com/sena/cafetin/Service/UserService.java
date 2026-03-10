package com.sena.cafetin.Service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sena.cafetin.Entity.Users;
import com.sena.cafetin.IRepository.IUserRepository;
import com.sena.cafetin.IService.IUserService;

@Service
public class UserService implements IUserService{

	@Autowired
	private IUserRepository repo;

	public List<Users> getAllUsers(){
		return this.repo.findAll();
	}

	public Users saveUsers(Users users){
		return repo.save(users);
	}

	public void deleteUsers(Integer id){
		repo.deleteById(id);
	}

	public Users getUsersById(Integer id){
		return repo.findById(id).orElse(null);
	}

}
