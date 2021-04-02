package com.wzp.dao.admin;

import com.wzp.entity.admin.Comment;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface CommentDao
{
    int add(Comment comment);

    int edit(Comment comment);

    int delete(String ids);

    List<Comment> list(Map<String, Object> result);

    int getTotal(Map<String, Object> result);

    List<Comment> findAll();
}
