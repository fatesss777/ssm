<%--
  Created by IntelliJ IDEA.
  User: 54799
  Date: 2020/8/27
  Time: 19:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="copyright" content="All Rights Reserved, Copyright (C) 2013, Wuyeguo, Ltd." />
    <title></title>
<link rel="stylesheet" type="text/css" href="../../../resources/admin/easyui/easyui/1.3.4/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="../../../resources/admin/easyui/css/wu.css" />
    <link rel="stylesheet" type="text/css" href="../../../resources/admin/easyui/css/icon.css" />
    <script type="text/javascript" src="../../../resources/admin/easyui/js/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="../../../resources/admin/easyui/easyui/1.3.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../../resources/admin/easyui/easyui/1.3.4/locale/easyui-lang-zh_CN.js"></script>
<body class="easyui-layout">
    <div class="easyui-layout" data-options="fit:true">
        <!-- Begin of toolbar -->
        <div id="edit-dialog" class="easyui-dialog" data-options="closed:false,iconCls:'icon-save',modal:true,title:'修改密码',buttons:[{text:'确认修改',iconCls: 'icon-ok',handler:submitEdit}]" style="width:450px; padding:10px;">
	<form id="edit-form" method="post">
        <table>
           <tr>
                <td width="60" align="right">用户名:</td>
                <td><input type="text" name="username" class="wu-text easyui-validatebox" readonly="readonly" value="${admin.username }" /></td>
            </tr>
            <tr>
                <td width="60" align="right">原密码:</td>
                <td><input type="password" id="oldPassword" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写密码'" /></td>
            </tr>
            <tr>
                <td width="60" align="right">新密码:</td>
                <td><input type="password" id="newPassword" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写密码'" /></td>
            </tr>
            <tr>
                <td width="60" align="right">重复新密码:</td>
                <td><input type="password" id="reNewPassword" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写密码'" /></td>
            </tr>
        </table>
    </form>
</div>
    </div>
</body>
<script type="text/javascript">
        function _PageLoadingTip_Closes() {
            $("#PageLoadingTip").fadeOut("normal", function () {
                $(this).remove();
            });
        }

        var _pageloding_pc;
        $.parser.onComplete = function () {
            if (_pageloding_pc) clearTimeout(_pageloding_pc);
            _pageloding_pc = setTimeout(_PageLoadingTip_Closes, 1000);
        }
</script>

<!-- End of easyui-dialog -->
<script type="text/javascript">

function submitEdit() {
    var validate=$('#edit-form').form("validate");
    if (!validate) {
            $.messager.alert("消息提醒","请检查你输入的数据","warning");
            return;
    }
    if ($('#newPassword').val() != $('#reNewPassword').val())
    {
        $.messager.alert("消息提醒","两次输入的密码不相同","warning");
            return;
    }

    $.ajax({
        url:'edit_password',
        type:'post',
        data:{newPassword:$('#newPassword').val(),oldPassword:$('#oldPassword').val()},
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
    })

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
</script>



