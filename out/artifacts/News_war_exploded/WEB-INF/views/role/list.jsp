<%--
  Created by IntelliJ IDEA.
  User: 54799
  Date: 2020/8/7
  Time: 11:02
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
        <label>角色名称：</label><input class="wu-text" id="role_name" style="width:100px">
        <a href="#" onclick="search_role();" class="easyui-linkbutton" iconCls="icon-search">开始检索</a>
</div>
</div>
    <style>
    .selected
    {
        background-color: red;
    }
    </style>
<!-- End of toolbar -->
<table id="data-datagrid" class="easyui-datagrid" toolbar="#wu-toolbar"></table>
</div>
        <!-- Begin of easyui-dialog -->
<div id="add-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:450px; padding:10px;">
        <form id="add-form" method="post">
                <table>
                        <tr>
                        <td width="60" align="right">角色名称:</td>
                        <td><input type="text" name="name" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写角色名称'" /></td>
                        </tr>

                <tr>
                        <td align="right">角色备注：</td>
                        <td><textarea name="remark" rows="6" class="wu-textarea" style="width:260px"></textarea></td>
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
                                <td width="60" align="right">角色名称:</td>
                                <td><input type="text" id="edit-name" name="name" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写角色名称'" /></td>
                        </tr>
                        <tr>
                                <td align="right">角色备注：</td>
                                <td><textarea id="edit-remark" name="remark" rows="6" class="wu-textarea" style="width:260px"></textarea></td>
                        </tr>
                </table>
        </form>
</div>
<div id="select-authority-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width: 350px;height: 500px;padding:10px;" >
    <ul id="authority-tree" url="get_all_menu" checkbox="true"></ul>
</div>
<jsp:include page="../common/footer.jsp" flush="true"/>

<!-- End of easyui-dialog -->
<script type="text/javascript">
/**
* easyui框架载入数据
*/
$('#data-datagrid').datagrid({
    url:'../../admin/role/list',
    rownumbers:true,
    singleSelect:true,
    pageSize:20,
    pagination:true,
    multiSort:true,
    fitColumns:true,
    columns:[[
        { checkbox:true},
        { field:'name',title:'角色名称',width:100,sortable:true},
        { field:'remark',title:'角色备注',width:180,sortable:true},
        { field:'icon',title:'权限操作',width:100,formatter:function(value,row,index) {
        var test='<a class="authority-edit" onclick="selectAuthority('+row.id+');"></a>'
        return test;
        }},
    ]],
        onLoadSuccess: function (data) {
            $('.authority-edit').linkbutton({text:'编辑权限',plain:true,iconCls:'icon-edit'});

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
                url:'../../admin/role/add',
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
            $('#edit-name').val(item.name);
            $('#edit-remark').val(item.remark);
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
                url:'../../admin/role/edit',
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
                url:'../../admin/role/delete',
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

var existAuthority = null;
function isAdded(row,rows) {
    for (var i = 0; i < existAuthority.length; i++) {
        if (existAuthority[i].menuId == row.id&&haveParent(rows,row.parentId)) {
            return true;
        }
    }
    return false;
}

//判断是否有父分类
function haveParent(rows, parentId){
        //查询所有父节点
        for(var i=0; i<rows.length; i++){
            if (rows[i].id == parentId)
            {
                    if (rows[i].parentId != 0) {
                            return true;
                    }
            }
        }
        return false;
    }

/**
 * easyui官方文档，转换原始数据到符合tree的要求
 * */
function exists(rows, parentId){
        //查询所有父节点
        for(var i=0; i<rows.length; i++){
            if (rows[i].id == parentId) return true;
        }
        return false;
    }
/**
 * easyui官方文档，转换原始数据到符合tree的要求
 * */
function convert(rows){

    var nodes = [];
    // 将所有父节点存到nodes中
    for(var i=0; i<rows.length; i++){
        var row = rows[i];
        if (!exists(rows, row.parentId)){
            nodes.push({
                id:row.id,
                text:row.name
            });
        }
    }
    //将nodes中的结点存入toDo中
    var toDo = [];
    for(var i=0; i<nodes.length; i++){
        toDo.push(nodes[i]);
    }
    while(toDo.length){
        var node = toDo.shift();    // 每次从toDo中取出一个结点赋值给node
        // 获取此父节点下的子节点
        for(var i=0; i<rows.length; i++){
            var row = rows[i];
            if (row.parentId == node.id){
                var child = {id:row.id,text:row.name};
                if (isAdded(row,rows)) {
                    child.checked = true;
                }
                if (node.children){
                    node.children.push(child);
                } else {
                    node.children = [child];
                }
                //将子节点也放入toDo中，因为这个子节点也可能是其他结点的父节点
                toDo.push(child);
            }
        }
    }
    return nodes;
}

/**
 * 选择权限
 * */
function selectAuthority(roleId) {
        $('#select-authority-dialog').dialog({
        closed: false,
        modal:true,
        title: "选择权限",
        buttons: [{
            text: '确定',
            iconCls: 'icon-ok',
            handler: function() {
                var nodes = $('#authority-tree').tree('getChecked');
                var ids = '';
                for (var i = 0; i < nodes.length; i++) {
                        ids += nodes[i].id + ',';

                }
                var nodes = $('#authority-tree').tree('getChecked', 'indeterminate');
                for (var i = 0; i < nodes.length; i++) {
                        ids += nodes[i].id + ',';

                }

                    //console.log(ids);
                if (ids != '') {
                    $.ajax({
                            url:'../../admin/role/add_authority',
                            data:{ids:ids,roleId:roleId},
                            type:'post',
                            dataType:'json',
                            success:function(data){
                                if(data.type=='success'){
                                        $.messager.alert('信息提示',data.msg,'info');
                                        $('#select-authority-dialog').dialog('close');
                                        $("#data-datagrid").datagrid('reload');
                                }
                                else
                                {
                                        $.messager.alert('信息提示',data.msg,'warning');
                                }
                            }
                    })

                }
                else
                {
                    $.messager.alert('信息提示','请至少选择一项权限','warning');
                }
    }
        }, {
            text: '取消',
            iconCls: 'icon-cancel',
            handler: function () {
                $('#select-authority-dialog').dialog('close');
            }
        }],
                onBeforeOpen:function () {

                        $.ajax({
                            url:'get_role_authority',
                            data:{roleId:roleId},
                            type:'post',
                            dataType:'json',
                            success: function (data) {
                                existAuthority = data;
                                $('#authority-tree').tree({
                                loadFilter: function(rows){
                                return convert(rows);
                                }
                        })

                            }
                        })


                }
    });

}

/**
* 图标选择
*/
function selectIcon() {
    $.ajax({
            url:'../admin/menu/get_icons',
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
                $("#icon").val(icon);
                $("#edit-icon").val(icon);
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
* 点击开始检索，向后台传值name
*/
function search_role(){
    $('#data-datagrid').datagrid('reload',{
    name:$("#role_name").val()
    });
}



</script>
