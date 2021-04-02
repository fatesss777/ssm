<%--
  Created by IntelliJ IDEA.
  User: 54799
  Date: 2020/9/9
  Time: 16:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../common/header.jsp" flush="true"/>
<div class="easyui-panel" title="编辑新闻页面" iconCls="icon-edit" fit="true" >
		<div style="padding:10px 60px 20px 60px">
	    <form id="edit-form" method="post">
	    	<table cellpadding="5">
				<input type="hidden" name="id" id="edit-id" value="${news.id}">
	    		<tr>
	    			<td>新闻标题:</td>
	    			<td><input class="wu-text easyui-textbox easyui-validatebox" type="text" name="title" data-options="required:true,missingMessage:'请填写新闻标题'" value="${news.title}"></input></td>
	    		</tr>
	    		<tr>
	                <td width="60" align="right">所属分类:</td>
	                <td>
	                	<select name="categoryId" class="easyui-combobox" panelHeight="auto" style="width:268px" data-options="required:true, missingMessage:'请选择所属分类'">
							 <c:forEach items="${newsCategoryList }" var="category">
			                	<c:if test="${news.categoryId == category.id }">
			                		<option value="${category.id }" selected >${category.name }</option>
			                	</c:if>
			                	<c:if test="${news.categoryId != category.id }">
			                		<option value="${category.id }" >${category.name }</option>
			                	</c:if>
			                </c:forEach>
			            </select>
	                </td>
            	</tr>
	    		<tr>
	    			<td>摘要:</td>
	    			<td>
	    				<textarea name="abstrs" rows="6" class="wu-textarea easyui-validatebox" style="width:260px" data-options="required:true,missingMessage:'请填写新闻摘要'" >${news.abstrs}</textarea>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>新闻标签:</td>
	    			<td><input class="wu-text easyui-textbox easyui-validatebox" type="text" name="tags" data-options="required:true,missingMessage:'请填写新闻标签'" value="${news.tags}"></input></td>
	    		</tr>
	    		<tr>
	    			<td>新闻封面:</td>
	    			<td>
	    				<input class="wu-text easyui-textbox easyui-validatebox" type="text" id="edit-photo" name="photo" readonly="readonly" value="${news.photo}" data-options="required:true,missingMessage:'请上传封面'" value="${news.photo}"></input>
	    				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-upload" onclick="uploadPhoto()">上传</a>
	    				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-eye" onclick="preview()">预览</a>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>新闻作者:</td>
	    			<td><input class="wu-text easyui-textbox easyui-validatebox" type="text" name="author" data-options="required:true,missingMessage:'请填写新闻作者'" value="${news.author}"></input></td>
	    		</tr>
	    		<tr>
	    			<td>新闻内容:</td>
	    			<td>
	    				<textarea id="edit-content" name="content"  style="width:760px;height:300px;" >${news.content}</textarea>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	    <div style="padding:5px">
	    	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" onclick="submitForm()">保存</a>
	    	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-back"  onclick="back()">返回</a>
	    </div>
	    </div>
	</div>


<jsp:include page="../common/footer.jsp" flush="true"/>

<!-- End of easyui-dialog -->

<!-- 预览图片弹窗 -->
<div id="preview-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:330px; padding:10px;">
        <table>
            <tr>
                <td><img id="preview-photo" src="/resources/upload/news-pic.jpg" width="300px"></td>
            </tr>
        </table>
</div>
<%--进度条--%>
<div id="progress-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save',title:'文件上传中'" style="width:450px; padding:10px;">
        <div id="p" class="easyui-progressbar" style="width:400px;"data-options="text:'正在上传中'"></div>
</div>
<%--上传--%>
<input type="file" id="photo-file" style="display: none" onchange="upload()">
<!-- 配置文件 -->
    <script type="text/javascript" src="/resources/admin/ueditor/ueditor.config.js"></script>
    <!-- 编辑器源码文件 -->
    <script type="text/javascript" src="/resources/admin/ueditor/ueditor.all.js"></script>
<script type="text/javascript">
var ue = UE.getEditor('edit-content');
function back(){
	window.history.back();
}
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
                $('#preview-photo').attr('src',data.filepath);
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

function preview(){
	$('#preview-dialog').dialog({
		closed: false,
		modal:true,
        title: "预览封面图片",
        buttons: [{
            text: '关闭',
            iconCls: 'icon-cancel',
            handler: function () {
                $('#preview-dialog').dialog('close');
            }
        }],
        onBeforeOpen:function(){
        }
    });
}

/**
 * 添加新闻
 */
function submitForm(){
        var validate=$('#edit-form').form("validate");
        if (!validate) {
                $.messager.alert("消息提醒","请检查你输入的数据","warning");
                return;
        }
        //获取表单数据，以键值对的形式返回
        var data=$('#edit-form').serialize();
		var content = ue.getContent();
		if (content == null) {
			$.messager.alert("消息提醒","新闻内容不能为空","warning");
			return;
		}
        $.ajax({
                url:'edit',
                data:data,
                type:'post',
                dataType:'json',
                success:function(data){
                        if(data.type=='success'){
                                $.messager.alert('信息提示',data.msg,'info');
                               /* $('#add-dialog').dialog('close');
                                $("#data-datagrid").datagrid('reload');*/
							window.history.go(-1);
                        }
                        else
                        {
                                $.messager.alert('信息提示',data.msg,'warning');
                        }
                }
        });
}
</script>



