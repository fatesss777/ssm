package com.wzp.dao.admin;

import com.wzp.entity.admin.Role;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface RoleDao
{
    List<Role> selectRole(Map<String, Object> map);
    int getTotal(Map<String, Object> map);
    int addRole(Role role);
    int editRole(Role role);
    int deleteRole(Long id);
    Role selectRoleById(Long id);

}
