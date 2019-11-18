<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="common/authorization.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>

<!DOCTYPE html>
<html lang="en">
<head>
<title>User List</title>
<%@ include file="layout/header.jsp"%>
<%@ include file="common/datasource.jsp"%>
</head>
<body>

	<div class="container">
		<%@ include file="layout/nav_bar.jsp"%>

		<div class="table-wrapper">
			<div class="table-title">
				<div class="row">
					<div class="col-sm-6">
						<h2>
							<b>List of Users</b>
						</h2>
					</div>
					<div class="col-sm-6">
						<form class="" action="user_list.jsp">
							<input type="text" class="title-search btn form-control"
								placeholder="Search" name="search_tearm"
								value="${param.search_tearm }">
						</form>
					</div>

				</div>
			</div>
			<c:choose>
				<c:when test="${!empty param.search_tearm}">
					<sql:query dataSource="${dbCon}" var="result">
						select * from Users u	
							WHERE 
							u.username LIKE concat('%',?,'%')
							OR u.phone LIKE concat('%',?,'%')
							OR u.email LIKE concat('%',?,'%')
							OR u.address LIKE concat('%',?,'%')
							OR u.name LIKE concat('%',?,'%')
							OR u.role LIKE concat('%',?,'%');
						<sql:param value="${param.search_tearm}" />
						<sql:param value="${param.search_tearm}" />
						<sql:param value="${param.search_tearm}" />
						<sql:param value="${param.search_tearm}" />
						<sql:param value="${param.search_tearm}" />
						<sql:param value="${param.search_tearm}" />
					</sql:query>
				</c:when>
				<c:otherwise>
					<sql:query dataSource="${dbCon}" var="result">
						select * FROM users;
					</sql:query>
				</c:otherwise>
			</c:choose>

			<table class="table table-striped table-hover">
				<thead>
					<tr>
						<th>Name</th>
						<th>User name</th>
						<th>Phone</th>
						<th>Email</th>
						<th>Address</th>
						<th>Role</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="col" items="${result.rows}">
						<tr>
							<td><c:out value="${col.name}"></c:out></td>
							<td><c:out value="${col.username}"></c:out></td>
							<td><c:out value="${col.phone}"></c:out></td>
							<td><c:out value="${col.email}"></c:out></td>
							<td><c:out value="${col.address}"></c:out></td>
							<td><c:out value="${col.role}"></c:out></td>
						</tr>
					</c:forEach>
					<c:if test="${result.rowCount == 0}">
						<tr>
							<td colspan="5">No record found!</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>
	</div>
	<c:if test="${!empty param.msg}">
		<div id="msgModal" class="modal fade">
			<div class="modal-dialog">
				<div class="modal-content">
					<form>
						<div class="modal-header">
							<h4 class="modal-title">Message</h4>
							<button type="button" class="close" data-dismiss="modal"
								aria-hidden="true">&times;</button>
						</div>
						<div class="modal-body">
							<p>${param.msg}</p>

						</div>
						<div class="modal-footer">
							<c:choose>
								<c:when test="${!empty param.buttonType}">
									<input type="button" class="btn ${ param.buttonType}"
										data-dismiss="modal" value="Close">
								</c:when>
								<c:otherwise>
									<input type="button" class="btn btn-default"
										data-dismiss="modal" value="Close">
								</c:otherwise>
							</c:choose>
						</div>
					</form>
				</div>
			</div>
		</div>
		<script>
			$(document).ready(function() {
				$('#msgModal').modal('show');
			});
		</script>
	</c:if>
</body>
</html>