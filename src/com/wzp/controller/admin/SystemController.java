package com.wzp.controller.admin;

import com.wzp.entity.admin.Authority;
import com.wzp.entity.admin.Menu;
import com.wzp.entity.admin.Role;
import com.wzp.entity.admin.User;
import com.wzp.service.admin.*;
import com.wzp.util.CpachaUtil;
import com.wzp.util.MenuUtil;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/system")
public class SystemController
{
    @Autowired
    UserService userService;
    @Autowired
    RoleService roleService;
    @Autowired
    MenuService menuService;
    @Autowired
    AuthorityService authorityService;
    @Autowired
    LogService logService;

    @RequestMapping(value = "/index",method = RequestMethod.GET)
    public ModelAndView helloWorld(ModelAndView model,HttpServletRequest request)
    {
        List<Menu> userMenus = (List<Menu>) request.getSession().getAttribute("userMenus");
        List<Menu> topMenuList = MenuUtil.getAllTopMenu(userMenus);
        List<Menu> secondMenuList = MenuUtil.getAllSecondMenu(userMenus);
        model.addObject("topMenuList", topMenuList);
        model.addObject("secondMenuList", secondMenuList);
        model.setViewName("system/index");
        return model;
}

    /**
     * 登录页面
     * @param model
     * @return
     */
    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public ModelAndView login(ModelAndView model)
    {
        model.setViewName("system/login");
        return model;
    }

    /**
     * 登出
     * @param request
     * @return
     */
    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logout(HttpServletRequest request)
    {
        HttpSession session = request.getSession();
        session.setAttribute("admin",null);
        session.setAttribute("role", null);
        session.setAttribute("userMenus",null);
        return "redirect:login";
    }

    /**
     * 修改密码页面跳转
     * @param model
     * @return
     */
    @RequestMapping(value = "/edit_password", method = RequestMethod.GET)
    public ModelAndView editPassword(ModelAndView model)
    {
        model.setViewName("system/edit_password");
        return model;
    }

    /**
     * 修改密码
     * @param newPassword
     * @param request
     * @return
     */
    @RequestMapping(value = "/edit_password", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> editPasswordAct(String newPassword,String oldPassword,HttpServletRequest request)
    {
        Map<String, String> result = new HashMap<>();

        if (StringUtils.isEmpty(newPassword))
        {
            result.put("type", "error");
            result.put("msg", "请填写新密码");
            return result;
        }

        User user = (User) request.getSession().getAttribute("admin");
        if (!user.getPassword().equals(oldPassword))
        {
            result.put("type", "error");
            result.put("msg", "原密码错误");
            return result;
        }

        user.setPassword(newPassword);

        if (userService.editPassword(user) <= 0)
        {
            result.put("type", "error");
            result.put("msg", "修改密码失败请联系管理员");
            return result;
        }

        result.put("type", "success");
        result.put("msg", "修改密码成功");
        logService.addContent("用户名为{" + user.getUsername() + "的用户修改密码成功");
        return result;
    }

    /**
     * 登录表单提交处理控制器
     * @param user 从前端ajax json获取相关属性值
     * @param captcha 从前端ajax json获取相关属性值
     * @return
     */
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> loginAct(User user,String captcha,HttpServletRequest request)
    {
        Map<String, String> result = new HashMap<>();
        if (user == null)
        {
            result.put("type", "error");
            result.put("msg", "请填写用户信息");
            return result;
        }

        if (StringUtils.isEmpty(captcha))
        {
            result.put("type", "error");
            result.put("msg", "请填写验证码");
            return result;
        }

        if (StringUtils.isEmpty(user.getUsername()))
        {
            result.put("type", "error");
            result.put("msg", "请填写用户名");
            return result;
        }

        if (StringUtils.isEmpty(user.getPassword()))
        {
            result.put("type", "error");
            result.put("msg", "请填写密码");
            return result;
        }

        Object loginCaptcha = request.getSession().getAttribute("loginCaptcha");
        if (loginCaptcha == null)
        {
            result.put("type", "error");
            result.put("msg", "会话超时");
            return result;
        }

        if (!loginCaptcha.toString().toUpperCase().equals(captcha.toUpperCase()))
        {
            result.put("type", "error");
            result.put("msg", "验证码不正确");
            logService.addContent("用户名为" + user.getUsername() + "的验证码添加错误");
            return result;
        }

        User userByName = userService.findUserByName(user.getUsername());
        request.getSession().setAttribute("admin",userByName);

        if (userByName == null)
        {
            result.put("type", "error");
            result.put("msg", "该用户不存在");
            logService.addContent("用户名为" + user.getUsername() + "的用户不存在");
            return result;
        }

        if (!userByName.getPassword().equals(user.getPassword()))
        {
            result.put("type", "error");
            result.put("msg", "密码错误");
            logService.addContent("用户名为" + user.getUsername() + "的密码错误");
            return result;
        }

        //查询用户的角色权限
        Role role = roleService.selectRoleById(userByName.getRoleId());
        List<Authority> authorities = authorityService.selectListByRoleId(role.getId());
        String ids = "";
        for (Authority authority :
                authorities)
        {
            ids += authority.getMenuId() + ",";
        }
        if (!StringUtils.isEmpty(ids))
        {
            ids = ids.substring(0, ids.length() - 1);
        }
        List<Menu> userMenus = menuService.selectMenusByIds(ids);
        request.getSession().setAttribute("role", role);
        request.getSession().setAttribute("userMenus",userMenus);
        result.put("type", "success");
        result.put("msg", "登录成功");
        logService.addContent("用户名为{" + user.getUsername() + "}，角色为{"+role.getName()+"}的用户登陆成功");
        return result;


    }

    /**
     * 登录完成后的首页
     * @param model
     * @return
     */
    @RequestMapping(value = "/welcome", method = RequestMethod.GET)
    public ModelAndView welcome(ModelAndView model)
    {
        model.setViewName("system/welcome");
        return model;
    }

    /**
     * 生成验证码
     * @param vcodeLen 验证码上的字符数
     * @param width 验证码宽度
     * @param height 验证码高度
     * @param captchaType 验证码对应的页面，默认是登录界面
     * @param request
     * @param response
     */
    @RequestMapping(value = "/get_captcha",method = RequestMethod.GET)
    public void generateCaptcha(
            @RequestParam(name = "vl",required = false,defaultValue = "4") Integer vcodeLen,
            @RequestParam(name = "w",required = false,defaultValue = "100") Integer width,
            @RequestParam(name = "h",required = false,defaultValue = "30") Integer height,
            @RequestParam(name = "type",required = true,defaultValue = "loginCaptcha") String captchaType,
            HttpServletRequest request, HttpServletResponse response
            )
    {
        CpachaUtil cpachaUtil = new CpachaUtil(vcodeLen,width,height);
        String generatorVCode = cpachaUtil.generatorVCode();//获取验证码上的文字
        request.getSession().setAttribute(captchaType,generatorVCode);
        BufferedImage generatorRotateVCodeImage = cpachaUtil.generatorRotateVCodeImage(generatorVCode, true);//获得旋转字体的验证码图片
        try
        {
            ImageIO.write(generatorRotateVCodeImage, "gif", response.getOutputStream());
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
    }

}
