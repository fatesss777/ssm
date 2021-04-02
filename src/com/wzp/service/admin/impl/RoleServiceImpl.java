package com.wzp.service.admin.impl;

import com.wzp.dao.admin.RoleDao;
import com.wzp.entity.admin.Role;
import com.wzp.service.admin.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class RoleServiceImpl implements RoleService
{
    @Autowired
    RoleDao roleDao;

    @Override
    public List<Role> selectRole(Map<String, Object> map)
    {
        return roleDao.selectRole(map);
    }

    @Override
    public int getTotal(Map<String, Object> map)
    {
        return roleDao.getTotal(map);
    }

    @Override
    public int addRole(Role role)
    {
        return roleDao.addRole(role);
    }

    @Override
    public int editRole(Role role)
    {
        return roleDao.editRole(role);
    }

    @Override
    public int deleteRole(Long id)
    {
        return roleDao.deleteRole(id);
    }

    @Override
    public Role selectRoleById(Long id)
    {
        return roleDao.selectRoleById(id);
    }
}
