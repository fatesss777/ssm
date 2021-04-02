package com.wzp.controller.admin;

import com.wzp.entity.admin.Authority;
import com.wzp.entity.admin.Menu;
import com.wzp.entity.admin.Role;
import com.wzp.page.admin.Page;
import com.wzp.service.admin.AuthorityService;
import com.wzp.service.admin.MenuService;
import com.wzp.service.admin.RoleService;
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

@Controller
@RequestMapping("/admin/role")
public class RoleController
{
    @Autowired
    RoleService roleService;

    @Autowired
    AuthorityService authorityService;

    @Autowired
    MenuService menuService;

    /**
     * 角色页面
     * @param modelAndView
     * @return
     */
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public ModelAndView list(ModelAndView modelAndView)
    {
        modelAndView.setViewName("role/list");
        return modelAndView;
    }

    /**
     * 查询角色
     * @param page
     * @param name
     * @return
     */
    @RequestMapping(value = "/list", method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> roleList(Page page, @RequestParam(value = "name", required = false, defaultValue = "") String name)
    {
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> postResults = new HashMap<>();
        postResults.put("name", name);
        postResults.put("rows", page.getRows());
        postResults.put("offSet", page.getOffSet());

        int total = roleService.getTotal(postResults);
        List<Role> roles = roleService.selectRole(postResults);

        result.put("rows", roles);
        result.put("total", total);

        return result;
    }

    /**
     * 添加角色
     * @param role
     * @return
     */
    @RequestMapping(value = "/add", method = RequestMethod.POST)
    @ResponseBody
    public Map<String,String> addRole(Role role)
    {
        Map<String, String> result = new HashMap<>();
        if (role == null)
        {
            result.put("type", "error");
            result.put("msg", "请填写角色信息");
            return result;
        }
        if (StringUtils.isEmpty(role.getName()))
        {
            result.put("type", "error");
            result.put("msg", "请填写角色名称");
            return result;
        }
        int i = roleService.addRole(role);
        if (i <= 0)
        {
            result.put("type", "error");
            result.put("msg", "添加失败，请联系管理员");
            return result;
        }

        result.put("type", "success");
        result.put("msg", "添加成功");
        return result;
    }

    @RequestMapping(value = "/edit", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> editRole(Role role)
    {
        Map<String, String> result = new HashMap<>();
        if (role == null)
        {
            result.put("type", "error");
            result.put("msg", "请选择要修改的角色！");
        }

        if (StringUtils.isEmpty(role.getName()))
        {
            result.put("type", "error");
            result.put("msg", "请填写角色名称！");
        }
        int editRole = roleService.editRole(role);
        if (editRole <= 0)
        {
            result.put("type", "error");
            result.put("msg", "修改失败，请联系管理员！");
            return result;
        }
        result.put("type", "success");
        result.put("msg", "修改成功");

        return result;
    }

    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> deleteRole(@RequestParam(name = "id", required = true) Long id)
    {
        Map<String, String> result = new HashMap<>();
        if (id == null)
        {
            result.put("type", "error");
            result.put("msg", "请选择要删除的角色！");
        }
        int deleteRole = roleService.deleteRole(id);

        try
        {
            if (deleteRole <= 0)
            {
                result.put("type", "error");
                result.put("msg", "删除失败，请联系管理员！");
                return result;
            }
        }
        catch (Exception e)
        {
            result.put("type", "error");
            result.put("msg", "该角色下存在权限或者用户信息，不能删除！");
            return result;
        }

        result.put("type", "success");
        result.put("msg", "角色删除成功！");

        return result;
    }

    /**
     * 查询所有菜单
     *
     * @return
     */
    @RequestMapping(value = "/get_all_menu", method = RequestMethod.POST)
    @ResponseBody
    public List<Menu> getAllMenu()
    {
        Map<String, Object> map = new HashMap<>();
        map.put("offSet", 0);
        map.put("rows", 99999);
        List<Menu> menus = menuService.selectList(map);
        return menus;
    }

    @RequestMapping(value = "/add_authority", method = RequestMethod.POST)
    @ResponseBody
    public Map<String,String> addAuthority(@RequestParam(value = "ids",required = true)String ids,
                                           @RequestParam(value = "roleId",required = true)Long roleId)
    {
        Map<String, String> result = new HashMap<>();
        if (StringUtils.isEmpty(ids))
        {
            result.put("type", "error");
            result.put("msg", "请选择要添加的权限！");
            return result;
        }
        if (roleId == null)
        {
            result.put("type", "error");
            result.put("msg", "请选择要编辑的角色！");
            return result;
        }

        if (ids.contains(","))
        {
            ids = ids.substring(0, ids.length() - 1);
        }

        String[] idArr = ids.split(",");

        if (idArr.length > 0)
        {
            authorityService.deleltByRoleId(roleId);
        }

        for (String id:idArr)
        {
            Authority authority = new Authority();
            authority.setMenuId(Long.valueOf(id));
            authority.setRoleId(roleId);
            authorityService.add(authority);
        }

        result.put("type", "success");
        result.put("msg", "权限编辑成功！");
        return result;
    }

    /**
     * 根据角色id查找其拥有的权限
     * @param roleId
     * @return
     */
    @RequestMapping(value = "/get_role_authority", method = RequestMethod.POST)
    @ResponseBody
    public List<Authority> getAuthority(@RequestParam(name = "roleId", required = true) Long roleId)
    {
        return authorityService.selectListByRoleId(roleId);
    }
}
