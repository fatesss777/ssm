package com.wzp.dao.admin;

import com.wzp.entity.admin.Menu;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface MenuDao
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
