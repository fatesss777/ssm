<%--
  Created by IntelliJ IDEA.
  User: 54799
  Date: 2020/8/1
  Time: 19:38
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
        <label>菜单名称：</label><input class="wu-text" id="menu_name" style="width:100px">
        <a href="#" onclick="search_menu();" class="easyui-linkbutton" iconCls="icon-search">开始检索</a>
</div>
</div>
    <style>
    .selected
    {
        background-color: red;
    }
    </style>
<!-- End of toolbar -->
<table id="data-datagrid" class="easyui-treegrid" toolbar="#wu-toolbar"></table>
</div>
        <!-- Begin of easyui-dialog -->
<div id="add-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:450px; padding:10px;">
        <form id="add-form" method="post">
                <table>
                        <tr>
                        <td width="60" >菜单名称:</td>
                        <td><input type="text" name="name" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写菜单名称'" /></td>
                        </tr>
                <tr>
                        <td align="right">上级菜单：</td>
                        <td>
                        <select name="parentId" class="easyui-combobox" panelHeight="auto" style="width:100px">
                            <option value="0">顶级分类</option>
                        <c:forEach items="${topList}" var="menu">
                            <option value="${menu.id}">${menu.name}</option>
                        </c:forEach>
                        </select>
                        </td>
                </tr>
                <tr>
                        <td align="right">菜单URL：</td>
                        <td><input type="text" name="url" class="wu-text" /></td>
                </tr>
                <tr>
                        <td align="right">菜单图标：</td>
                        <td>
                                <input type="text" id="add-icon" name="icon" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写菜单名称'" />
                                <a href="#" class="easyui-linkbutton" iconCls="icon-add" onclick="selectIcon()" plain="true">选择</a>
                        </td>

                </tr>
                </table>
        </form>
</div>

<div id="add-menu-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:450px; padding:10px;">
        <form id="add-menu-form" method="post">
                <table>
                        <tr>
                        <td width="60" >按钮名称:</td>
                        <td><input type="text" name="name" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写按钮名称'" /></td>
                        </tr>
                <tr>
                        <td align="right">上级菜单：</td>
                        <td>
                            <input type="hidden" name="parentId" id="add-menu-parent-id">
                            <input type="text" readonly="readonly" id="parent-menu" class="wu-text easyui-validatebox"  />

                        </td>
                </tr>
                <tr>
                        <td align="right">按钮事件：</td>
                        <td><input type="text" name="url" class="wu-text" /></td>
                </tr>
                <tr>
                        <td  align="right">按钮图标：</td>
                        <td>
                                <input type="text" id="add-menu-icon" name="icon" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写按钮名称'" />
                                <a href="#" class="easyui-linkbutton" iconCls="icon-add" onclick="selectIcon()" plain="true">选择</a>
                        </td>

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
                        <td width="60" >菜单名称:</td>
                        <td><input type="text" id="edit-name" name="name" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写菜单名称'" /></td>
                        </tr>
                <tr>
                        <td align="right">上级菜单：</td>
                        <td>
                        <select id="edit-parentId" name="parentId" class="easyui-combobox" panelHeight="auto" style="width:100px">
                            <option value="0">顶级菜单</option>
                        <c:forEach items="${topList}" var="menu">
                            <option value="${menu.id}">${menu.name}</option>
                        </c:forEach>
                        </select>
                        </td>
                </tr>
                <tr>
                        <td align="right">菜单URL：</td>
                        <td><input type="text" id="edit-url" name="url" class="wu-text" /></td>
                </tr>
                <tr>
                        <td  align="right">菜单图标：</td>
                        <td>
                                <input type="text" id="edit-icon" name="icon" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请选择图标'" />
                                <a href="#" class="easyui-linkbutton" iconCls="icon-add" onclick="selectIcon()" plain="true">选择</a>
                        </td>

                </tr>
                </table>
        </form>
</div>


<div id="select-icon-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width: 820px;height: 500px;padding:10px;" >
    <table id="icons-table" cellspacing="8" ></table>
</div>
<jsp:include page="../common/footer.jsp" flush="true"/>
<!-- End of easyui-dialog -->
<script type="text/javascript">


