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

import com.sena.cafetin.DTO.Security.RoleDTO;
import com.sena.cafetin.Entity.Security.Role;
import com.sena.cafetin.IService.Security.IRoleService;

@RestController
@RequestMapping("/role")
public class RoleController {

	@Autowired
	private IRoleService service;

	@GetMapping("")
	public ResponseEntity<List<Role>> getAllRole(){
		return ResponseEntity.ok(service.getAllRole());
	}

	@GetMapping("/{id}")
	public ResponseEntity<Role> getRoleById(@PathVariable Integer id){
		return ResponseEntity.ok(service.getRoleById(id));
	}

	@PostMapping("")
	public ResponseEntity<Role> createRole(@RequestBody RoleDTO role){
		Role saved = service.saveRole(role);
		return ResponseEntity.status(HttpStatus.CREATED).body(saved);
	}

	@PutMapping("/{id}")
	public ResponseEntity<Role> updateRole(@PathVariable Integer id, @RequestBody RoleDTO role){
		return ResponseEntity.ok(service.updateRole(id, role));
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> deleteRole(@PathVariable Integer id){
		service.deleteRole(id);
		return ResponseEntity.noContent().build();
	}

}
