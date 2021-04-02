package com.wzp.controller.admin;

import com.wzp.entity.admin.NewsCategory;
import com.wzp.page.admin.Page;
import com.wzp.service.admin.NewsCategoryService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 新闻分类控制器
 */
@Controller
@RequestMapping("/admin/news_category")
public class NewsCategoryController
{
    @Autowired
    NewsCategoryService newsCategoryService;

    /**
     * 新闻分类页面跳转
     * @param modelAndView
     * @return
     */
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public ModelAndView newsList(ModelAndView modelAndView)
    {
        modelAndView.setViewName("/news_category/list");
        return modelAndView;
    }

    /**
     * 新闻分类添加
     * @param newsCategory
     * @return
     */
    @RequestMapping(value = "/add", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> addList(NewsCategory newsCategory)
    {
        Map<String, String> result = new HashMap<>();
        if (newsCategory == null)
        {
            result.put("type", "error");
            result.put("msg", "请填写分类信息");
            return result;
        }

        if (StringUtils.isEmpty(newsCategory.getName()))
        {
            result.put("type", "error");
            result.put("msg", "请填写分类名称");
            return result;
        }

        if (newsCategoryService.add(newsCategory) <= 0)
        {
            result.put("type", "error");
            result.put("msg", "添加失败，请联系管理员");
            return result;
        }
        result.put("type", "success");
        result.put("msg", "添加成功");

        return result;
    }

    /**
     * 新闻分类编辑
     * @param newsCategory
     * @return
     */
    @RequestMapping(value = "/edit", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> editList(NewsCategory newsCategory)
    {
        Map<String, String> result = new HashMap<>();
        if (newsCategory == null)
        {
            result.put("type", "error");
            result.put("msg", "请填写分类信息");
            return result;
        }

        if (StringUtils.isEmpty(newsCategory.getName()))
        {
            result.put("type", "error");
            result.put("msg", "请填写分类名称");
            return result;
        }

        if (newsCategoryService.edit(newsCategory) <= 0)
        {
            result.put("type", "error");
            result.put("msg", "修改失败，请联系管理员");
            return result;
        }
        result.put("type", "success");
        result.put("msg", "修改成功");

        return result;
    }

    /**
     * 新闻分类删除
     * @param id
     * @return
     */
    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> deleteList(Long id)
    {
        Map<String, String> result = new HashMap<>();
        if (id == null)
        {
            result.put("type", "error");
            result.put("msg", "请选择要删除的数据");
            return result;
        }


        try
        {
            if (newsCategoryService.delete(id) <= 0)
            {
                result.put("type", "error");
                result.put("msg", "删除失败，请联系管理员");
                return result;
            }
        }
        catch (Exception e)
        {
            result.put("type", "error");
            result.put("msg", "该新闻分类下有新闻信息，不能删除");
            return result;
        }
        result.put("type", "success");
        result.put("msg", "删除成功");

        return result;
    }

    /**
     * 新闻分类模糊查询
     * @param page
     * @param name
     * @return
     */
    @RequestMapping(value = "/list", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> findList(Page page, @RequestParam(value = "name",required = false,defaultValue = "")String name )
    {
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> postResults = new HashMap<>();
        postResults.put("name", name);
        postResults.put("rows", page.getRows());
        postResults.put("offSet", page.getOffSet());

        List<NewsCategory> newsList = newsCategoryService.list(postResults);
        int total = newsCategoryService.getTotal(postResults);
        result.put("rows", newsList);
        result.put("total", total);
        return result;
    }


}
