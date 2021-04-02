package com.wzp.dao.admin;

import com.wzp.entity.admin.Log;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface LogDao
{
    int add(Log log);
    List<Log> selectList(Map<String, Object> postResults);
    int selectTotal(Map<String, Object> postResults);
    int deleteLog(String ids);
}