/**
* easyui框架载入数据
*/
$('#data-datagrid').treegrid({
    url:'../../admin/menu/list',
    rownumbers:true,
    singleSelect:true,
    pageSize:20,
    pagination:true,
    multiSort:true,
    fitColumns:true,
    idField:'id',
    treeField:'name',
    columns:[[
        { field:'name',title:'菜单名称',width:100,sortable:true},
        { field:'url',title:'菜单URL',width:180,sortable:true},
        { field:'icon',title:'菜单图标',width:100,formatter:function(value,index,row) {
        var test='<a class="'+value+'">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a>'
        return test+value;
    }}
    ]]
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
*打开按钮添加窗口
* */
function openAddMenu(){
    //$('#add-form').form('clear');
    var item = $('#data-datagrid').treegrid('getSelected');
        if (item==null||item.length==0)
        {
            $.messager.alert('信息提示','请选择要添加按钮的数据！','info');
            return;
        }
        if (item.parentId==0) {
            $.messager.alert('信息提示','请选择二级菜单！','info');
            return;
        }

        var parent=$('#data-datagrid').treegrid('getParent',item.id);
        if (parent.parentId!=0) {
            $.messager.alert('信息提示','请选择二级菜单！','info');
            return;
        }


    $('#add-menu-dialog').dialog({
        closed: false,
        modal:true,
        title: "添加按钮信息",
        buttons: [{
            text: '确定',
            iconCls: 'icon-ok',
            handler: function() {
                var validate=$('#add-menu-form').form("validate");
                if (!validate) {
                        $.messager.alert("消息提醒","请检查你输入的数据","warning");
                        return;
                }
                //获取表单数据，以键值对的形式返回
                var data=$('#add-menu-form').serialize();

                $.ajax({
                        url:'add',
                        data:data,
                        type:'post',
                        dataType:'json',
                        success:function(data){
                                if(data.type=='success'){
                                        $.messager.alert('信息提示','添加成功！','info');
                                        $('#add-menu-dialog').dialog('close');
                                        $("#data-datagrid").treegrid('reload');
                                }
                                else
                                {
                                        $.messager.alert('信息提示',data.msg,'warning');
                                }
                        }
                });
    }
        }, {
            text: '取消',
            iconCls: 'icon-cancel',
            handler: function () {
                $('#add-menu-dialog').dialog('close');
            }
        }],
        onBeforeOpen:function() {
            $('#parent-menu').val(item.name);
             $('#add-menu-parent-id').val(item.id);
    }

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
                url:'../../admin/menu/add',
                data:data,
                type:'post',
                dataType:'json',
                success:function(data){
                        if(data.type=='success'){
                                $.messager.alert('信息提示','添加成功！','info');
                                $('#add-dialog').dialog('close');
                                $("#data-datagrid").treegrid('reload');
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
    var item = $('#data-datagrid').treegrid('getSelected');
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
            $('#edit-name').val(item.name);
            $('#edit-parentId').combobox("setValue",item.parentId);
            $('#edit-parentId').combobox("readonly",false);
            var parent=$('#data-datagrid').treegrid('getParent',item.id);
            if (parent!=null)
            {
                if (parent.parentId!=0)
                {
                    $('#edit-parentId').combobox("readonly",true);
                    $('#edit-parentId').combobox("setText",parent.name);
                }
            }
            $('#edit-url').val(item.url);
            $('#edit-icon').val(item.icon);
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
                url:'../../admin/menu/edit',
                data:data,
                type:'post',
                dataType:'json',
                success:function(data){
                        if(data.type=='success'){
                                $.messager.alert('信息提示','修改成功！','info');
                                $('#edit-dialog').dialog('close');
                                $("#data-datagrid").treegrid('reload');
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
        var item = $('#data-datagrid').treegrid('getSelected');
        if (item==null||item.length==0)
        {
            $.messager.alert('信息提示','请选择要删除的数据！','info');
            return;
        }
        $.ajax({
                url:'../../admin/menu/delete',
                data:{id:item.id},
                type:'post',
                dataType:'json',
                success:function(data){
                        if(data.type=='success'){
                                $.messager.alert('信息提示','删除成功！','info');
                                $("#data-datagrid").treegrid('reload');
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
* 图标选择
*/
function selectIcon() {
    $.ajax({
            url:'../../admin/menu/get_icons',
            type:'post',
            dataType:'json',
            success:function(data){
                    if(data.type=='success'){
                        var icons=data.content;
                        var table="";
                    for (var i=0;i<icons.length;i++) {
                        /*将后端传来的图标放入table(select-icon-dialog)的td中*/
                        var body='<td class="icon-td"><a href="javascript:void(0)" onclick="clickIcon(this)" class="'+icons[i]+'">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a></td>';
                        if (i==0) {
                            table +='<tr>'+body;
                            continue;
                        }

                        if ((i+1)%24==0) {
                            table +=body+'</tr><tr>';
                            continue;
                        }

                        table+=body;

                    }
                        table+='</tr>';
                        $("#icons-table").append(table);
                    }
                    else
                    {
                            $.messager.alert('信息提示','提交失败！','info');
                    }
            }
        });

    $('#select-icon-dialog').dialog({
        closed: false,
        modal:true,
        title: "添加信息",
        buttons: [{
            text: '确定',
            iconCls: 'icon-ok',
            handler: function() {
                /*获取选中的图标并将其返回给添加页面*/
                var icon=$(".selected a").attr("class");
                $("#add-icon").val(icon);
                $("#edit-icon").val(icon);
                $("#add-menu-icon").val(icon);
                $('#select-icon-dialog').dialog('close');
    }
        }, {
            text: '取消',
            iconCls: 'icon-cancel',
            handler: function () {
                $('#select-icon-dialog').dialog('close');
            }
        }]
    });
    }

/**
*  点击图标显示选中效果
*/
function clickIcon(e) {
    $('.icon-td').removeClass("selected");
    $(e).parent("td").addClass("selected");
    }


/**
* 点击开始检索，向后台传值name
*/
function search_menu(){
    $('#data-datagrid').treegrid('reload',{
    name:$("#menu_name").val()
    });
}



</script>