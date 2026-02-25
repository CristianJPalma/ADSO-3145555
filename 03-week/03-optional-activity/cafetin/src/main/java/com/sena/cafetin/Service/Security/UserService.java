package com.sena.cafetin.Service.Security;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sena.cafetin.DTO.Security.UsersDTO;
import com.sena.cafetin.Entity.Security.Person;
import com.sena.cafetin.Entity.Security.Users;
import com.sena.cafetin.IRepository.Security.IPersonRepository;
import com.sena.cafetin.IRepository.Security.IUserRepository;
import com.sena.cafetin.IService.Security.IUserService;
import com.sena.cafetin.Utils.Security.UsersMapper;

@Service
public class UserService implements IUserService{

	@Autowired
	private IUserRepository repo;

	@Autowired
	private IPersonRepository personRepo;

	public List<Users> getAllUsers(){
		return this.repo.findAll();
	}

	public Users saveUsers(UsersDTO users){
		Person person = personRepo.findById(users.getPersonId())
				.orElseThrow(() -> new RuntimeException("Person not found: " + users.getPersonId()));
		Users entity = UsersMapper.toEntity(users, person);
		return repo.save(entity);
	}

	public Users updateUsers(Integer id, UsersDTO users){
		Users existing = repo.findById(id)
				.orElseThrow(() -> new RuntimeException("Users not found: " + id));
		Person person = personRepo.findById(users.getPersonId())
				.orElseThrow(() -> new RuntimeException("Person not found: " + users.getPersonId()));
		UsersMapper.updateEntity(existing, users, person);
		return repo.save(existing);
	}

	public void deleteUsers(Integer id){
		repo.deleteById(id);
	}

	public Users getUsersById(Integer id){
		return repo.findById(id).orElse(null);
	}

}
