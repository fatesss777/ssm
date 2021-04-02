package com.wzp.service.admin.impl;

import com.wzp.dao.admin.LogDao;
import com.wzp.entity.admin.Log;
import com.wzp.service.admin.LogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class LogServiceImpl implements LogService
{
    @Autowired
    LogDao logDao;

    @Override
    public int add(Log log)
    {
        return logDao.add(log);
    }

    @Override
    public int addContent(String content)
    {
        Log log = new Log();
        log.setContent(content);
        log.setCreateTime(new Date());
        return logDao.add(log);
    }

    @Override
    public List<Log> selectList(Map<String, Object> postResults)
    {
        return logDao.selectList(postResults);
    }

    @Override
    public int selectTotal(Map<String, Object> postResults)
    {
        return logDao.selectTotal(postResults);
    }

    @Override
    public int deleteLog(String ids)
    {
        return logDao.deleteLog(ids);
    }
}
