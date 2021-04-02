package com.wzp.service.admin.impl;

import com.wzp.dao.admin.MenuDao;
import com.wzp.entity.admin.Menu;
import com.wzp.service.admin.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class MenuServiceImpl implements MenuService
{
    @Autowired
    private MenuDao menuDao;

    @Override
    public int add(Menu menu)
    {
        return menuDao.add(menu);
    }

    @Override
    public List<Menu> selectList(Map<String, Object> postResults)
    {
        return menuDao.selectList(postResults);
    }

    @Override
    public int selectTotal(Map<String, Object> postResults)
    {
        return menuDao.selectTotal(postResults);
    }

    @Override
    public List<Menu> selectTopList()
    {
        return menuDao.selectTopList();
    }

    @Override
    public int edit(Menu menu)
    {
        return menuDao.edit(menu);
    }

    @Override
    public int delete(Long id)
    {
        return menuDao.delete(id);
    }

    @Override
    public List<Menu> selectChildrenList(Long parentId)
    {
        return menuDao.selectChildrenList(parentId);
    }

    @Override
    public List<Menu> selectMenusByIds(String ids)
    {
        return menuDao.selectMenusByIds(ids);
    }
}
