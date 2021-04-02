package com.wzp.dao.admin;

import com.wzp.entity.admin.NewsCategory;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface NewsCategoryDao
{
    int add(NewsCategory newsCategory);

    int edit(NewsCategory newsCategory);

    int delete(Long id);

    List<NewsCategory> list(Map<String, Object> result);

    int getTotal(Map<String, Object> result);

    List<NewsCategory> getAll();

    NewsCategory findNewsCategoryById(Long id);

}
