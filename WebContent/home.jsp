<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="common/authorization.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>

<!DOCTYPE html>
<html lang="en">
<head>
<title>Home</title>
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
							Waiting approval <b>Claims</b>
						</h2>
					</div>
					<div class="col-sm-6">
						<form class="" action="home.jsp">
							<input type="text" class="title-search btn form-control"
								placeholder="Search" name="search_tearm" value="${param.search_tearm }">
						</form>
					</div>
				</div>
			</div>
			<c:choose>
				<c:when test="${!empty param.search_tearm}">
					<sql:query dataSource="${dbCon}" var="result">
						select c.id, c.status,c.Type, c.Date,c.Description, pr.username, p.name,p.model,  pr.PurchaseDate, pr.SerialNo   from Products p,  protectionregistrations pr,
						protectionclaims as c
						WHERE pr.id = c.RegistrationId
						AND pr.ProductId = p.id
						AND c.status = 'WAITING APPROVAL'
						AND (
							c.status LIKE concat('%',?,'%')
							OR c.Type LIKE concat('%',?,'%')
							OR c.Date LIKE concat('%',?,'%')
							OR c.Description LIKE concat('%',?,'%')
							OR pr.username LIKE concat('%',?,'%')
							OR pr.SerialNo LIKE concat('%',?,'%')
							OR pr.PurchaseDate LIKE concat('%',?,'%')
							OR p.name LIKE concat('%',?,'%')
							OR p.model LIKE concat('%',?,'%'));
						<sql:param value="${param.search_tearm}" />
						<sql:param value="${param.search_tearm}" />
						<sql:param value="${param.search_tearm}" />
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
						select c.id, c.status,c.Type, c.Date,c.Description, pr.username, p.name,p.model,  pr.PurchaseDate, pr.SerialNo   from Products p,  protectionregistrations pr,
						protectionclaims as c
						WHERE pr.id = c.RegistrationId
						AND pr.ProductId = p.id
						AND c.status = 'WAITING APPROVAL';
					</sql:query>
				</c:otherwise>
			</c:choose>
			
			<table class="table table-striped table-hover">
				<thead>
					<tr>
						<th>ID</th>
						<th>Status</th>
						<th>Type</th>
						<th>Date</th>
						<th>Description</th>
						<th>User name</th>
						<th>Product Name</th>
						<th>Model</th>
						<th>Purchase Date</th>
						<th>Serial No.</th>
						<th>Actions</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="col" items="${result.rows}">
						<tr>
							<td><c:out value="${col.id}"></c:out></td>
							<td><c:out value="${col.status}"></c:out></td>
							<td><c:out value="${col.type}"></c:out></td>
							<td><c:out value="${col.date}"></c:out></td>
							<td><c:out value="${col.description}"></c:out></td>
							<td><c:out value="${col.username}"></c:out></td>
							<td><c:out value="${col.name}"></c:out></td>
							<td><c:out value="${col.model}"></c:out></td>
							<td><c:out value="${col.purchaseDate}"></c:out></td>
							<td><c:out value="${col.serialNo}"></c:out></td>
							
							<td>
								<c:if test="${col.status == 'WAITING APPROVAL' }">
									<a href="#" onclick="approveSetup(${col.id})" data-toggle="modal" data-target="#approveModal"><i
									class="material-icons" data-toggle="tooltip"  title="Approve this claim">&#xe877;</i></a>
								</c:if>
								
							</td>
						</tr>
					</c:forEach>
					<c:if test="${result.rowCount == 0}">
						<tr>
							<td colspan="6">No record found!</td>
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
	<div id="approveModal" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<form action="approve_claim.jsp" method="POST">
					<input id="claim_id" name="claim_id"type="hidden" value=""/>
					<input name="is_home"type="hidden" value="true"/>
					<div class="modal-header">
						<h4 class="modal-title">Approve claim</h4>
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">&times;</button>
					</div>
					<div class="modal-body">
						<p>Are you sure you want to approve this claim?</p>
						<p class="text-warning">
							<small>This action cannot be undone.</small>
						</p>
					</div>
					<div class="modal-footer">
						<input type="button" class="btn btn-default" data-dismiss="modal"
							value="Cancel"> 
							<input type="submit" class="btn btn-danger" value="Approve">
					</div>
				</form>
			</div>
		</div>
	</div>
	<script>
		function approveSetup(id){
			$('#claim_id').val(id);
		}
	</script>
</body>
</html>