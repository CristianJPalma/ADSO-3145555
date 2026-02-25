package com.sena.cafetin.IService.Security;

import java.util.List;

import com.sena.cafetin.DTO.Security.PersonDTO;
import com.sena.cafetin.Entity.Security.Person;

public interface IPersonService{

    List<Person> getAllPerson();

    Person savePerson(PersonDTO person);

    Person updatePerson(Integer id, PersonDTO person);

    void deletePerson(Integer id);
    
    Person getPersonById(Integer id);
    
}
