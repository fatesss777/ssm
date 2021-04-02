package com.wzp.service.admin.impl;

import com.wzp.dao.admin.UserDao;
import com.wzp.entity.admin.User;
import com.wzp.service.admin.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService
{
    @Autowired
    UserDao userDao;

    @Override
    public User findUserByName(String username)
    {
        User userByName = userDao.findUserByName(username);
        return userByName;
    }

    @Override
    public List<User> selectUser(Map<String, Object> map)
    {
        return userDao.selectUser(map);
    }

    @Override
    public int getTotal(Map<String, Object> map)
    {
        return userDao.getTotal(map);
    }

    @Override
    public int addUser(User user)
    {
        return userDao.addUser(user);
    }

    @Override
    public int editUser(User user)
    {
        return userDao.editUser(user);
    }

    @Override
    public int deleteUser(String ids)
    {
        return userDao.deleteUser(ids);
    }

    @Override
    public int editPassword(User user)
    {
        return userDao.editPassword(user);
    }
}
