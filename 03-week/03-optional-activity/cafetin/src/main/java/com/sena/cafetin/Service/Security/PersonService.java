package com.sena.cafetin.Service.Security;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sena.cafetin.DTO.Security.PersonDTO;
import com.sena.cafetin.Entity.Security.Person;
import com.sena.cafetin.IRepository.Security.IPersonRepository;
import com.sena.cafetin.IService.Security.IPersonService;
import com.sena.cafetin.Utils.Security.PersonMapper;

@Service
public class PersonService implements IPersonService{

    @Autowired
    private IPersonRepository repo;

    
    public List<Person> getAllPerson(){
        return this.repo.findAll();
    }
    
    public Person savePerson(PersonDTO person){
        Person entity = PersonMapper.toEntity(person);
        return repo.save(entity);
    }

    public Person updatePerson(Integer id, PersonDTO person){
        Person existing = repo.findById(id)
                .orElseThrow(() -> new RuntimeException("Person not found: " + id));
        PersonMapper.updateEntity(existing, person);
        return repo.save(existing);
    }

    public void deletePerson(Integer Id){
        repo.deleteById(Id);
    }

    public Person getPersonById(Integer id){
        return repo.findById(id).orElse(null);
    }

}
