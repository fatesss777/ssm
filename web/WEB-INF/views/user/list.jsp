<%--
  Created by IntelliJ IDEA.
  User: 54799
  Date: 2020/8/17
  Time: 11:36
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
                <label>用户名：</label><input class="wu-text" id="search-user" style="width:100px">
                <label>所属角色：</label>
                <select id="search-role"  class="easyui-combobox" panelHeight="auto" style="width:100px">
                        <option value="-1">全部</option>
                    <c:forEach items="${roleList}" var="role">
                        <option value="${role.id}">${role.name}</option>
                    </c:forEach>
                </select>
            <label>性别：</label>
                <select id="search-sex" class="easyui-combobox" panelHeight="auto" style="width:100px">
                    <option value="-1">全部</option>
                    <option value="0">未知</option>
                    <option value="1">男</option>
                    <option value="2">女</option>
                </select>
            <a href="#" onclick="search_role();" class="easyui-linkbutton" iconCls="icon-search">开始检索</a>
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
                            <td width="60" align="right">头像预览:</td>
                            <td valign="middle">
                                <img src="/resources/admin/easyui/images/user_photo.jpg" id="preview_photo" style="float: left" width="100px">
                                <a style="float:left;margin-top:40px;" href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-upload" onclick="uploadPhoto()" plain="true">点击上传</a>
                            </td>
                        </tr>
                        <tr>
                            <td width="60" align="right">头像:</td>
                            <td><input type="text" id="add-photo" name="photo" value="/resources/admin/easyui/images/user_photo.jpg" class="wu-text "/></td>
                        </tr>
                        <tr>
                            <td width="60" align="right">用户名称:</td>
                            <td><input type="text" name="username" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写用户名称'" /></td>
                        </tr>

                        <tr>
                            <td width="60" align="right">密码:</td>
                            <td><input type="text" name="password" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写密码'" /></td>
                        </tr>
                        <tr>
                            <td width="60" align="right">所属角色:</td>
                            <td>
                                <select name="roleId" class="easyui-combobox" panelHeight="auto" style="width:100px">
                                <c:forEach items="${roleList}" var="role">
                                    <option value="${role.id}">${role.name}</option>
                                </c:forEach>
                            </select>
                            </td>
                        </tr>
                        <tr>
                            <td width="60" align="right">性别:</td>
                            <td>
                                <select name="sex" class="easyui-combobox" panelHeight="auto" style="width:100px">
                                <option value="0">未知</option>
                                <option value="1">男</option>
                                <option value="2">女</option>
                            </select>
                            </td>
                        </tr>
                        <tr>
                            <td width="60" align="right">年龄:</td>
                            <td><input type="text" name="age" class="wu-text easyui-validatebox easyui-numberbox" data-options="required:true,min:1,precision:0, missingMessage:'请填写年龄'" /></td>
                        </tr>
                        <tr>
                            <td width="60" align="right">住址:</td>
                            <td><input type="text" name="address" class="wu-text easyui-validatebox "  /></td>
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
                            <td width="60" align="right">头像预览:</td>
                            <td valign="middle">
                                <img src="/resources/admin/easyui/images/user_photo.jpg" id="edit_preview_photo" style="float: left" width="100px">
                                <a style="float:left;margin-top:40px;" href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-upload" onclick="uploadPhoto()" plain="true">点击上传</a>
                            </td>
                        </tr>
                        <tr>
                            <td width="60" align="right">头像:</td>
                            <td><input type="text" id="edit-photo" name="photo" value="/resources/admin/easyui/images/user_photo.jpg" class="wu-text "/></td>
                        </tr>
                        <tr>
                            <td width="60" align="right">用户名称:</td>
                            <td><input type="text" id="edit-username" name="username" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写用户名称'" /></td>
                        </tr>
                        <tr>
                            <td width="60" align="right">所属角色:</td>
                            <td>
                                <select id="edit-roleId" name="roleId" class="easyui-combobox" panelHeight="auto" style="width:100px">
                                <c:forEach items="${roleList}" var="role">
                                    <option value="${role.id}">${role.name}</option>
                                </c:forEach>
                            </select>
                            </td>
                        </tr>
                        <tr>
                            <td width="60" align="right">性别:</td>
                            <td>
                                <select id="edit-sex" name="sex" class="easyui-combobox" panelHeight="auto" style="width:100px">
                                <option value="0">未知</option>
                                <option value="1">男</option>
                                <option value="2">女</option>
                            </select>
                            </td>
                        </tr>
                        <tr>
                            <td width="60" align="right">年龄:</td>
                            <td><input type="text" id="edit-age" name="age" class="wu-text easyui-validatebox easyui-numberbox" data-options="required:true,min:1,precision:0, missingMessage:'请填写年龄'" /></td>
                        </tr>
                        <tr>
                            <td width="60" align="right">住址:</td>
                            <td><input type="text" id="edit-address" name="address" class="wu-text easyui-validatebox "  /></td>
                        </tr>
                </table>
        </form>
</div>
<div id="select-authority-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width: 350px;height: 500px;padding:10px;" >
    <ul id="authority-tree" url="get_all_menu" checkbox="true"></ul>
