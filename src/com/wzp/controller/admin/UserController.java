package com.wzp.controller.admin;

import com.wzp.entity.admin.Menu;
import com.wzp.entity.admin.User;
import com.wzp.page.admin.Page;
import com.wzp.service.admin.RoleService;
import com.wzp.service.admin.UserService;
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

@RequestMapping("/admin/user")
@Controller
public class UserController
{
    @Autowired
    UserService userService;
    @Autowired
    RoleService roleService;

    /**
     * 获取用户界面
     * @param modelAndView
     * @return
     */
    @RequestMapping(value = "/list",method = RequestMethod.GET)
    public ModelAndView list(ModelAndView modelAndView)
    {
        Map<String, Object> queryMap = new HashMap<>();
        modelAndView.addObject("roleList", roleService.selectRole(queryMap));
        modelAndView.setViewName("user/list");
        return modelAndView;
    }

    /**
     * 查询用户
     * @param page
     * @param username
     * @param roleId
     * @param sex
     * @return
     */
    @RequestMapping(value = "/list", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> findList(Page page, @RequestParam(name = "username",required = false,defaultValue = "")String username,
                                        @RequestParam(name = "roleId",required = false)Long roleId,
                                        @RequestParam(name="sex",required = false)Integer sex)
    {
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> postResults = new HashMap<>();
        postResults.put("rows", page.getRows());
        postResults.put("offSet", page.getOffSet());
        postResults.put("username", username);
        postResults.put("roleId", roleId);
        postResults.put("sex", sex);
        List<User> menus = userService.selectUser(postResults);
        int total = userService.getTotal(postResults);
        result.put("rows", menus);
        result.put("total", total);

        return result;
    }

    /**
     * 添加用户
     * @param user
     * @return
     */
    @RequestMapping(value = "/add", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> add(User user)
    {
        Map<String, String> result = new HashMap<>();
        if (user == null)
        {
            result.put("type", "error");
            result.put("msg", "请填写正确用户信息");
            return result;
        }

        if (StringUtils.isEmpty(user.getUsername()))
        {
            result.put("type", "error");
            result.put("msg", "请填写用户名称");
            return result;
        }
        if (StringUtils.isEmpty(user.getPassword()))
        {
            result.put("type", "error");
            result.put("msg", "请填写用户密码");
            return result;
        }
        if (user.getRoleId() == null)
        {
            result.put("type", "error");
            result.put("msg", "请选择角色所属");
            return result;
        }
        if (isExist(user.getUsername(), 0l))
        {
            result.put("type", "error");
            result.put("msg", "该用户已存在");
            return result;
        }

        int add = userService.addUser(user);
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
     * 修改用户
     * @param user
     * @return
     */
    @RequestMapping(value = "/edit", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> edit(User user)
    {
        Map<String, String> result = new HashMap<>();
        if (user == null)
        {
            result.put("type", "error");
            result.put("msg", "请填写正确用户信息");
            return result;
        }

        if (StringUtils.isEmpty(user.getUsername()))
        {
            result.put("type", "error");
            result.put("msg", "请填写用户名称");
            return result;
        }

        if (user.getRoleId() == null)
        {
            result.put("type", "error");
            result.put("msg", "请选择角色所属");
            return result;
        }
        if (isExist(user.getUsername(), user.getId()))
        {
            result.put("type", "error");
            result.put("msg", "该用户已存在");
            return result;
        }

        int edit = userService.editUser(user);
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
     * 删除用户
     * @param ids
     * @return
     */
    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> delete(@RequestParam(name = "ids",required = true)String ids)
    {
        Map<String, String> result = new HashMap<>();
        if (ids == null)
        {
            result.put("type", "error");
            result.put("msg", "请选择正确用户信息");
            return result;
        }
        if (ids.contains(","))
        {
            ids = ids.substring(0, ids.length() - 1);
        }
        int delete = userService.deleteUser(ids);
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
        result.put("filepath", request.getServletContext().getContextPath() + "/resources/upload/" + filename);
        return result;
    }

    public boolean isExist(String username,Long id)
    {
        User userByName = userService.findUserByName(username);

        if (userByName == null)
        {
            return false;
        }
        if (userByName.getId().longValue() == id.longValue())
        {
            return false;
        }
        return true;
    }

}
