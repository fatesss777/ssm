package com.wzp.service.admin;

import com.wzp.entity.admin.News;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public interface NewsService
{
    int add(News news);

    int edit(News news);

    int delete(Long id);

    List<News> list(Map<String, Object> result);

    int getTotal(Map<String, Object> result);

    News getNewsById(Long id);

    int updateCommentNumber(Long id);

    int updateViewNumber(Long id);

    List<News> getLastCommentList(int pageSize);

}
