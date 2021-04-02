<%--
  Created by IntelliJ IDEA.
  User: 54799
  Date: 2020/9/14
  Time: 14:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="../common/header.jsp" flush="true"/>
<section class="container">
<div class="content-wrap">
<div class="content">
  <div id="focusslide" class="carousel slide" data-ride="carousel">
	<ol class="carousel-indicators">
	  <li data-target="#focusslide" data-slide-to="0" class="active"></li>
	  <li data-target="#focusslide" data-slide-to="1"></li>
	</ol>
	<div class="carousel-inner" role="listbox">
	  <div class="item active">
	  <a href="#" target="_blank" title="木庄网络博客源码" >
	  <img src="/resources/home/images//201610181557196870.jpg" alt="木庄网络博客源码" class="img-responsive"></a>
	  </div>
	  <div class="item">
	  <a href="#" target="_blank" title="专业网站建设" >
	  <img src="/resources/home/images//201610241227558789.jpg" alt="专业网站建设" class="img-responsive"></a>
	  </div>
	</div>
	<a class="left carousel-control" href="#focusslide" role="button" data-slide="prev" rel="nofollow"> <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span> <span class="sr-only">上一个</span> </a> <a class="right carousel-control" href="#focusslide" role="button" data-slide="next" rel="nofollow"> <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span> <span class="sr-only">下一个</span> </a> </div>
  <div class="title">
	<h3>最新发布</h3>
  </div>
	<c:forEach items="${newsList}" var="news">
  <article class="excerpt excerpt-1" style="">
  <a class="focus" href="../news/detail?id=${news.id}" title="${news.title}" target="_blank" ><img class="thumb" data-original="${news.photo}" src="${news.photo}" alt="${news.title}"  style="display: inline;"></a>
		<header><a class="cat" href="../news/category_list?cid=${news.categoryId}" title="${news.newsCategory.name}" >${news.newsCategory.name}<i></i></a>
			<h2><a href="../news/detail?id=${news.id}" title="${news.title}" target="_blank" >${news.title}</a>
			</h2>
		</header>
		<p class="meta">
			<time class="time"><i class="glyphicon glyphicon-time"></i><fmt:formatDate value="${news.createTime}" pattern="yyyy-MM-dd hh:mm:ss"/></time>
			<span class="views"><i class="glyphicon glyphicon-eye-open"></i> ${news.viewNumber}</span> <a class="comment" href="##comment" title="评论" target="_blank" ><i class="glyphicon glyphicon-comment"></i> ${news.commentNumber}</a>
		</p>
		<p class="note">${news.abstrs}</p>
	</article>
	</c:forEach>
	<div class="ias_trigger"><a href="javascript:;" >查看更多</a></div>
</div>
</div>
<jsp:include page="../common/sidebar.jsp" flush="true"/>
</section>
<jsp:include page="../common/footer.jsp" flush="true"/>


