<%--
  Created by IntelliJ IDEA.
  User: 54799
  Date: 2020/9/9
  Time: 15:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../common/header.jsp" flush="true"/>
<div class="easyui-layout" data-options="fit:true">
<!-- Begin of toolbar -->
<div id="wu-toolbar-2">
<div class="wu-toolbar-button">
    <jsp:include page="../common/menus.jsp" flush="true"/>
</div>
<div class="wu-toolbar-search">
        <label>新闻标题：</label><input class="wu-text" id="search_news_title" style="width:100px">
        <label>新闻作者：</label><input class="wu-text" id="search_news_author" style="width:100px">
        <label>所属分类：</label>
                <select id="search-newsCategory"  class="easyui-combobox" panelHeight="auto" style="width:100px">
                        <option value="-1">全部</option>
                    <c:forEach items="${newsCategoryList}" var="newsCategoryList">
                        <option value="${newsCategoryList.id}">${newsCategoryList.name}</option>
                    </c:forEach>
                </select>
        <a href="#" onclick="search_news();" class="easyui-linkbutton" iconCls="icon-search">开始检索</a>
</div>
</div>
<!-- End of toolbar -->
<table id="data-datagrid" class="easyui-datagrid" toolbar="#wu-toolbar"></table>
</div>
        <!-- Begin of easyui-dialog -->

<jsp:include page="../common/footer.jsp" flush="true"/>

<!-- End of easyui-dialog -->
<script type="text/javascript">
/**
* easyui框架载入数据
*/
$('#data-datagrid').datagrid({
    url:'list',
    rownumbers:true,
    singleSelect:true,
    pageSize:20,
    pagination:true,
    multiSort:true,
    fitColumns:true,
    columns:[[
        { checkbox:true},
        { field:'title',title:'标题',width:150,formatter:function (value, row, index) {
            return '<a href="../../news/detail?id='+row.id+'"  target="_blank">'+value+'</a>'
            }},
        { field:'categoryId',title:'分类',width:30,formatter:function (value, row, index) {
                return row.newsCategory.name;
            }},
        { field:'author',title:'作者',width:30},
        { field:'tags',title:'标签',width:100},
        { field:'viewNumber',title:'浏览量',width:100,sortable:true},
        { field:'commentNumber',title:'评论数',width:100,sortable:true},
    ]],
        onLoadSuccess: function (data) {
        }
});

/**
* Name 打开添加窗口
*/
function openAdd(){
        window.location.href = 'add';
}



/**
* Name 打开修改窗口
*/
function openEdit(){
    //$('#edit-form').form('clear');
    var item = $('#data-datagrid').datagrid('getSelected');
    /*未点击要修改的菜单时*/
    if (item==null||item.length==0)
    {
        $.messager.alert('信息提示','请选择要修改的数据！','info');
        return;
    }
    window.location.href = 'edit?id='+item.id;
}


/**
* Name 删除记录
*/
function remove(){
    $.messager.confirm('信息提示','确定要删除该记录？', function(result){
    if(result){
        var item = $('#data-datagrid').datagrid('getSelected');
        if (item==null||item.length==0)
        {
            $.messager.alert('信息提示','请选择要删除的数据！','info');
            return;
        }
        $.ajax({
                url:'delete',
                data:{id:item.id},
                type:'post',
                dataType:'json',
                success:function(data){
                        if(data.type=='success'){
                                $.messager.alert('信息提示',data.msg,'info');
                                $("#data-datagrid").datagrid('reload');
                        }
                        else
                        {
                                $.messager.alert('信息提示',data.msg,'warning');
                        }
                }
        });
    }
    });
}


/**
* 点击开始检索，向后台传值name
*/
function search_news(){
    $('#data-datagrid').datagrid('reload',{
    title:$("#search_news_title").val(),
    author:$("#search_news_author").val(),
    categoryId:$('#search-newsCategory').combobox('getValue')
    });
}



</script>


