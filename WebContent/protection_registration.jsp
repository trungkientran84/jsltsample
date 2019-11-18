<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="common/authorization.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="common/datasource.jsp"%>

<!DOCTYPE html>
<html lang="en">
<head>
<title>Add Product</title>
<%@ include file="layout/header.jsp"%>
</head>
<body>

	<c:set var="errProductID" value="" />
	<c:set var="errPurchaseDate" value="" />
	<c:set var="errSerialNo" value="" />
	<c:set var="data" value="${param }" />
	<c:if test="${pageContext.request.method=='POST'}">
		<c:choose>
			<c:when test="${empty param.productId }">
				<c:set var="errProductID" value="Please select a product" />
			</c:when>
			<c:when test="${empty param.purchaseDate }">
				<c:set var="errPurchaseDate" value="Purchase date is required" />
			</c:when>
			<c:when test="${empty param.serialNo }">
				<c:set var="errSerialNo" value="Serial no is required" />
			</c:when>
			<c:otherwise>
				<sql:query dataSource="${dbCon}" var="result">
            		SELECT id FROM ProtectionRegistrations
					WHERE productId = ? AND serialNo=?;
		            <sql:param value="${param.productId}" />
					<sql:param value="${param.serialNo}" />
				</sql:query>
				<c:choose>
					<c:when test="${result.rowCount > 0}">
						<c:set var="errSerialNo"
							value="The product with this serial no had been registered" />
					</c:when>
					<c:otherwise>
						<sql:update dataSource="${dbCon}" var="result">
            		INSERT INTO ProtectionRegistrations(username, productid,  purchasedate, serialno) VALUES (?,?, ?, ?);
		            <sql:param value="${sessionScope.username}" />
							<sql:param value="${param.productId}" />
							<sql:param value="${param.purchaseDate}" />
							<sql:param value="${param.serialNo}" />
						</sql:update>
						<c:if test="${result>=1}">
							<c:redirect url="protection_list.jsp">
								<c:param name="msg"
									value="Registry protection for new product successfully." />
								<c:param name="buttonType" value="btn-success" />
							</c:redirect>
						</c:if>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</c:if>

	<div class="container">
		<%@ include file="layout/nav_bar.jsp"%>

		<div class="table-wrapper">
			<div class="table-title">
				<div class="row">
					<div class="col-sm-12">
						<h2>Protection Registration</h2>
					</div>
				</div>
			</div>
			<form action="protection_registration.jsp" method="post">
				<div class="modal-body">
					<div class="form-group">
						<label>Product</label>
						<sql:query dataSource="${dbCon}" var="result">
							select p.id, p.name, p.model, concat(t.name, '') AS type, concat(m.name, '') AS manufacturer from Products p, ProductTypes t, Manufacturers m
						WHERE p.ManufacturerID = m.id
						AND p.TypeID = t.id
						</sql:query>
						<select name="productId" class="form-control">
							<c:forEach var="col" items="${result.rows}">
								<c:choose>
									<c:when test="${param.productId == col.id }">
										<option selected value="${col.id}">${col.name}|
											${col.model} | ${col.type} | ${col.manufacturer}</option>
									</c:when>
									<c:otherwise>
										<option value="${col.id}">${col.name}|${col.model} |
											${col.type} | ${col.manufacturer}</option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</select>
						<c:if test="${!empty errProductId}">
							<small class="text-danger">${errProductId}</small>
						</c:if>
					</div>
					<div class="form-group">
						<label>Purchase Date</label> <input type="text"
							name="purchaseDate" class="form-control" placeholder="YYYY-MM-DD"
							required value="${param.purchaseDate}">
						<c:if test="${!empty errPurchaseDate}">
							<small class="text-danger">${errPurchaseDate}</small>
						</c:if>
					</div>
					<div class="form-group">
						<label>Serial No</label> <input type="text" name="serialNo"
							class="form-control" required value="${param.serialNo}">
						<c:if test="${!empty errSerialNo}">
							<small class="text-danger">${errSerialNo}</small>
						</c:if>
					</div>

				</div>
				<div class="modal-footer">
					<a href="protection_list.jsp"> <input type="button"
						class="btn btn-default" data-dismiss="modal" value="Cancel">
					</a> <input type="submit" class="btn btn-success" value="Register">
				</div>
			</form>
		</div>
	</div>
	<script>
		$(document).ready(
				function() {
					var date_input = $('input[name="purchaseDate"]'); //our date input has the name "date"
					var container = $('.bootstrap-iso form').length > 0 ? $(
							'.bootstrap-iso form').parent() : "body";
					var options = {
						format : 'yyyy-mm-dd',
						container : container,
						todayHighlight : true,
						autoclose : true,
					};
					date_input.datepicker(options);
				})
	</script>
</body>
</html>
