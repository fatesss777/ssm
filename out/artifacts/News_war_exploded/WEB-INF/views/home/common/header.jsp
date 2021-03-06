<%--
  Created by IntelliJ IDEA.
  User: 54799
  Date: 2020/9/14
  Time: 16:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>wzp——${title}</title>
<meta name="keywords" content="">
<meta name="description" content="">
<link rel="stylesheet" type="text/css" href="/resources/home/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/resources/home/css/nprogress.css">
<link rel="stylesheet" type="text/css" href="/resources/home/css/style.css">
<link rel="stylesheet" type="text/css" href="/resources/home/css/font-awesome.min.css">
<link rel="apple-touch-icon-precomposed" href="/resources/home/images/icon.png">
<link rel="shortcut icon" href="/resources/home/images/favicon.ico">
<script src="/resources/home/js/jquery-2.1.4.min.js"></script>
<script src="/resources/home/js/nprogress.js"></script>
<script src="/resources/home/js/jquery.lazyload.min.js"></script>
<!--[if gte IE 9]>
  <script src="/resources/home/js/jquery-1.11.1.min.js" type="text/javascript"></script>
  <script src="/resources/home/js/html5shiv.min.js" type="text/javascript"></script>
  <script src="/resources/home/js/respond.min.js" type="text/javascript"></script>
  <script src="/resources/home/js/selectivizr-min.js" type="text/javascript"></script>
<![endif]-->
<!--[if lt IE 9]>
  <script>window.location.href='upgrade-browser.html';</script>
<![endif]-->
<script>
function addFavorite(url, title) {
	try {
		window.external.addFavorite(url, title);
	} catch (e){
		try {
			window.sidebar.addPanel(title, url, '');
        	} catch (e) {
			alert("请按 Ctrl+D 键添加到收藏夹", 'notice');
		}
	}
}

</script></head>
<body class="user-select">
<header class="header">
<nav class="navbar navbar-default" id="navbar">
<div class="container">
  <div class="header-topbar hidden-xs link-border">
	<ul class="site-nav topmenu">
	  <%--<li><a href="#" >标签云</a></li>
		<li><a href="#" rel="nofollow" >读者墙</a></li>--%>
		<li><a href="#" title="RSS订阅" onclick="addFavorite('http://localhost:8080/index/index','FATESSS')">
			<i class="fa fa-rss">
			</i> RSS订阅
		</a></li>
	</ul>
			 好好学习 天天向上</div>
  <div class="navbar-header">
	<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#header-navbar" aria-expanded="false"> <span class="sr-only"></span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span> </button>
	<h1 class="logo hvr-bounce-in"><a href="#" title="新闻管理系统"><img src="/resources/home/images/201610171329086541.png" alt="新闻管理系统"></a></h1>
  </div>
  <div class="collapse navbar-collapse" id="header-navbar">
	<form class="navbar-form visible-xs" action="../news/search_list" method="get">
	  <div class="input-group">
		<input type="text" name="keyword" class="form-control" placeholder="请输入关键字" maxlength="20" autocomplete="off" value="${keyword}">
		<span class="input-group-btn">
		<button class="btn btn-default btn-search" name="search" type="submit">搜索</button>
		</span> </div>
	</form>
	<ul class="nav navbar-nav navbar-right">
	  <li><a data-cont="新闻管理系统" title="新闻管理系统" href="/index/index">首页</a></li>
		<c:forEach items="${newsCategoryList}" var="newsCategory">
			<li><a data-cont="${newsCategory.name}" title="${newsCategory.name}" href="../news/category_list?cid=${newsCategory.id}">${newsCategory.name}</a></li>
		</c:forEach>
	</ul>
  </div>
</div>
</nav>
</header>
