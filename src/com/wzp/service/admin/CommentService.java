package com.wzp.service.admin;

import com.wzp.entity.admin.Comment;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public interface CommentService
{
    int add(Comment comment);

    int edit(Comment comment);

    int delete(String ids);

    List<Comment> list(Map<String, Object> result);

    int getTotal(Map<String, Object> result);

    List<Comment> findAll();

}
