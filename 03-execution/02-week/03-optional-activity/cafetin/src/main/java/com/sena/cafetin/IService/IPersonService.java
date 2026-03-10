package com.sena.cafetin.IService;

import java.util.List;

import com.sena.cafetin.Entity.Person;

public interface IPersonService{

    List<Person> getAllPerson();

    Person savePerson(Person person);

    void deletePerson(Integer id);
    
    Person getPersonById(Integer id);
    
}
