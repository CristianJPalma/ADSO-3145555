package com.sena.cafetin.Utils.Security;

import com.sena.cafetin.DTO.Security.UserRoleDTO;
import com.sena.cafetin.Entity.Security.Role;
import com.sena.cafetin.Entity.Security.UserRole;
import com.sena.cafetin.Entity.Security.Users;

public class UserRoleMapper {

    public static UserRole toEntity(UserRoleDTO dto, Users user, Role role) {
        UserRole userRole = new UserRole();
        userRole.setUser(user);
        userRole.setRole(role);
        return userRole;
    }

    public static UserRole updateEntity(UserRole userRole, UserRoleDTO dto, Users user, Role role) {
        userRole.setUser(user);
        userRole.setRole(role);
        return userRole;
    }
}
