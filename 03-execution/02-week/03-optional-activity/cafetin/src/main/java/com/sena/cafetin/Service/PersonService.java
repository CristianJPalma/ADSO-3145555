package com.sena.cafetin.Service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sena.cafetin.Entity.Person;
import com.sena.cafetin.IRepository.IPersonRepository;
import com.sena.cafetin.IService.IPersonService;

@Service
public class PersonService implements IPersonService{

    @Autowired
    private IPersonRepository repo;

    
    public List<Person> getAllPerson(){
        return this.repo.findAll();
    }
    
    public Person savePerson(Person person){
        return repo.save(person);
    }

    public void deletePerson(Integer Id){
        repo.deleteById(Id);
    }

    public Person getPersonById(Integer id){
        return repo.findById(id).orElse(null);
    }

}
