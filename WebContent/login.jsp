<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="common/datasource.jsp"%>
<c:if test="${!empty sessionScope.username}">
	<c:choose>
		<c:when test="${sessionScope.role == 'user'}">
			<c:redirect url="protection_list.jsp"/>
		</c:when>
		<c:otherwise>
			<c:redirect url="product_list.jsp"/>
		</c:otherwise>
	</c:choose>
</c:if>
<!DOCTYPE html>
<html>
<head>
<title>Login Page</title>
<%@ include file="layout/header.jsp"%>
</head>
<body>
	<c:set var="err" value="" />
	<c:if test="${pageContext.request.method=='POST'}">
		<c:choose>
			<c:when test="${empty param.username || empty param.password }">
				<c:set var="err" value="Invalid username or password" />
			</c:when>
			<c:otherwise>
				<sql:query dataSource="${dbCon}" var="result">
						SELECT role, name 
						FROM users
						WHERE username=?
						AND password=?;
						<sql:param value="${param.username}" />
					<sql:param value="${param.password}" />
				</sql:query>
				<c:choose>
					<c:when test="${result.rowCount == 0 }">
						<c:set var="err" value="Invalid username or password" />
					</c:when>
					<c:otherwise>
						<c:set var="name" value="${result.rows[0].name}" scope="session" />
						<c:set var="username" value="${param.username}" scope="session" />
						<c:set var="role" value="${result.rows[0].role}" scope="session" />
						<c:choose>
							<c:when test="${result.rows[0].role == 'user'}">
								<c:redirect url="protection_list.jsp"/>
							</c:when>
							<c:otherwise>
								<c:redirect url="home.jsp"/>
							</c:otherwise>
						</c:choose>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</c:if>
	<div class="container login">
		<div class="row">
			<div class="col-md-4 col-md-offset-4">
				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">Please sign in</h3>
					</div>
					<div class="panel-body">
						<c:if test="${!empty err}">
							<div class="alert alert-danger">${err}</div>
						</c:if>
						<form accept-charset="UTF-8" role="form" method="post">
							<fieldset>
								<div class="form-group">
									<input class="form-control" placeholder="User Name"
										name="username" type="text">
								</div>
								<div class="form-group">
									<input class="form-control" placeholder="Password"
										name="password" type="password" value="">
								</div>
								<input class="btn btn-lg btn-success btn-block" type="submit"
									value="Login"> <br />
								<div class="form-group">
									<label>Don't have an account? <a href="register.jsp">Register</a></label>
								</div>
							</fieldset>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>