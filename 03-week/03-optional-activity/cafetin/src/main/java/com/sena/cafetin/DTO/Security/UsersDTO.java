package com.sena.cafetin.DTO.Security;

public class UsersDTO {

    private String username;
    private String password;
    private Integer personId;

    public UsersDTO() {
    }

    public UsersDTO(String username, String password, Integer personId) {
        this.username = username;
        this.password = password;
        this.personId = personId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Integer getPersonId() {
        return personId;
    }

    public void setPersonId(Integer personId) {
        this.personId = personId;
    }
}
