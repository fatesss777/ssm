<%--
  Created by IntelliJ IDEA.
  User: 54799
  Date: 2020/9/14
  Time: 16:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<aside class="sidebar">
<div class="fixed">
  <div class="widget widget-tabs">
	<ul class="nav nav-tabs" role="tablist">
	  <li role="presentation" class="active"><a href="#notice" aria-controls="notice" role="tab" data-toggle="tab" >统计信息</a></li>
	  <li role="presentation"><a href="#contact" aria-controls="contact" role="tab" data-toggle="tab" >联系站长</a></li>
	</ul>
	<div class="tab-content">
	  <div role="tabpanel" class="tab-pane contact active" id="notice">
		<h2>日志总数:
			<span id="total-article-span">888</span>篇
		  </h2>
		  <h2>网站运行:
		  <span id="sitetime">88 </span>天</h2>
	  </div>
		<div role="tabpanel" class="tab-pane contact" id="contact">
		  <h2>QQ:547991278
			  <a href="" target="_blank" rel="nofollow" data-toggle="tooltip" data-placement="bottom" title=""  data-original-title="QQ:"></a>
		  </h2>
		  <h2>Email:547991278@qq.com
		  <a href="#" target="_blank" data-toggle="tooltip" rel="nofollow" data-placement="bottom" title=""  data-original-title="#"></a></h2>
	  </div>
	</div>
  </div>
  <div class="widget widget_search">
	<form class="navbar-form" action="../news/search_list" method="get">
	  <div class="input-group">
		<input type="text" name="keyword" class="form-control" size="35" placeholder="请输入关键字" maxlength="15" autocomplete="off" value="${keyword}">
		<span class="input-group-btn">
		<button class="btn btn-default btn-search" name="search" type="submit">搜索</button>
		</span> </div>
	</form>
  </div>
</div>
<div class="widget widget_hot">
	  <h3>最新评论文章</h3>
	  <ul id="last_comment_list">

	  </ul>
 </div>
 <div class="widget widget_sentence">
	<a href="#" target="_blank" rel="nofollow" title="专业网站建设" >
	<img style="width: 100%" src="/resources/home/images//201610241224221511.jpg" alt="专业网站建设" ></a>
 </div>
 <div class="widget widget_sentence">
	<a href="#" target="_blank" rel="nofollow" title="MZ-NetBlog主题" >
	<img style="width: 100%" src="/resources/home/images/ad.jpg" alt="MZ-NetBlog主题" ></a>
 </div>
<div class="widget widget_sentence">
  <h3>友情链接</h3>
  <div class="widget-sentence-link">
	<a href="#" title="网站建设" target="_blank" >网站建设</a>&nbsp;&nbsp;&nbsp;
  </div>
</div>
</aside>
<script>
	/**
	 * 时间戳转换
	 * */
	function add0(m){return m<10?'0'+m:m }
		function format(shijianchuo){
		//shijianchuo是整数，否则要parseInt转换
			var time = new Date(shijianchuo);
			var y = time.getFullYear();
			var m = time.getMonth()+1;
			var d = time.getDate();
			var h = time.getHours();
			var mm = time.getMinutes();
			var s = time.getSeconds();
			return y+'-'+add0(m)+'-'+add0(d)+' '+add0(h)+':'+add0(mm)+':'+add0(s);
		}
	$(document).ready(function () {
		$.ajax({
			url:'../news/last_comment_list',
			type:'post',
			dataType:'json',
			success:function (data) {
				var newsList=data.newsList;
				var html = '';
				for (var i = 0; i < newsList.length; i++) {
					var li = '<li><a title="'+newsList[i].title+'" href="../news/detail?id='+newsList[i].id+'" ><span class="thumbnail">';
					li += '<img class="thumb" data-original="/resources/home/images/201610181739277776.jpg" src="'+newsList[i].photo+'" alt="'+newsList[i].title+'"  style="display: block;">';
					li += '</span><span class="text">'+newsList[i].title+'</span><span class="muted"><i class="glyphicon glyphicon-time"></i>';
					li += format(newsList[i].createTime) + '</span><span class="muted"><i class="glyphicon glyphicon-eye-open"></i>' + newsList[i].viewNumber + '</span></a></li>';
					html += li;
				}
				$('#last_comment_list').append(html);
			}
		});

		$.ajax({
			url:'../index/get_info',
			type:'post',
			dataType:'json',
			success:function (data) {
				$('#total-article-span').text(data.totalNews);
				$('#sitetime').text(data.allTime);
			}
		});
	});
</script>
