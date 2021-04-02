package com.wzp.service.admin;

import com.wzp.entity.admin.Menu;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public interface MenuService
{
    int add(Menu menu);
    List<Menu> selectList(Map<String, Object> postResults);
    int selectTotal(Map<String, Object> postResults);
    List<Menu> selectTopList();
    int edit(Menu menu);
    int delete(Long id);
    List<Menu> selectChildrenList(Long parentId);
    List<Menu> selectMenusByIds(String ids);
}
