package com.wzp.controller.admin;

import com.wzp.entity.admin.News;
import com.wzp.page.admin.Page;
import com.wzp.service.admin.NewsCategoryService;
import com.wzp.service.admin.NewsService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 新闻控制器
 */
@Controller
@RequestMapping("/admin/news")
public class NewsController
{
    @Autowired
    NewsCategoryService newsCategoryService;
    @Autowired
    NewsService newsService;

    /**
     * 新闻分类页面跳转
     * @param modelAndView
     * @return
     */
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public ModelAndView newsList(ModelAndView modelAndView)
    {
        modelAndView.setViewName("/news/list");
        modelAndView.addObject("newsCategoryList", newsCategoryService.getAll());
        return modelAndView;
    }

    /**
     * 新闻添加页面跳转
     * @param modelAndView
     * @return
     */
    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public ModelAndView addWindow(ModelAndView modelAndView)
    {
        modelAndView.setViewName("/news/add");
        modelAndView.addObject("newsCategoryList", newsCategoryService.getAll());
        return modelAndView;
    }
    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public ModelAndView editWindow(ModelAndView modelAndView ,Long id)
    {
        modelAndView.setViewName("/news/edit");
        modelAndView.addObject("newsCategoryList", newsCategoryService.getAll());
        modelAndView.addObject("news",newsService.getNewsById(id));
        return modelAndView;
    }
    /**
     * 新闻分类添加
     * @param news
     * @return
     */
    @RequestMapping(value = "/add", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> addList(News news)
    {
        Map<String, String> result = new HashMap<>();
        if (news == null)
        {
            result.put("type", "error");
            result.put("msg", "请填写新闻信息");
            return result;
        }
        if (news.getCategoryId() == null)
        {
            result.put("type", "error");
            result.put("msg", "请选择所属分类");
            return result;
        }

        if (StringUtils.isEmpty(news.getTitle()))
        {
            result.put("type", "error");
            result.put("msg", "请填写新闻标题");
            return result;
        }
        if (StringUtils.isEmpty(news.getAbstrs()))
        {
            result.put("type", "error");
            result.put("msg", "请填写新闻摘要");
            return result;
        }
        if (StringUtils.isEmpty(news.getAuthor()))
        {
            result.put("type", "error");
            result.put("msg", "请填写新闻作者");
            return result;
        }
        if (StringUtils.isEmpty(news.getContent()))
        {
            result.put("type", "error");
            result.put("msg", "请填写新闻内容");
            return result;
        }
        if (StringUtils.isEmpty(news.getTags()))
        {
            result.put("type", "error");
            result.put("msg", "请填写新闻标签");
            return result;
        }
        if (StringUtils.isEmpty(news.getPhoto()))
        {
            result.put("type", "error");
            result.put("msg", "新闻图片必须上传");
            return result;
        }

        news.setCreateTime(new Date());
        if (newsService.add(news) <= 0)
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
     * 新闻编辑
     * @param news
     * @return
     */
    @RequestMapping(value = "/edit", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> editList(News news)
    {
        Map<String, String> result = new HashMap<>();
        if (news == null)
        {
            result.put("type", "error");
            result.put("msg", "请填写新闻信息");
            return result;
        }
        if (news.getCategoryId() == null)
        {
            result.put("type", "error");
            result.put("msg", "请选择所属分类");
            return result;
        }

        if (StringUtils.isEmpty(news.getTitle()))
        {
            result.put("type", "error");
            result.put("msg", "请填写新闻标题");
            return result;
        }
        if (StringUtils.isEmpty(news.getAbstrs()))
        {
            result.put("type", "error");
            result.put("msg", "请填写新闻摘要");
            return result;
        }
        if (StringUtils.isEmpty(news.getAuthor()))
        {
            result.put("type", "error");
            result.put("msg", "请填写新闻作者");
            return result;
        }
        if (StringUtils.isEmpty(news.getContent()))
        {
            result.put("type", "error");
            result.put("msg", "请填写新闻内容");
            return result;
        }
        if (StringUtils.isEmpty(news.getTags()))
        {
            result.put("type", "error");
            result.put("msg", "请填写新闻标签");
            return result;
        }
        if (StringUtils.isEmpty(news.getPhoto()))
        {
            result.put("type", "error");
            result.put("msg", "新闻图片必须上传");
            return result;
        }

        if (newsService.edit(news) <= 0)
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
            if (newsService.delete(id) <= 0)
            {
                result.put("type", "error");
                result.put("msg", "删除失败，请联系管理员");
                return result;
            }
        }
        catch (Exception e)
        {
            result.put("type", "error");
                result.put("msg", "该新闻下存在评论，不能删除");
                return result;
        }
        result.put("type", "success");
        result.put("msg", "删除成功");

        return result;
    }

    /**
     * 新闻模糊查询
     * @param page
     * @param
     * @return
     */
    @RequestMapping(value = "/list", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> findList(Page page, @RequestParam(value = "title",required = false,defaultValue = "")String title,
                                        @RequestParam(value = "author",required = false)String author,
                                        @RequestParam(value = "categoryId",required = false)Long categoryId)
    {
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> postResults = new HashMap<>();
        postResults.put("title", title);
        postResults.put("author", author);
        if(categoryId != null && categoryId.longValue() != -1){
			postResults.put("categoryId", categoryId);
		}
        postResults.put("rows", page.getRows());
        postResults.put("offSet", page.getOffSet());

        List<News> newsList = newsService.list(postResults);
        int total = newsService.getTotal(postResults);
        result.put("rows", newsList);
        result.put("total", total);
        return result;
    }

    /**
     * 文件上传，idea默认存放在out文件夹中
     * @param photo
     * @param request
     * @return
     */
    @RequestMapping(value = "/upload_photo", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> upload_photo(MultipartFile photo, HttpServletRequest request)
    {
        Map<String, String> result = new HashMap<>();
        //判断从前端获取到图片没
        if (photo == null)
        {
            result.put("type", "error");
            result.put("msg", "请选择要上传的文件");
            return result;
        }
        //判断获取到的图片大小
        if (photo.getSize() > 1024 * 1024 * 1024)
        {
            result.put("type", "error");
            result.put("msg", "图片大小大于10M，请重新上传");
            return result;
        }
        //获取图片后缀
        String suffix=photo.getOriginalFilename().substring(photo.getOriginalFilename().lastIndexOf(".") + 1, photo.getOriginalFilename().length());
        //判断获取到的图片格式
        if (!"jpg,jpeg,gif,png".contains(suffix))
        {
            result.put("type", "error");
            result.put("msg", "请选择jpg,jpeg,gif,png格式的图片");
            return result;
        }
        //创建保存路径
        String savePath = request.getServletContext().getRealPath("/") + "/resources/upload/";
        //判断保存路径是否存在
        File saveFilePath = new File(savePath);
        if (!saveFilePath.exists())
        {
            //若不存在则创建该目录
            saveFilePath.mkdir();
        }
        String filename = new Date().getTime() + "." + suffix;

        //将文件保存至指定目录
        try
        {
            photo.transferTo(new File(savePath+filename));
        }
        catch (IOException e)
        {
            result.put("type", "error");
            result.put("msg", "保存文件异常");
            e.printStackTrace();
            return result;
        }

        result.put("type", "success");
        result.put("msg", "图片上传成功");
        //注意：与getRealPath的区别
        result.put("filepath", "/resources/upload/" + filename);
        return result;
    }
}
