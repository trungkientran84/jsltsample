<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="common/authorization.jsp" %>
<%@ include file="common/datasource.jsp"%>

<!DOCTYPE html>
<html lang="en">
<head>
<title>Add Product</title>
<%@ include file="layout/header.jsp"%>
</head>
<body>
	<c:set var="errName" value="" />
	<c:set var="errTypeID" value="" />
	<c:set var="errModel" value="" />
	<c:set var="errManufacturerid" value="" />
	<c:set var="data" value="${param }" />
	<c:if test="${pageContext.request.method=='POST'}">
		<c:choose>
			<c:when test="${empty param.name }">
				<c:set var="errName" value="Product Name is required" />
			</c:when>
			<c:when test="${empty param.typeId }">
				<c:set var="errTypeID" value="Product Type is required" />
			</c:when>
			<c:when test="${empty param.model }">
				<c:set var="errModel" value="Product Model is required" />
			</c:when>
			<c:when test="${empty param.manufacturerId }">
				<c:set var="errManufacturerid" value="Manufacturer is required" />
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test="${!empty param.id}">
						<sql:update dataSource="${dbCon}" var="result">
		            		UPDATE products set name=?, model=?, manufacturerid=?, typeid=?
		            		WHERE id=?
				            <sql:param value="${param.name}" />
				            <sql:param value="${param.model}" />
				            <sql:param value="${param.manufacturerId}" />
				            <sql:param value="${param.typeId}" />
				            <sql:param value="${param.id}" />
			             </sql:update>
			             <c:if test="${result>=1}">
				            <c:redirect url="product_list.jsp" >
				                <c:param name="msg" value="Product is updated successfully." />
				                <c:param name="buttonType" value="btn-success" />
				            </c:redirect>
				        </c:if> 
					</c:when>
					<c:otherwise>
						<sql:update dataSource="${dbCon}" var="result">
		            		INSERT INTO products(name, model,  manufacturerid, typeid) VALUES (?,?, ?, ?);
				            <sql:param value="${param.name}" />
				            <sql:param value="${param.model}" />
				            <sql:param value="${param.manufacturerId}" />
				            <sql:param value="${param.typeId}" />
		       			 </sql:update>
		       			 <c:if test="${result>=1}">
				            <c:redirect url="product_list.jsp" >
				                <c:param name="msg" value="New product added successfully." />
				                <c:param name="buttonType" value="btn-success" />
				            </c:redirect>
				        </c:if> 
					</c:otherwise>
				</c:choose>
				
		        
			</c:otherwise>
		</c:choose>
	</c:if>
	
	<c:if test="${pageContext.request.method=='GET'}">
		<c:if test="${ !empty param.id}">
		
			<sql:query dataSource="${dbCon}" var="exitingProduct">
				SELECT * FROM products WHERE id = ?
	   			 <sql:param value="${param.id}" />
			</sql:query>
			<c:choose>
				<c:when test="${exitingProduct.rowCount==0}">
					<c:redirect url="product_list.jsp">
						<c:param name="msg" value="The product is not exist!" />
						<c:param name="buttonType" value="btn-danger" />
					</c:redirect>
				</c:when>
				<c:otherwise>
					<c:set var="data" value ="${exitingProduct.rows[0]}"/>
				</c:otherwise>
			</c:choose>
		</c:if>
	</c:if>

	<div class="container">
		<%@ include file="layout/nav_bar.jsp"%>

		<div class="table-wrapper">
			<div class="table-title">
				<div class="row">
					<div class="col-sm-12">
						<h2>
							<c:choose>
								<c:when test="${!empty param.id}">
									Update <b>Product</b>
								</c:when>
								<c:otherwise>
									Add <b>Product</b>
								</c:otherwise>
							</c:choose>
							
						</h2>
					</div>
				</div>
			</div>
			<form action="add_product.jsp" method="post">
				<div class="modal-body">
					<c:if test="${ !empty param.id}">
						<input name="id" type="hidden" value="${param.id}"/>
					</c:if>
					<div class="form-group">
						<label>Product Name</label> <input type="text" name="name"
							class="form-control" value="${data.name}" required>
						<c:if test="${!empty errName}">
							<small class="text-danger">${errName}</small>
						</c:if>
					</div>
					<div class="form-group">
						<label>Product Type</label>
						<sql:query dataSource="${dbCon}" var="result">
							SELECT * FROM ProductTypes;
						</sql:query>
						<select name="typeId" class="form-control">
							<c:forEach var="col" items="${result.rows}">
								<c:choose>
									<c:when test="${data.typeId == col.id }">
										<option selected value="${col.id}">${col.name}</option>
									</c:when>

									<c:otherwise>
										<option value="${col.id}">${col.name}</option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</select>
						<c:if test="${!empty errTypeId}">
							<small class="text-danger">${errTypeId}</small>
						</c:if>
					</div>
					<div class="form-group">
						<label>Model</label> <input type="text" name="model"
							class="form-control" required value="${data.model}">
						<c:if test="${!empty errModel}">
							<small class="text-danger">${errModel}</small>
						</c:if>
					</div>
					<div class="form-group">
						<label>Manufacture</label>
						<sql:query dataSource="${dbCon}" var="result">
							SELECT * FROM Manufacturers;
						</sql:query>
						<select name="manufacturerId" class="form-control">
							<c:forEach var="col" items="${result.rows}">
								<c:choose>
									<c:when test="${data.manufacturerId == col.id }">
										<option selected value="${col.id}">${col.name}</option>
									</c:when>

									<c:otherwise>
										<option value="${col.id}">${col.name}</option>
									</c:otherwise>
								</c:choose>

							</c:forEach>
						</select>
						<c:if test="${!empty errManufacturerId}">
							<small class="text-danger">${errManufacturerId}</small>
						</c:if>
					</div>
				</div>
				<div class="modal-footer">
					<a href="product_list.jsp"> <input type="button"
						class="btn btn-default" data-dismiss="modal" value="Cancel">
					</a> 
					<c:choose>
						<c:when test="${!empty param.id}">
							<input type="submit" class="btn btn-success" value="Update">
						</c:when>
						<c:otherwise>
							<input type="submit" class="btn btn-success" value="Add">
						</c:otherwise>
					</c:choose>
					
				</div>
			</form>
		</div>
	</div>
</body>
</html>
