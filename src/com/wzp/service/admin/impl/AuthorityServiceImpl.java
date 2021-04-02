package com.wzp.service.admin.impl;

import com.wzp.dao.admin.AuthorityDao;
import com.wzp.entity.admin.Authority;
import com.wzp.service.admin.AuthorityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AuthorityServiceImpl implements AuthorityService
{
    @Autowired
    AuthorityDao authorityDao;

    @Override
    public int add(Authority authority)
    {
        return authorityDao.add(authority);
    }

    @Override
    public int deleltByRoleId(Long roleId)
    {
        return authorityDao.deleltByRoleId(roleId);
    }

    @Override
    public List<Authority> selectListByRoleId(Long roleId)
    {
        return authorityDao.selectListByRoleId(roleId);
    }
}
