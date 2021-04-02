package com.wzp.controller.home;

import com.wzp.entity.admin.Comment;
import com.wzp.entity.admin.News;
import com.wzp.entity.admin.NewsCategory;
import com.wzp.page.admin.Page;
import com.wzp.service.admin.CommentService;
import com.wzp.service.admin.NewsCategoryService;
import com.wzp.service.admin.NewsService;
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
import java.util.Map;

@Controller
@RequestMapping("/news")
public class HomeNewsController
{
    @Autowired
    NewsCategoryService newsCategoryService;
    @Autowired
    NewsService newsService;
    @Autowired
    CommentService commentService;

    /**
     * 按照分类显示新闻
     * @param modelAndView
     * @param cid
     * @param page
     * @return
     */
    @RequestMapping(value = "/category_list", method = RequestMethod.GET)
    public ModelAndView categoryList(ModelAndView modelAndView, @RequestParam(value = "cid",required = true)Long cid, Page page)
    {
        Map<String, Object> result = new HashMap<>();
        result.put("offSet", 0);
        result.put("rows", 10);
        result.put("categoryId", cid);
        modelAndView.addObject("newsCategoryList", newsCategoryService.getAll());
        modelAndView.addObject("newsList", newsService.list(result));
        modelAndView.setViewName("/home/news/category_list");
        NewsCategory newsCategory = newsCategoryService.findNewsCategoryById(cid);
        modelAndView.addObject("newsCategory", newsCategory);
        modelAndView.addObject("title", newsCategory.getName() + "分类下的新闻信息");

        return modelAndView;
    }

    @RequestMapping(value = "/detail", method = RequestMethod.GET)
    public ModelAndView newsDetail(Long id,ModelAndView modelAndView)
    {
        modelAndView.addObject("newsCategoryList", newsCategoryService.getAll());
        News news = newsService.getNewsById(id);
        modelAndView.addObject("news",news );
        modelAndView.addObject("tags", news.getTags().split(","));
        newsService.updateViewNumber(id);
        modelAndView.setViewName("/home/news/detail");
        return modelAndView;
    }

    /**
     * 获取最新评论新闻
     * @return
     */
    @RequestMapping(value = "/last_comment_list", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> lastComment()
    {
        Map<String, Object> result = new HashMap<>();
        result.put("type", "success");
        result.put("newsList", newsService.getLastCommentList(10));

        return result;
    }

    /**
     * 获取更多新闻
     * @return
     */
    @RequestMapping(value = "/get_category_list", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getCategoryList(@RequestParam(value = "cid",required = true)Long cid, Page page)
    {
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> postResults = new HashMap<>();
        postResults.put("offSet", page.getOffSet());
        postResults.put("rows", page.getRows());
        postResults.put("categoryId", cid);

        result.put("newsList", newsService.list(postResults));
        result.put("type", "success");

        return result;
    }

    /**
     * 根据关键字查找新闻
     * @param modelAndView
     * @param keyword
     * @param page
     * @return
     */
    @RequestMapping(value = "/search_list", method = RequestMethod.GET)
    public ModelAndView searchList(ModelAndView modelAndView, @RequestParam(value = "keyword",required = false,defaultValue = "")String keyword, Page page)
    {
        Map<String, Object> result = new HashMap<>();
        result.put("offSet", 0);
        result.put("rows", 10);
        result.put("title", keyword);
        modelAndView.addObject("newsCategoryList", newsCategoryService.getAll());
        modelAndView.addObject("newsList", newsService.list(result));
        modelAndView.addObject("keyword", keyword);
        modelAndView.addObject("title", keyword + "关键字下的新闻信息");
        modelAndView.setViewName("/home/news/search_list");

        return modelAndView;
    }

    /**
     * 分页获取查询的新闻
     * @param keyword
     * @param page
     * @return
     */
    @RequestMapping(value = "/get_search_list", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getSearchList(@RequestParam(value = "keyword",required = false,defaultValue = "")String keyword, Page page)
    {
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> postResults = new HashMap<>();
        postResults.put("offSet", page.getOffSet());
        postResults.put("rows", page.getRows());
        postResults.put("title", keyword);

        result.put("newsList", newsService.list(postResults));
        result.put("type", "success");

        return result;
    }

    /**
     * 添加新闻评论
     * @param comment
     * @return
     */
    @RequestMapping(value = "/comment_news", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> commentNews(Comment comment)
    {
        Map<String, Object> result = new HashMap<>();
        if (comment == null)
        {
            result.put("type", "error");
            result.put("msg", "请选择新闻进行评论");
            return result;
        }
        if (StringUtils.isEmpty(comment.getNickname()))
        {
            result.put("type", "error");
            result.put("msg", "请填写评论昵称");
            return result;
        }
        if (StringUtils.isEmpty(comment.getContent()))
        {
            result.put("type", "error");
            result.put("msg", "请填写评论内容");
            return result;
        }
        comment.setCreateTime(new Date());
        if (commentService.add(comment) <= 0)
        {
            result.put("type", "error");
            result.put("msg", "评论失败，请联系管理员");
            return result;
        }
        newsService.updateCommentNumber(comment.getNewsId());
        result.put("type", "success");
        result.put("createTime", comment.getCreateTime());
        return result;
    }

    /**
     * 获取该新闻下的所有评论
     * @param newsId
     * @param page
     * @return
     */
    @RequestMapping(value = "/get_comment_list", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getCommentList(Long newsId, Page page)
    {
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> postResults = new HashMap<>();
        postResults.put("offSet", page.getOffSet());
        postResults.put("rows", page.getRows());
        postResults.put("newsId", newsId);

        result.put("commentList", commentService.list(postResults));
        result.put("type", "success");

        return result;
    }
}
