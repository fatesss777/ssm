package com.wzp.service.admin.impl;

import com.wzp.dao.admin.NewsDao;
import com.wzp.entity.admin.News;
import com.wzp.service.admin.NewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class NewsImpl implements NewsService
{
    @Autowired
    NewsDao newsDao;


    @Override
    public int add(News news)
    {
        return newsDao.add(news);
    }

    @Override
    public int edit(News news)
    {
        return newsDao.edit(news);
    }

    @Override
    public int delete(Long id)
    {
        return newsDao.delete(id);
    }

    @Override
    public List<News> list(Map<String, Object> result)
    {
        return newsDao.list(result);
    }

    @Override
    public int getTotal(Map<String, Object> result)
    {
        return newsDao.getTotal(result);
    }

    @Override
    public News getNewsById(Long id)
    {
        return newsDao.getNewsById(id);
    }

    @Override
    public int updateCommentNumber(Long id)
    {
        return newsDao.updateCommentNumber(id);
    }

    @Override
    public int updateViewNumber(Long id)
    {
        return newsDao.updateViewNumber(id);
    }

    @Override
    public List<News> getLastCommentList(int pageSize)
    {
        return newsDao.getLastCommentList(pageSize);
    }
}
