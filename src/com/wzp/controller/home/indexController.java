package com.wzp.controller.home;

import com.wzp.service.admin.NewsCategoryService;
import com.wzp.service.admin.NewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * 前台首页控制器
 */
@RequestMapping("/index")
@Controller
public class indexController
{
    @Autowired
    NewsCategoryService newsCategoryService;
    @Autowired
    NewsService newsService;

    /**
     * 主页
     * @param modelAndView
     * @return
     */
    @RequestMapping(value = "/index" ,method = RequestMethod.GET)
    public ModelAndView index(ModelAndView modelAndView)
    {
        Map<String, Object> result = new HashMap<>();
        result.put("offSet", 0);
        result.put("rows", 10);
        modelAndView.addObject("newsList", newsService.list(result));
        modelAndView.addObject("newsCategoryList", newsCategoryService.getAll());
        modelAndView.setViewName("/home/index/index");
        return modelAndView;
    }

    @RequestMapping(value = "/get_info", method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> getInfo()
    {
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> postResults = new HashMap<>();
        postResults.put("offSet", 0);
        postResults.put("rows", 999);
        result.put("totalNews", newsService.getTotal(postResults));
        result.put("allTime", getDays("2020-9-2"));


        return result;
    }

    private long getDays(String data){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = null;
		try {
			startDate = sdf.parse(data);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Date endDate = new Date();
		long time = (endDate.getTime() - startDate.getTime())/1000/3600/24;
		return time;
	}
}
