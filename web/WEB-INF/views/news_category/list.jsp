<%--
  Created by IntelliJ IDEA.
  User: 54799
  Date: 2020/9/7
  Time: 15:39
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
        <label>分类名称：</label><input class="wu-text" id="newsCategory_name" style="width:100px">
        <a href="#" onclick="search_newsCategory();" class="easyui-linkbutton" iconCls="icon-search">开始检索</a>
</div>
</div>
<!-- End of toolbar -->
<table id="data-datagrid" class="easyui-datagrid" toolbar="#wu-toolbar"></table>
</div>
        <!-- Begin of easyui-dialog -->
<div id="add-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:450px; padding:10px;">
        <form id="add-form" method="post">
                <table>
                        <tr>
                                <td width="60" align="right">分类名称:</td>
                                <td><input type="text" name="name" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写分类名称'" /></td>
                        </tr>

                        <tr>
                                <td align="right">排序：</td>
                                <td><input type="text" name="sort" class="wu-text easyui-validatebox easyui-numberbox" value="0" data-options="required:true, missingMessage:'请填写排序'" /></td>
                        </tr>
                </table>
        </form>
</div>

<div id="edit-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:450px; padding:10px;">
        <form id="edit-form" method="post">
                <%--设置主键隐藏，并且在openEdit里面要对其进行赋值--%>
                <input type="hidden" name="id" id="edit-id">
                <table>
                        <tr>
                                <td width="60" align="right">分类名称:</td>
                                <td><input type="text" id="edit_name" name="name" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写分类名称'" /></td>
                        </tr>

                        <tr>
                                <td align="right">排序：</td>
                                <td><input type="text" id="edit_sort" name="sort" class="wu-text easyui-validatebox easyui-numberbox" value="0" data-options="required:true, missingMessage:'请填写排序'" /></td>
                        </tr>
                </table>
        </form>
</div>
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
        { field:'name',title:'分类名称',width:100,sortable:true,formatter:function (value, row, index) {
            return '<a href="../../news/category_list?cid='+row.id+'"  target="_blank">'+value+'</a>'
            }},
        { field:'sort',title:'排序',width:180,sortable:true}
    ]],
        onLoadSuccess: function (data) {
        }
});

/**
* Name 打开添加窗口
*/
function openAdd(){
    //$('#add-form').form('clear');
    $('#add-dialog').dialog({
        closed: false,
        modal:true,
        title: "添加信息",
        buttons: [{
            text: '确定',
            iconCls: 'icon-ok',
            handler: add
        }, {
            text: '取消',
            iconCls: 'icon-cancel',
            handler: function () {
                $('#add-dialog').dialog('close');
            }
        }]
    });
}

/**
* Name 添加记录
*/
function add(){
        var validate=$('#add-form').form("validate");
        if (!validate) {
                $.messager.alert("消息提醒","请检查你输入的数据","warning");
                return;
        }
        //获取表单数据，以键值对的形式返回
        var data=$('#add-form').serialize();

        $.ajax({
                url:'add',
                data:data,
                type:'post',
                dataType:'json',
                success:function(data){
                        if(data.type=='success'){
                                $.messager.alert('信息提示',data.msg,'info');
                                $('#add-dialog').dialog('close');
                                $("#data-datagrid").datagrid('reload');
                        }
                        else
                        {
                                $.messager.alert('信息提示',data.msg,'warning');
                        }
                }
        });
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
    $('#edit-dialog').dialog({
        closed: false,
        modal:true,
        title: "修改信息",
        buttons: [{
            text: '确定',
            iconCls: 'icon-ok',
            handler: edit
            }, {
            text: '取消',
            iconCls: 'icon-cancel',
            handler: function () {
            $('#add-dialog').dialog('close');
            }
        }],
        onBeforeOpen:function() {
            $('#edit-id').val(item.id);
            $('#edit_name').val(item.name);
            $('#edit_sort').numberbox('setValue',item.sort);
    }
    });
}

/**
* Name 修改记录
*/
function edit(){
        /*easyui的form validate方法主要是验证那些numberbox，validatebox这些控件的validtype是否满足*/
        var validate=$('#edit-form').form("validate");
        if (!validate) {
                $.messager.alert("消息提醒","请检查你输入的数据","warning");
                return;
        }
        //获取表单数据，以键值对的形式返回
        var data=$('#edit-form').serialize();

        $.ajax({
                url:'edit',
                data:data,
                type:'post',
                dataType:'json',
                success:function(data){
                        if(data.type=='success'){
                                $.messager.alert('信息提示',data.msg,'info');
                                $('#edit-dialog').dialog('close');
                                $("#data-datagrid").datagrid('reload');
                        }
                        else
                        {
                                $.messager.alert('信息提示',data.msg,'warning');
                        }
                }
        });
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
function search_newsCategory(){
    $('#data-datagrid').datagrid('reload',{
    name:$("#newsCategory_name").val()
    });
}



</script>

