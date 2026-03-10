package com.sena.cafetin.Utils.Security;

import com.sena.cafetin.DTO.Security.RoleDTO;
import com.sena.cafetin.Entity.Security.Role;

public class RoleMapper {

    public static Role toEntity(RoleDTO dto) {
        Role role = new Role();
        role.setName(dto.getName());
        role.setDescription(dto.getDescription());
        return role;
    }

    public static Role updateEntity(Role role, RoleDTO dto) {
        role.setName(dto.getName());
        role.setDescription(dto.getDescription());
        return role;
    }
}
