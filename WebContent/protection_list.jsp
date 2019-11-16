<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="common/authorization.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>

<!DOCTYPE html>
<html lang="en">
<head>
<title>Product List</title>
<%@ include file="layout/header.jsp"%>
<%@ include file="common/datasource.jsp"%>
</head>
<body>

	<div class="container">
		<%@ include file="layout/nav_bar.jsp"%>

		<div class="table-wrapper">
			<div class="table-title">
				<div class="row">
					<div class="col-sm-3">
						<h2>
							Registered <b>Products</b>
						</h2>
					</div>
					<div class="col-sm-6">
						<form class="" action="protection_list.jsp">
							<input type="text" class="title-search btn form-control"
								placeholder="Search" name="search_tearm" value="${param.search_tearm }">
						</form>
					</div>
					<div class="col-sm-3">
						<a href="protection_registration.jsp" class="btn btn-success"><i
							class="material-icons">&#xE147;</i> <span>Register Product</span></a>
					</div>
				</div>
			</div>
			<c:choose>
				<c:when test="${!empty param.search_tearm}">
					<sql:query dataSource="${dbCon}" var="result">
						select pr.id, pr.purchaseDate, pr.serialNo, p.name, p.model, concat(t.name, '') AS type, concat(m.name, '') AS manufacturer 
						from ProtectionRegistrations pr, Products p, ProductTypes t, Manufacturers m
						WHERE pr.productId = p.id
						 AND p.ManufacturerID = m.id
						AND p.TypeID = t.id
						AND username=?
						AND (
							p.name LIKE concat('%',?,'%')
							OR pr.purchaseDate LIKE concat('%',?,'%')
							OR pr.serialNo LIKE concat('%',?,'%')
							OR p.model LIKE concat('%',?,'%')
							OR m.name LIKE concat('%',?,'%')
							OR t.name LIKE concat('%',?,'%'));
						<sql:param value="${sessionScope.username}" />	
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
						select pr.id, pr.purchaseDate, pr.serialNo, p.name, p.model, concat(t.name, '') AS type, concat(m.name, '') AS manufacturer 
						from ProtectionRegistrations pr, Products p, ProductTypes t, Manufacturers m
						WHERE pr.productId = p.id
						 AND p.ManufacturerID = m.id
						AND p.TypeID = t.id
						AND username=?
						<sql:param value="${sessionScope.username}" />	
					</sql:query>
				</c:otherwise>
			</c:choose>
			
			<table class="table table-striped table-hover">
				<thead>
					<tr>
						<th>ID</th>
						<th>Name</th>
						<th>Purchase Date</th>
						<th>Serial No</th>
						<th>Type</th>
						<th>Model</th>
						<th>Manufacturer</th>
						<th>Actions</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="col" items="${result.rows}">
						<tr>
							<td><c:out value="${col.id}"></c:out></td>
							<td><c:out value="${col.name}"></c:out></td>
							<td><c:out value="${col.purchasedate}"></c:out></td>
							<td><c:out value="${col.serialNo}"></c:out></td>
							<td><c:out value="${col.type}"></c:out></td>
							<td><c:out value="${col.model}"></c:out></td>
							<td><c:out value="${col.manufacturer}"></c:out></td>
							<td><a href="claim_list.jsp?registrationId=${col.id}" class="edit"
								data-toggle="modal"><i class="material-icons"
									data-toggle="tooltip" title="claim detail">&#xe3c7</i></a>
							</td>
						</tr>
					</c:forEach>
					<c:if test="${result.rowCount == 0}">
						<tr>
							<td colspan="8">No record found!</td>
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
								<input type="button" class="btn ${ param.buttonType}" data-dismiss="modal"
							value="Close">
							</c:when>
							<c:otherwise>
								<input type="button" class="btn btn-default" data-dismiss="modal"
							value="Close">
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
	
	<!-- Delete Modal HTML -->
	<div id="deleteEmployeeModal" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<form action="delete_product.jsp" method="POST">
					<input id="delete_id" name="id"type="hidden" value=""/>
					<div class="modal-header">
						<h4 class="modal-title">Delete Employee</h4>
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">&times;</button>
					</div>
					<div class="modal-body">
						<p>Are you sure you want to delete these Records?</p>
						<p class="text-warning">
							<small>This action cannot be undone.</small>
						</p>
					</div>
					<div class="modal-footer">
						<input type="button" class="btn btn-default" data-dismiss="modal"
							value="Cancel"> 
							<input type="submit" class="btn btn-danger" value="Delete">
					</div>
				</form>
			</div>
		</div>
	</div>
	<script>
		function deteleSetup(id){
			$('#delete_id').val(id);
		}
	</script>
</body>
</html>