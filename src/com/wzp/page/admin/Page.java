package com.wzp.page.admin;

public class Page
{
    private int page = 1;//页码
    private int rows;//每页显示数量
    private int offSet;//数据库中的偏移量

    public int getPage()
    {
        return page;
    }

    public void setPage(int page)
    {
        this.page = page;
    }

    public int getRows()
    {
        return rows;
    }

    public void setRows(int rows)
    {
        this.rows = rows;
    }

    public int getOffSet()
    {
        this.offSet = (page - 1) * rows;
        return offSet;
    }

    public void setOffSet(int offSet)
    {
        this.offSet = offSet;
    }
}
