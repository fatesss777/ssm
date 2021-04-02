<%--
  Created by IntelliJ IDEA.
  User: 54799
  Date: 2020/9/12
  Time: 9:44
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
        <label>新闻评论昵称：</label><input class="wu-text" id="search_nickname" style="width:100px">
        <label>新闻评论内容：</label><input class="wu-text" id="search_content" style="width:100px">
        <a href="#" onclick="search_comment();" class="easyui-linkbutton" iconCls="icon-search">开始检索</a>
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
                                <td width="60" align="right">新闻评论昵称:</td>
                                <td><input type="text" name="nickname" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写新闻评论昵称'" /></td>
                        </tr>
                        <tr>
                            <td width="60" align="right">所属新闻:</td>
                            <td>
                                <select name="newsId" class="easyui-combobox" panelHeight="auto" style="width:268px" data-options="required:true, missingMessage:'请选择所属新闻'">
                                    <c:forEach items="${newsList }" var="news">
                                    <option value="${news.id }">${news.title }</option>
                                    </c:forEach>
                                </select>
                            </td>
            	        </tr>
                        <tr>
                            <td>评论内容:</td>
                            <td>
                                <textarea name="content" rows="6" class="wu-textarea easyui-validatebox" style="width:260px" data-options="required:true,missingMessage:'请填写新闻内容'"></textarea>
                            </td>
	    		        </tr>
                </table>
        </form>
</div>

<div id="edit-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:450px; padding:10px;">
        <form id="edit-form" method="post">
                <%--设置主键隐藏，并且在openEdit里面要对其进行赋值--%>
                <input type="hidden" name="id" id="edit_id">
                <table>
                        <tr>
                            <td width="60" align="right">新闻评论昵称:</td>
                            <td><input type="text" id="edit_nickname" name="nickname" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写新闻评论昵称'" /></td>
                        </tr>
                        <tr>
                            <td width="60" align="right">所属新闻:</td>
                            <td>
                                <select name="newsId" id="edit_newsId" class="easyui-combobox" panelHeight="auto" style="width:268px" data-options="required:true, missingMessage:'请选择所属新闻'">
                                    <c:forEach items="${newsList }" var="news">
                                    <option value="${news.id }">${news.title }</option>
                                    </c:forEach>
                                </select>
                            </td>
            	        </tr>
                        <tr>
                            <td>评论内容:</td>
                            <td>
                                <textarea name="content" id="edit_content" rows="6" class="wu-textarea easyui-validatebox" style="width:260px" data-options="required:true,missingMessage:'请填写新闻内容'"></textarea>
                            </td>
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
    singleSelect:false,
    pageSize:20,
    pagination:true,
    multiSort:true,
    fitColumns:true,
    columns:[[
        { checkbox:true},
        { field:'nickname',title:'新闻评论昵称',width:100,sortable:true},
        { field:'newsId',title:'所属新闻',width:100,sortable:true,formatter:function (value, row, index) {
                return row.news.title;
            }},
        { field:'content',title:'评论内容',width:180,sortable:true},
        { field:'createTime',title:'创建时间',width:180,sortable:true,formatter:function (value, row, index) {
                return format(value);
            }},
    ]],
        onLoadSuccess: function (data) {
        }
});

/**
 * 时间戳转换
 * */
function add0(m){return m<10?'0'+m:m }
function format(value)
{
    //value是整数，否则要parseInt转换
    var time = new Date(value);
    var y = time.getFullYear();
    var m = time.getMonth()+1;
    var d = time.getDate();
    var h = time.getHours();
    var mm = time.getMinutes();
    var s = time.getSeconds();
    return y+'-'+add0(m)+'-'+add0(d)+' '+add0(h)+':'+add0(mm)+':'+add0(s);
}

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
            $('#edit_id').val(item.id);
            $('#edit_nickname').val(item.nickname);
            $('#edit_newsId').combobox('setValue',item.newsId);
            $('#edit_content').val(item.content);
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
function search_comment(){
    $('#data-datagrid').datagrid('reload',{
        nickname:$("#search_nickname").val(),
        content:$("#search_content").val()
    });
}



</script>


