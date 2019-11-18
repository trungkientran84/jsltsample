<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="common/authorization.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>

<!DOCTYPE html>
<html lang="en">
<head>
<title>Claim List</title>
<%@ include file="layout/header.jsp"%>
<%@ include file="common/datasource.jsp"%>
</head>
<c:if test="${ empty param.registrationId}">
	<c:redirect url="protection_list.jsp"></c:redirect>
</c:if>
<body>
	<div class="container">
		<%@ include file="layout/nav_bar.jsp"%>

		<div class="table-wrapper">
			<div class="table-title">
				<div class="row">
					<div class="col-sm-3">
						<h2>
							Protection <b>Claims</b>
						</h2>
					</div>
					<div class="col-sm-6">
						<form class="" action="claim_list.jsp">
							<input type="hidden" name="registrationId" value="${param.registrationId}"/>
							<input type="text" class="title-search btn form-control"
								placeholder="Search" name="search_tearm" value="${param.search_tearm }">
						</form>
					</div>
					<div class="col-sm-3">
						<a href="protection_claim.jsp?registrationId=${param.registrationId}" class="btn btn-success"><i
							class="material-icons">&#xE147;</i> <span>New Claim</span></a>
							<a href="protection_list.jsp" class="btn btn-success"><i
							class="material-icons">&#xe5c4;</i> <span>Back</span></a>
							
					</div>
				</div>
			</div>
			<c:choose>
				<c:when test="${!empty param.search_tearm}">
					<sql:query dataSource="${dbCon}" var="result">
						select pr.id, pr.type, pr.date, pr.description, pr.status 
						from ProtectionClaims pr
						WHERE pr.registrationId = ?
						AND (
							pr.type LIKE concat('%',?,'%')
							OR pr.date LIKE concat('%',?,'%')
							OR pr.description LIKE concat('%',?,'%')
							OR pr.status LIKE concat('%',?,'%'));
						<sql:param value="${param.registrationId}" />
						<sql:param value="${param.search_tearm}" />
						<sql:param value="${param.search_tearm}" />
						<sql:param value="${param.search_tearm}" />
						<sql:param value="${param.search_tearm}" />
					</sql:query>
				</c:when>
				<c:otherwise>
					<sql:query dataSource="${dbCon}" var="result">
						select pr.id, pr.type, pr.date, pr.description, pr.status 
						from ProtectionClaims pr
						WHERE pr.registrationId = ?
						<sql:param value="${param.registrationId}" />
					</sql:query>
				</c:otherwise>
			</c:choose>
			
			<table class="table table-striped table-hover">
				<thead>
					<tr>
						<sql:query dataSource="${dbCon}" var="registrationResult">
							SELECT pr.purchaseDate, pr.serialNo, p.name, p.model, concat(t.name, '') AS type, concat(m.name, '') AS manufacturer 
							FROM ProtectionRegistrations pr, Products p, ProductTypes t, Manufacturers m
							WHERE pr.productId = p.id
								 AND p.ManufacturerID = m.id
								AND p.TypeID = t.id
								AND pr.id = ?
							<sql:param value="${param.registrationId}" />
					</sql:query>
						<th colspan="4" >
							<h4>
							${registrationResult.rows[0].name} 
							- ${registrationResult.rows[0].purchaseDate}
							- ${registrationResult.rows[0].model}
							- ${registrationResult.rows[0].serialNo}
							- ${registrationResult.rows[0].type}
							- ${registrationResult.rows[0].manufacturer}
							</h4>
							</th>
					</tr>
					<tr>
						<th>ID</th>
						<th>Type</th>
						<th>Date</th>
						<th>Description</th>
						<th>Status</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="col" items="${result.rows}">
						<tr>
							<td><c:out value="${col.id}"></c:out></td>
							<td><c:out value="${col.type}"></c:out></td>
							<td><c:out value="${col.date}"></c:out></td>
							<td><c:out value="${col.description}"></c:out></td>
							<td><c:out value="${col.status}"></c:out></td>
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
</body>
</html>