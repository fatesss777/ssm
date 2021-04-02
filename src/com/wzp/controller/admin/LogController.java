package com.wzp.controller.admin;

import com.wzp.entity.admin.Log;
import com.wzp.entity.admin.User;
import com.wzp.page.admin.Page;
import com.wzp.service.admin.LogService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/log")
public class LogController
{
    @Autowired
    LogService logService;

    /**
     * 获取日志界面
     * @param modelAndView
     * @return
     */
    @RequestMapping(value = "/list",method = RequestMethod.GET)
    public ModelAndView list(ModelAndView modelAndView)
    {
        Map<String, Object> queryMap = new HashMap<>();
        modelAndView.setViewName("log/list");
        return modelAndView;
    }

    /**
     * 获取日志
     * @param page
     * @param content
     * @return
     */
    @RequestMapping(value = "/list", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> findList(Page page, @RequestParam(name = "content",required = false,defaultValue = "")String content)
    {
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> postResults = new HashMap<>();
        postResults.put("rows", page.getRows());
        postResults.put("offSet", page.getOffSet());
        postResults.put("content", content);
        List<Log> logs = logService.selectList(postResults);
        int total = logService.selectTotal(postResults);
        result.put("rows", logs);
        result.put("total", total);
        return result;
    }

    /**
     * 添加日志
     * @param log
     * @return
     */
    @RequestMapping(value = "/add", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> add(Log log)
    {
        Map<String, String> result = new HashMap<>();
        if (log == null)
        {
            result.put("type", "error");
            result.put("msg", "请填写正确日志信息");
            return result;
        }

        if (StringUtils.isEmpty(log.getContent()))
        {
            result.put("type", "error");
            result.put("msg", "请填写日志内容");
            return result;
        }
        log.setCreateTime(new Date());

        int add = logService.add(log);
        if (add <= 0)
        {
            result.put("type", "error");
            result.put("msg", "添加失败请联系管理员");
            return result;
        }
        result.put("type", "success");
        result.put("msg", "添加成功");

        return result;
    }

    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> delete(@RequestParam(name = "ids",required = true)String ids)
    {
        Map<String, String> result = new HashMap<>();
        if (ids == null)
        {
            result.put("type", "error");
            result.put("msg", "请选择正确日志信息");
            return result;
        }
        if (ids.contains(","))
        {
            ids = ids.substring(0, ids.length() - 1);
        }
        int delete = logService.deleteLog(ids);
        if (delete <= 0)
        {
            result.put("type", "error");
            result.put("msg", "删除失败请联系管理员");
            return result;
        }
        result.put("type", "success");
        result.put("msg", "删除成功");

        return result;
    }
}
