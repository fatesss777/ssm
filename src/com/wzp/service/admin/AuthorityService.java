package com.wzp.service.admin;

import com.wzp.entity.admin.Authority;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface AuthorityService
{
    int add(Authority authority);

    int deleltByRoleId(Long roleId);

    List<Authority> selectListByRoleId(Long roleId);
}
