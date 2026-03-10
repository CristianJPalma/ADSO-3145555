package com.sena.cafetin.Utils.Security;

import com.sena.cafetin.DTO.Security.PersonDTO;
import com.sena.cafetin.Entity.Security.Person;

public class PersonMapper {

    public static Person toEntity(PersonDTO dto) {
        Person person = new Person();
        person.setFirstName(dto.getFirstName());
        person.setLastName(dto.getLastName());
        person.setEmail(dto.getEmail());
        return person;
    }

    public static Person updateEntity(Person person, PersonDTO dto) {
        person.setFirstName(dto.getFirstName());
        person.setLastName(dto.getLastName());
        person.setEmail(dto.getEmail());
        return person;
    }
}
