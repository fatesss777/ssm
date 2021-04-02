package com.wzp.service.admin.impl;

import com.wzp.dao.admin.NewsCategoryDao;
import com.wzp.entity.admin.NewsCategory;
import com.wzp.service.admin.NewsCategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class NewsCategoryImpl implements NewsCategoryService
{
    @Autowired
    NewsCategoryDao newsCategoryDao;

    @Override
    public int add(NewsCategory newsCategory)
    {
        return newsCategoryDao.add(newsCategory);
    }

    @Override
    public int edit(NewsCategory newsCategory)
    {
        return newsCategoryDao.edit(newsCategory);
    }

    @Override
    public int delete(Long id)
    {
        return newsCategoryDao.delete(id);
    }

    @Override
    public List<NewsCategory> list(Map<String, Object> result)
    {
        return newsCategoryDao.list(result);
    }

    @Override
    public int getTotal(Map<String, Object> result)
    {
        return newsCategoryDao.getTotal(result);
    }

    @Override
    public List<NewsCategory> getAll()
    {
        return newsCategoryDao.getAll();
    }

    @Override
    public NewsCategory findNewsCategoryById(Long id)
    {
        return newsCategoryDao.findNewsCategoryById(id);
    }


}
