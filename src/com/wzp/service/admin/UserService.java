package com.wzp.service.admin;

import com.wzp.entity.admin.User;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public interface UserService
{
    User findUserByName(String username);

    List<User> selectUser(Map<String, Object> map);

    int getTotal(Map<String, Object> map);

    int addUser(User user);

    int editUser(User user);

    int deleteUser(String ids);

    int editPassword(User user);
}
