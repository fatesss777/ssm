package com.wzp.service.admin;

import com.wzp.entity.admin.Log;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public interface LogService
{
    int add(Log log);

    int addContent(String content);

    List<Log> selectList(Map<String, Object> postResults);

    int selectTotal(Map<String, Object> postResults);

    int deleteLog(String ids);

}
