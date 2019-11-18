<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ include file="common/authorization.jsp" %>
<%@ include file="common/datasource.jsp"%>

<c:if test="${pageContext.request.method=='GET'}">
	<c:redirect url="user_claim_list.jsp">
	</c:redirect>
</c:if>

<c:if test="${ empty param.claim_id}">
	<c:redirect url="user_claim_list.jsp">
		<c:param name="msg" value="Please select a claim for approving" />
		<c:param name="buttonType" value="btn-danger" />
	</c:redirect>
</c:if>

<c:set var="return_url" value="user_claim_list.jsp"/>
<c:if test="${!empty param.is_home}">
	<c:set var="return_url" value="home.jsp"/>
</c:if>

<sql:query dataSource="${dbCon}" var="result">
	SELECT * FROM protectionclaims WHERE id = ?
    <sql:param value="${param.claim_id}" />
</sql:query>
<c:choose>
	<c:when test="${result.rowCount==0}">
		<c:redirect url="${return_url}">
			<c:param name="msg" value="The claim is not exist!" />
			<c:param name="buttonType" value="btn-danger" />
		</c:redirect>
	</c:when>
	<c:otherwise>
		<c:catch var="e">
			<sql:update dataSource="${dbCon}" var="result">
					UPDATE protectionclaims SET status = "APPROVED" WHERE id = ?
	    		<sql:param value="${param.claim_id}" />
			</sql:update>
		</c:catch>

		<c:choose>
			<c:when test="${e != null}">
				<c:redirect url="${return_url}">
					<c:param name="msg" value="Can't not approve this claim" />
					<c:param name="buttonType" value="btn-success" />
				</c:redirect>
			</c:when>
			<c:otherwise>
				<c:redirect url="${return_url}">
					<c:param name="msg" value="The claim is approved successfully!" />
					<c:param name="buttonType" value="btn-success" />
				</c:redirect>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>

