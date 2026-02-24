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

import com.sena.cafetin.Entity.UserRole;
import com.sena.cafetin.IService.IUserRolService;

@RestController
@RequestMapping("/userRole")
public class UserRoleController {

	@Autowired
	private IUserRolService service;

	@GetMapping("")
	public ResponseEntity<List<UserRole>> getAllUserRole(){
		return ResponseEntity.ok(service.getAllUserRole());
	}

	@GetMapping("/{id}")
	public ResponseEntity<UserRole> getUserRoleById(@PathVariable Integer id){
		return ResponseEntity.ok(service.getUserRoleById(id));
	}

	@PostMapping("")
	public ResponseEntity<UserRole> createUserRole(@RequestBody UserRole userRole){
		UserRole saved = service.saveUserRole(userRole);
		return ResponseEntity.status(HttpStatus.CREATED).body(saved);
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> deleteUserRole(@PathVariable Integer id){
		service.deleteUserRole(id);
		return ResponseEntity.noContent().build();
	}

}