</div>
<div id="progress-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save',title:'文件上传中'" style="width:450px; padding:10px;">
        <div id="p" class="easyui-progressbar" style="width:400px;"data-options="text:'正在上传中'"></div>
</div>
<input type="file" id="photo-file" style="display: none" onchange="upload()">
<jsp:include page="../common/footer.jsp" flush="true"/>

<!-- End of easyui-dialog -->
<script type="text/javascript">

//图片上传
function start(){
			var value = $('#p').progressbar('getValue');
			if (value < 100){
				value += Math.floor(Math.random() * 10);
				$('#p').progressbar('setValue', value);

			}
			else
            {
                $('#p').progressbar('setValue', 0);
            }
		};
function upload() {
    if ($('#photo-file').val() == '') {
        return;
    }
    var formData = new FormData();
    formData.append("photo",document.getElementById('photo-file').files[0]);
    $('#progress-dialog').dialog('open');
    var interval=setInterval(start,200);
    $.ajax({
        url:'upload_photo',
        data:formData,
        type:'post',
        contentType:false,
        processData:false,
        success:function (data) {
            clearInterval(interval);
            $('#progress-dialog').dialog('close');
            if (data.type == 'success') {
                $('#preview_photo').attr('src',data.filepath);
                $('#add-photo').val(data.filepath);
                $('#edit_preview_photo').attr('src',data.filepath);
                $('#edit-photo').val(data.filepath);
            }
            else
            {
                $.messager.alert("消息提醒",data.msg,"warning");
            }

        },
        error:function (data) {
            clearInterval(interval);
            $('#progress-dialog').dialog('close');
            $.messager.alert("消息提醒","文件上传失败","warning");
        }
    })
}

function uploadPhoto()
{
    $('#photo-file').click();
}


/**
* easyui框架载入数据
*/
$('#data-datagrid').datagrid({
    url:'list',
    rownumbers:true,
    singleSelect:false,
    pageSize:20,
    pagination:true,
    multiSort:true,
    fitColumns:true,
    idField:'id',
    treeField:'name',
    columns:[[
        { checkbox:true},
        { field:'photo',title:'用户头像',width:100,formatter:function(value,row,index) {
            var img='<img src="'+value+'" width="50px"/>';
            return img;
        }},
        { field:'username',title:'用户名称',width:100,sortable:true},
        { field:'password',title:'密码',width:180,sortable:true},
        { field:'roleId',title:'角色所属',width:100,formatter:function(value,row,index) {
        var combobox = $('#search-role').combobox('getData');
        for (var i = 0; i < combobox.length; i++) {
            if (combobox[i].value == value) {
                return combobox[i].text;
            }
        }
        return value;
        }},
        { field:'sex',title:'性别',width:100,formatter:function(value,row,index) {
        switch (value) {
            case 0: return '未知';
            case 1: return '男';
            case 2: return '女';
        }
        }},
        { field:'age',title:'年龄',width:180,sortable:true},
        { field:'address',title:'用户住址',width:180,sortable:true},
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
        }],
        onBeforeOpen:function () {
            /*清空表单
            $('#add-form input').val('') ;*/
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
                url:'add',
                data:data,
                type:'post',
                dataType:'json',
                success:function(data){
                        if(data.type=='success'){
                                $.messager.alert('信息提示',data.msg,'info');
                                $('#add-dialog').dialog('close');
                                //$('#add-form').form('clear');
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
    var item = $('#data-datagrid').datagrid('getSelections');
    /*未点击要修改的菜单时*/
    if (item==null||item.length==0)
    {
        $.messager.alert('信息提示','请选择要修改的数据！','info');
        return;
    }

    if (item.length > 1) {
        $.messager.alert('信息提示','同时只能修改一条数据！','info');
        return;
    }
    item = item[0];
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
            $('#edit_preview_photo').attr('src',item.photo);
            $('#edit-photo').val(item.photo);
            $('#edit-username').val(item.username);
            $('#edit-roleId').combobox('setValue',item.roleId);
            $('#edit-sex').combobox('setValue',item.sex);
            $('#edit-age').numberbox('setValue', item.age);
            $('#edit-address').val(item.address);

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
        console.log(data);
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
    var item = $('#data-datagrid').datagrid('getSelections');
        if (item==null||item.length==0)
        {
            $.messager.alert('信息提示','请选择要删除的数据！','info');
            return;
        }
    $.messager.confirm('信息提示','确定要删除该记录？', function(result){
    if(result){

        var ids='';
        for (var i = 0; i < item.length; i++) {
            ids += item[i].id + ",";
        }

        $.ajax({
                url:'delete',
                data:{ids:ids},
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
function search_role(){
    var roleId = $("#search-role").combobox('getValue');
    var sex = $("#search-sex").combobox('getValue');
    var option={username:$("#search-user").val()};
    if (roleId != -1) {
        option.roleId = roleId;
    }
    if (sex != -1) {
        option.sex = sex;
    }
    $('#data-datagrid').datagrid('reload',option);
}



</script>

