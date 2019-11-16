<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="common/datasource.jsp"%>
<c:if test="${!empty sessionScope.username}">
	<c:choose>
		<c:when test="${sessionScope.role == 'user'}">
			<c:redirect url="protection_list.jsp" />
		</c:when>
		<c:otherwise>
			<c:redirect url="product_list.jsp" />
		</c:otherwise>
	</c:choose>
</c:if>
<!DOCTYPE html>
<html>
<head>
<title>Register an account</title>
<%@ include file="layout/header.jsp"%>
</head>
<body>
	<c:set var="msg" value="" />
	<c:set var="errName" value="" />
	<c:set var="errUserName" value="" />
	<c:set var="errPassword" value="" />
	<c:set var="errPhone" value="" />
	<c:set var="errEmail" value="" />
	<c:set var="errAddress" value="" />
	<c:if test="${pageContext.request.method=='POST'}">
		<c:choose>
			<c:when test="${empty param.name }">
				<c:set var="errName" value="Name is required" />
			</c:when>
			<c:when test="${empty param.username }">
				<c:set var="errUserName" value="User Name is required" />
			</c:when>
			<c:when test="${empty param.password }">
				<c:set var="errPassword" value="Password is required" />
			</c:when>
			<c:when test="${empty param.phone }">
				<c:set var="errPhone" value="Phone is required" />
			</c:when>
			<c:when test="${empty param.email }">
				<c:set var="errEmail" value="Email is required" />
			</c:when>
			<c:when test="${empty param.address }">
				<c:set var="errAddress" value="Address is required" />
			</c:when>
			<c:otherwise>
				<sql:query dataSource="${dbCon}" var="result">
						SELECT username 
						FROM users
						WHERE username=?
						<sql:param value="${param.username}" />
				</sql:query>
				<c:choose>
					<c:when test="${result.rowCount > 0 }">
						<c:set var="errUserName" value="This username is not available" />
					</c:when>
					<c:otherwise>


						<sql:update dataSource="${dbCon}" var="result">
		            		INSERT INTO users(name, username, password, phone, email, address, role) VALUES (?,?, ?, ?, ?, ?, 'user');
				            <sql:param value="${param.name}" />
							<sql:param value="${param.username}" />
							<sql:param value="${param.password}" />
							<sql:param value="${param.phone}" />
							<sql:param value="${param.email}" />
							<sql:param value="${param.address}" />
						</sql:update>
						<c:if test="${result>=1}">
							<c:set var="msg" value="Register account successful" />
						</c:if>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</c:if>
	<div class="container login">
		<div class="row">
			<div class="col-md-6 col-md-offset-3">
				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">Register an Account</h3>
					</div>
					<div class="panel-body">
						<c:choose>
							<c:when test="${!empty msg}">
								<div class="alert alert-success">
									<label>${msg} </label> <label><a href="login.jsp">Click
											here for Login</a></label>
								</div>
							</c:when>
							<c:otherwise>
								<form accept-charset="UTF-8" role="form" method="post">
									<fieldset>
										<div class="form-group">
											<label>Name</label> <input class="form-control"
												placeholder="Name" name="name" type="text"
												value="${param.name}" required>
											<c:if test="${!empty errName}">
												<small class="text-danger">${errName}</small>
											</c:if>
										</div>
										<div class="form-group">
											<label>User Name</label> <input class="form-control"
												placeholder="User Name" name="username" type="text"
												value="${param.username}" required>
											<c:if test="${!empty errUserName}">
												<small class="text-danger">${errUserName}</small>
											</c:if>
										</div>
										<div class="form-group">
											<label>Password</label> <input class="form-control"
												placeholder="Password" name="password" type="password"
												value="" required>
											<c:if test="${!empty errPassword}">
												<small class="text-danger">${errPassword}</small>
											</c:if>
										</div>
										<div class="form-group">
											<label>Phone</label> <input class="form-control"
												placeholder="000-000-0000" name="phone" type="text"
												value="${param.phone}" required>
											<c:if test="${!empty errPhone}">
												<small class="text-danger">${errPhone}</small>
											</c:if>
										</div>
										<div class="form-group">
											<label>Email</label> <input class="form-control"
												placeholder="abc@email.com" name="email" type="text"
												value="${param.email}" required>
											<c:if test="${!empty errEmail}">
												<small class="text-danger">${errEmail}</small>
											</c:if>
										</div>
										<div class="form-group">
											<label>Address</label> <input class="form-control"
												placeholder="Address" name="address" type="text"
												value="${param.address}" required>
											<c:if test="${!empty errAddress}">
												<small class="text-danger">${errAddress}</small>
											</c:if>
										</div>
										<input class="btn btn-lg btn-success btn-block" type="submit"
											value="Register"> <br />
										<div class="form-group">
											<label>Have an account? <a href="login.jsp">Login</a></label>
										</div>
									</fieldset>
								</form>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>