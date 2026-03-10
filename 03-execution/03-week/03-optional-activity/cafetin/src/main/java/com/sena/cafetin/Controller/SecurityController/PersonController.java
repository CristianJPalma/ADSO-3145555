package com.sena.cafetin.Controller.SecurityController;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sena.cafetin.DTO.Security.PersonDTO;
import com.sena.cafetin.Entity.Security.Person;
import com.sena.cafetin.IService.Security.IPersonService;

@RestController
@RequestMapping("/person")
public class PersonController {

@Autowired
private IPersonService service;

@GetMapping("")
public ResponseEntity<List<Person>>  getAllPerson(){
    return ResponseEntity.ok(service.getAllPerson());
}

@GetMapping("/{id}")
public ResponseEntity<Person> getPersonById(@PathVariable Integer id){
    return ResponseEntity.ok(service.getPersonById(id));
}

@PostMapping("")
public ResponseEntity<Person> createPerson(@RequestBody PersonDTO person){
    Person saved = service.savePerson(person);
    return ResponseEntity.status(HttpStatus.CREATED).body(saved);
}

@PutMapping("/{id}")
public ResponseEntity<Person> updatePerson(@PathVariable Integer id, @RequestBody PersonDTO person){
    return ResponseEntity.ok(service.updatePerson(id, person));
}

@DeleteMapping("/{id}")
public ResponseEntity<Void> deletePerson(@PathVariable Integer id){
    service.deletePerson(id);
    return ResponseEntity.noContent().build();
}

}
