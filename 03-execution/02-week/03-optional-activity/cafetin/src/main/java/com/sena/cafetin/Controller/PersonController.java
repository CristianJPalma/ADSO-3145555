package com.sena.cafetin.Controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sena.cafetin.Entity.Person;
import com.sena.cafetin.IService.IPersonService;

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
public ResponseEntity<Person> createPerson(@RequestBody Person person){
    Person saved = service.savePerson(person);
    return ResponseEntity.status(HttpStatus.CREATED).body(saved);
}

@DeleteMapping("/{id}")
public ResponseEntity<Void> deletePerson(@PathVariable Integer id){
    service.deletePerson(id);
    return ResponseEntity.noContent().build();
}

}
