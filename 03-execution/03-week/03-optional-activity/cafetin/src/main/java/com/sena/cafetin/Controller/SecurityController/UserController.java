package com.sena.cafetin.Controller.SecurityController;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sena.cafetin.DTO.Security.UsersDTO;
import com.sena.cafetin.Entity.Security.Users;
import com.sena.cafetin.IService.Security.IUserService;

@RestController
@RequestMapping("/user")
public class UserController {

	@Autowired
	private IUserService service;

	@GetMapping("")
	public ResponseEntity<List<Users>> getAllUsers(){
		return ResponseEntity.ok(service.getAllUsers());
	}

	@GetMapping("/{id}")
	public ResponseEntity<Users> getUsersById(@PathVariable Integer id){
		return ResponseEntity.ok(service.getUsersById(id));
	}

	@PostMapping("")
	public ResponseEntity<Users> createUsers(@RequestBody UsersDTO users){
		Users saved = service.saveUsers(users);
		return ResponseEntity.status(HttpStatus.CREATED).body(saved);
	}

	@PutMapping("/{id}")
	public ResponseEntity<Users> updateUsers(@PathVariable Integer id, @RequestBody UsersDTO users){
		return ResponseEntity.ok(service.updateUsers(id, users));
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> deleteUsers(@PathVariable Integer id){
		service.deleteUsers(id);
		return ResponseEntity.noContent().build();
	}

}
