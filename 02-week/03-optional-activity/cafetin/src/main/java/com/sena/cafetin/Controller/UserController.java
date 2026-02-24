package com.sena.cafetin.Controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sena.cafetin.Entity.Users;
import com.sena.cafetin.IService.IUserService;

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
	public ResponseEntity<Users> createUsers(@RequestBody Users users){
		Users saved = service.saveUsers(users);
		return ResponseEntity.status(HttpStatus.CREATED).body(saved);
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> deleteUsers(@PathVariable Integer id){
		service.deleteUsers(id);
		return ResponseEntity.noContent().build();
	}

}
