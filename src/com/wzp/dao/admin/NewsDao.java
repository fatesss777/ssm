package com.wzp.dao.admin;

import com.wzp.entity.admin.News;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface NewsDao
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
