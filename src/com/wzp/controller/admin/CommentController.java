package com.wzp.controller.admin;

import com.wzp.entity.admin.Comment;
import com.wzp.page.admin.Page;
import com.wzp.service.admin.CommentService;
import com.wzp.service.admin.NewsService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 新闻评论控制器
 */
@Controller
@RequestMapping("/admin/comment")
public class CommentController
{
    @Autowired
    NewsService newsService;
    @Autowired
    CommentService commentService;

    /**
     * 新闻评论页面跳转
     * @param modelAndView
     * @return
     */
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public ModelAndView commentList(ModelAndView modelAndView)
    {
        modelAndView.setViewName("/comment/list");
        Map<String, Object> postResults = new HashMap<>();
        postResults.put("rows", 999);
        postResults.put("offSet", 0);
        modelAndView.addObject("newsList",newsService.list(postResults));
        return modelAndView;
    }

    /**
     * 新闻评论添加
     * @param comment
     * @return
     */
    @RequestMapping(value = "/add", method = RequestMethod.POST)
    @ResponseBody
        public Map<String, String> addList(Comment comment)
    {
        Map<String, String> result = new HashMap<>();
        if (comment == null)
        {
            result.put("type", "error");
            result.put("msg", "请填写评论信息");
            return result;
        }
        if (comment.getNewsId() == null)
        {
             result.put("type", "error");
            result.put("msg", "请选择要评论的新闻");
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
        Date date=new Date();

        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-ddHH:mm:ss");

        String time=sdf.format(date);
        System.out.println(time);
        comment.setCreateTime(date);

        if (commentService.add(comment) <= 0)
        {
            result.put("type", "error");
            result.put("msg", "添加失败，请联系管理员");
            return result;
        }

        newsService.updateCommentNumber(comment.getNewsId());
        result.put("type", "success");
        result.put("msg", "添加成功");

        return result;
    }

    /**
     * 新闻评论编辑
     * @param comment
     * @return
     */
    @RequestMapping(value = "/edit", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> editList(Comment comment)
    {
         Map<String, String> result = new HashMap<>();
        if (comment == null)
        {
            result.put("type", "error");
            result.put("msg", "请填写评论信息");
            return result;
        }
        if (comment.getNewsId() == null)
        {
             result.put("type", "error");
            result.put("msg", "请选择要评论的新闻");
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
        if (commentService.edit(comment) <= 0)
        {
            result.put("type", "error");
            result.put("msg", "编辑失败，请联系管理员");
            return result;
        }
        result.put("type", "success");
        result.put("msg", "编辑成功");

        return result;
    }

    /**
     * 新闻评论删除
     * @param ids
     * @return
     */
    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> deleteList(@RequestParam(name = "ids",required = true)String ids)
    {
        Map<String, String> result = new HashMap<>();
        if (ids == null)
        {
            result.put("type", "error");
            result.put("msg", "请选择正确评论信息");
            return result;
        }
        if (ids.contains(","))
        {
            ids = ids.substring(0, ids.length() - 1);
        }
        int delete = commentService.delete(ids);
        if (delete <= 0)
        {
            result.put("type", "error");
            result.put("msg", "删除失败,请联系管理员");
            return result;
        }
        result.put("type", "success");
        result.put("msg", "删除成功");

        return result;
    }

    /**
     * 新闻评论模糊查询
     * @param page
     * @param nickname,content
     * @return
     */
    @RequestMapping(value = "/list", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> findList(Page page, @RequestParam(value = "nickname",required = false,defaultValue = "")String nickname,
                                        @RequestParam(value = "content",required = false,defaultValue = "")String content)
    {
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> postResults = new HashMap<>();
        postResults.put("nickname", nickname);
        postResults.put("content", content);
        postResults.put("rows", page.getRows());
        postResults.put("offSet", page.getOffSet());

        List<Comment> newsList = commentService.list(postResults);
        int total = commentService.getTotal(postResults);
        result.put("rows", newsList);
        result.put("total", total);
        return result;
    }


}
