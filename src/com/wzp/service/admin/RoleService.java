package com.wzp.service.admin;

import com.wzp.entity.admin.Role;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public interface RoleService
{
    List<Role> selectRole(Map<String, Object> map);

    int getTotal(Map<String, Object> map);

    int addRole(Role role);

    int editRole(Role role);

    int deleteRole(Long id);

    Role selectRoleById(Long id);
}
