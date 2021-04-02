package com.wzp.util;

import com.wzp.entity.admin.Menu;

import java.util.ArrayList;
import java.util.List;

/**
 * 关于菜单操作的公用方法
 */
public class MenuUtil
{
    public static List<Menu> getAllTopMenu(List<Menu> menuList)
    {
        List<Menu> result = new ArrayList<>();
        for (Menu menu :
                menuList)
        {
            if (menu.getParentId() == 0)
            {
                result.add(menu);
            }
        }
        return result;
    }

    public static List<Menu> getAllSecondMenu(List<Menu> menuList)
    {
        List<Menu> result = new ArrayList<>();
        List<Menu> allTopMenu = getAllTopMenu(menuList);
        for (Menu menu:
             menuList)
        {
            for (Menu topMenu :
                    allTopMenu)
            {
                if (menu.getParentId() == topMenu.getId())
                {
                    result.add(menu);
                    break;
                }
            }
        }
        return result;
    }
    
    public static List<Menu> getAllThirdMenu(List<Menu> menuList,Long secondMenuId)
    {
        List<Menu> result = new ArrayList<>();
        for (Menu menu :
                menuList)
        {
            if (menu.getParentId() == secondMenuId)
            {
                result.add(menu);
            }
        }
        return result;
    }
}
