package com.wzp.controller.admin;

import com.wzp.entity.admin.Menu;
import com.wzp.page.admin.Page;
import com.wzp.service.admin.MenuService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/menu")
public class MenuController
{
    @Autowired
    private MenuService menuService;

    /**
     * 菜单首页
     *
     * @param modelAndView
     * @return
     */
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public ModelAndView list(ModelAndView modelAndView)
    {
        modelAndView.addObject("topList", menuService.selectTopList());
        modelAndView.setViewName("menu/list");
        return modelAndView;
    }

    /**
     * 查询菜单（前端返回了page和rows,name?）
     * @param page
     * @param name
     * @return
     */
    @RequestMapping(value = "/list", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> findList(Page page, @RequestParam(name = "name",required = false,defaultValue = "")String name)
    {
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> postResults = new HashMap<>();
        postResults.put("rows", page.getRows());
        postResults.put("offSet", page.getOffSet());
        postResults.put("name", name);
        List<Menu> menus = menuService.selectList(postResults);
        int total = menuService.selectTotal(postResults);
        result.put("rows", menus);
        result.put("total", total);

        return result;
    }

    /**
     * 获取resource文件夹下的icon图标
     * @return
     */
    @RequestMapping(value = "/get_icons", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> findList(HttpServletRequest request)
    {
        Map<String, Object> result = new HashMap<>();
        //获取根目录web
        String realPath = request.getServletContext().getRealPath("/");
        File file = new File(realPath + "\\resources\\admin\\easyui\\css\\icons");
        List<String> icons = new ArrayList<>();
        if (!file.exists())
        {
            result.put("type", "error");
            result.put("msg", "文件不存在");
            return result;
        }
        File[] files = file.listFiles();
        for (File f:files)
        {
            if (f != null && f.getName().contains("png"))
            {
                icons.add("icon-" + f.getName().substring(0, f.getName().indexOf(".")).replace("_", "-"));
            }
        }

        result.put("type", "success");
        result.put("content", icons);
        return result;
    }

    /**
     * 添加菜单
     * @param menu
     * @return
     */
    @RequestMapping(value = "/add", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> add(Menu menu)
    {
        Map<String, String> result = new HashMap<>();
        if (menu == null)
        {
            result.put("type", "error");
            result.put("msg", "请填写正确菜单信息");
            return result;
        }

        if (StringUtils.isEmpty(menu.getName()))
        {
            result.put("type", "error");
            result.put("msg", "请填写菜单名称");
            return result;
        }

        if (StringUtils.isEmpty(menu.getIcon()))
        {
            result.put("type", "error");
            result.put("msg", "请填写菜单图标");
            return result;
        }
        if (menu.getParentId() == null)
        {
            menu.setParentId(0L);
        }

        int add = menuService.add(menu);
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

    /**
     * 修改菜单
     * @param menu
     * @return
     */
    @RequestMapping(value = "/edit", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> edit(Menu menu)
    {
        Map<String, String> result = new HashMap<>();
        if (menu == null)
        {
            result.put("type", "error");
            result.put("msg", "请填写正确菜单信息");
            return result;
        }

        if (StringUtils.isEmpty(menu.getName()))
        {
            result.put("type", "error");
            result.put("msg", "请填写菜单名称");
            return result;
        }

        if (StringUtils.isEmpty(menu.getIcon()))
        {
            result.put("type", "error");
            result.put("msg", "请填写菜单图标");
            return result;
        }
        if (menu.getParentId() == null)
        {
            menu.setParentId(0L);
        }

        int edit = menuService.edit(menu);
        if (edit <= 0)
        {
            result.put("type", "error");
            result.put("msg", "修改失败请联系管理员");
            return result;
        }
        result.put("type", "success");
        result.put("msg", "修改成功");

        return result;
    }

    /**
     * 删除菜单
     * @param id
     * @return
     */
    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> delete(@RequestParam(name = "id",required = true)Long id)
    {
        Map<String, String> result = new HashMap<>();
        if (id == null)
        {
            result.put("type", "error");
            result.put("msg", "请选择正确菜单信息");
            return result;
        }
        List<Menu> menus = menuService.selectChildrenList(id);
        if (menus != null && menus.size() > 0)
        {
            result.put("type", "error");
            result.put("msg", "此目录下有子目录不能删除");
            return result;
        }
        int delete = menuService.delete(id);
        if (delete <= 0)
        {
            result.put("type", "error");
            result.put("msg", "删除失败请联系管理员");
            return result;
        }
        result.put("type", "success");
        result.put("msg", "修改成功");

        return result;
    }
}
