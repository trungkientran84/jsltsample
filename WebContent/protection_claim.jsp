<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="common/authorization.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="common/datasource.jsp"%>

<!DOCTYPE html>
<html lang="en">
<head>
<title>Add Product</title>
<%@ include file="layout/header.jsp"%>
</head>
<body>
	<c:if test="${ empty param.registrationId}">
		<c:redirect url="protection_list.jsp">
		</c:redirect>
	</c:if>
	
	<sql:query dataSource="${dbCon}" var="allClaims">
		select pr.id, pr.type, pr.date, pr.description, pr.status 
		from ProtectionClaims pr
		WHERE pr.registrationId = ?
		<sql:param value="${param.registrationId}" />
	</sql:query>
	
	<c:if test="${allClaims.rowCount >=3}">
		<c:redirect url="claim_list.jsp" >
           	<c:param name="registrationId" value="${param.registrationId}" />
			<c:param name="msg" value="Maximum claim reach. You can not claim more" />
            <c:param name="buttonType" value="btn-danger" />
		</c:redirect>
	</c:if>
	
	<sql:query dataSource="${dbCon}" var="registeredProduct">
		SELECT pr.id, pr.purchaseDate, pr.serialNo, p.name, p.model, concat(t.name, '') AS type, concat(m.name, '') AS manufacturer 
		FROM ProtectionRegistrations pr, Products p, ProductTypes t, Manufacturers m
		WHERE pr.productId = p.id
			AND p.ManufacturerID = m.id
			AND p.TypeID = t.id
			AND pr.id = ?
			AND pr.username = ?
		<sql:param value="${param.registrationId}" />
		<sql:param value="${sessionScope.username}" />
		
	</sql:query>
	
	<!-- Verify the purchase date is within 5 years from now.
	If it is not the case then inform user about expired registered product
	and do not allow to add a new claim on this product -->
	<fmt:parseDate type="both" value= "${registeredProduct.rows[0].purchaseDate}" var="purchaseDate" pattern="yyyy-MM-dd HH:mm:ss" />
	<c:set target="${purchaseDate}" property="time" value="${purchaseDate.time + 86400000 * 365*5}" />
	<jsp:useBean id="now" class="java.util.Date" />
	<c:if test="${purchaseDate < now}">
		<c:redirect url="claim_list.jsp" >
           	<c:param name="registrationId" value="${param.registrationId}" />
			<c:param name="msg" value="Protection is expired for this registered product. You can not claim protection any more" />
            <c:param name="buttonType" value="btn-danger" />
		</c:redirect>
	</c:if>
	
	<c:set var="errType" value="" />
	<c:set var="errClaimDate" value="" />
	<c:set var="errDescription" value="" />
	<c:if test="${pageContext.request.method=='POST'}">
		<c:choose>
			<c:when test="${empty param.type }">
				<c:set var="errType" value="Type is required" />
			</c:when>
			<c:when test="${empty param.claimDate }">
				<c:set var="errClaimDate" value="Claim date is required" />
			</c:when>
			<c:when test="${empty param.description }">
				<c:set var="errDescription" value="Description is required" />
			</c:when>
			<c:otherwise>	
				<sql:update dataSource="${dbCon}" var="result">
            		INSERT INTO ProtectionClaims(type, date,  description, registrationId) VALUES (?,?, ?, ?);
		            <sql:param value="${param.type}" />
		            <sql:param value="${param.claimDate}" />
		            <sql:param value="${param.description}" />
		            <sql:param value="${param.registrationId}" />
       			 </sql:update>
       			 <c:if test="${result>=1}">
		            <c:redirect url="claim_list.jsp" >
		            	<c:param name="registrationId" value="${param.registrationId}" />
		                <c:param name="msg" value="Protection claim is added successfully." />
		                <c:param name="buttonType" value="btn-success" />
		            </c:redirect>
		        </c:if>
			</c:otherwise>
		</c:choose>
	</c:if>

	<div class="container">
		<%@ include file="layout/nav_bar.jsp"%>

		<div class="table-wrapper">
			<div class="table-title">
				<div class="row">
					<div class="col-sm-12">
						<h2>
							Protection Claim
						</h2>
					</div>
				</div>
			</div>
			<form action="protection_claim.jsp" method="post">
				<div class="modal-body">
					<div class="form-group">
						<label>Registry Product</label>
						
						<select name="registrationId" class="form-control">
							<c:forEach var="col" items="${registeredProduct.rows}">
								<c:choose>
									<c:when test="${param.registrationId == col.id }">
										<option selected value="${col.id}">${col.name} | ${col.model} | ${col.type} | ${col.manufacturer} </option>
									</c:when>
								</c:choose>
							</c:forEach>
						</select>
					</div>
					<div class="form-group">
						<label>Type</label> 
						<select name="type" class="form-control">
							<option selected value="Replacement">Replacement</option>
							<option selected value="Repair">Repair</option>
						</select>
						<c:if test="${!empty errType}">
							<small class="text-danger">${errType}</small>
						</c:if>
					</div>
					<div class="form-group">
						<label>Date</label> <input type="text" name="claimDate"
							class="form-control" placeholder="YYYY-MM-DD" required value="${param.claimDate}">
						<c:if test="${!empty errClaimDate}">
							<small class="text-danger">${errClaimDate}</small>
						</c:if>
					</div>
					
					<div class="form-group">
						<label>Description</label> 
						<textarea type="text" name="description" style="height: 100px;"
							class="form-control" required value="${param.description}"></textarea>
						<c:if test="${!empty errDescription}">
							<small class="text-danger">${errDescription}</small>
						</c:if>
					</div>
				</div>
				<div class="modal-footer">
					<a href="claim_list.jsp?registrationId=${param.registrationId}"> <input type="button"
						class="btn btn-default" data-dismiss="modal" value="Cancel">
					</a>
					<input type="submit" class="btn btn-success" value="Claim"> 
				</div>
			</form>
		</div>
	</div>
	<script>
    $(document).ready(function(){
      var date_input=$('input[name="claimDate"]'); //our date input has the name "date"
      var container=$('.bootstrap-iso form').length>0 ? $('.bootstrap-iso form').parent() : "body";
      var options={
        format: 'yyyy-mm-dd',
        container: container,
        todayHighlight: true,
        autoclose: true,
      };
      date_input.datepicker(options);
    })
</script>
</body>
</html>
