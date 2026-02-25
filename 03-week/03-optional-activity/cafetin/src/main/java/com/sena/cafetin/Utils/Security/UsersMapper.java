package com.sena.cafetin.Utils.Security;

import com.sena.cafetin.DTO.Security.UsersDTO;
import com.sena.cafetin.Entity.Security.Person;
import com.sena.cafetin.Entity.Security.Users;

public class UsersMapper {

    public static Users toEntity(UsersDTO dto, Person person) {
        Users users = new Users();
        users.setUsername(dto.getUsername());
        users.setPassword(dto.getPassword());
        users.setPerson(person);
        return users;
    }

    public static Users updateEntity(Users users, UsersDTO dto, Person person) {
        users.setUsername(dto.getUsername());
        users.setPassword(dto.getPassword());
        users.setPerson(person);
        return users;
    }
}
