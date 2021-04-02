package com.wzp.dao.admin;

import com.wzp.entity.admin.Authority;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AuthorityDao
{
    int add(Authority authority);

    int deleltByRoleId(Long roleId);

    List<Authority> selectListByRoleId(Long roleId);
}
