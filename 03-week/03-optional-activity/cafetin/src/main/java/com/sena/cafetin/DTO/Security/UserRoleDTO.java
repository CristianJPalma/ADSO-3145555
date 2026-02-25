package com.sena.cafetin.DTO.Security;

public class UserRoleDTO {

    private Integer userId;
    private Integer roleId;

    public UserRoleDTO() {
    }

    public UserRoleDTO(Integer userId, Integer roleId) {
        this.userId = userId;
        this.roleId = roleId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }
}
