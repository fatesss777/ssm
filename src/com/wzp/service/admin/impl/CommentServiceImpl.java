package com.wzp.service.admin.impl;

import com.wzp.dao.admin.CommentDao;
import com.wzp.entity.admin.Comment;
import com.wzp.service.admin.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class CommentServiceImpl implements CommentService
{
    @Autowired
    CommentDao commentDao;

    @Override
    public int add(Comment comment)
    {
        return commentDao.add(comment);
    }

    @Override
    public int edit(Comment comment)
    {
        return commentDao.edit(comment);
    }

    @Override
    public int delete(String ids)
    {
        return commentDao.delete(ids);
    }

    @Override
    public List<Comment> list(Map<String, Object> result)
    {
        return commentDao.list(result);
    }

    @Override
    public int getTotal(Map<String, Object> result)
    {
        return commentDao.getTotal(result);
    }

    @Override
    public List<Comment> findAll()
    {
        return commentDao.findAll();
    }
}
