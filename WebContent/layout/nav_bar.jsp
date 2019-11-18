<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<nav class="navbar navbar-inverse">
	<div class="container-fluid">
		<div class="navbar-header">
			<a class="navbar-brand" href="#">ABC Company</a>
		</div>
		<ul class="nav navbar-nav">
			<c:choose>
				<c:when test="${sessionScope.role == 'admin'}">
					<li class="active"><a href="home.jsp">Home</a></li>
					<li><a href="product_list.jsp">Products</a></li>
					<li><a href="user_list.jsp">Users</a></li>
					<li><a href="registered_product_list.jsp">Registered Products</a></li>
					<li><a href="user_claim_list.jsp">Claims</a></li>
				</c:when>
				<c:otherwise>
					<li class="active"><a href="protection_list.jsp">Home</a></li>
				</c:otherwise>
			</c:choose>
		</ul>

		<ul class="nav navbar-nav navbar-right">
			<li><a href="#"><span class="glyphicon glyphicon-user"></span>
					${sessionScope.name}</a></li>
			<li><a href="logout.jsp"><span class="glyphicon glyphicon-log-in"></span>
					Logout</a></li>
		</ul>
	</div>
</nav>