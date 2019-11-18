<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ include file="common/authorization.jsp" %>
<%@ include file="common/datasource.jsp"%>

<c:if test="${pageContext.request.method=='GET'}">
	<c:redirect url="product_list.jsp">
	</c:redirect>
</c:if>

<c:if test="${ empty param.id}">
	<c:redirect url="product_list.jsp">
		<c:param name="msg" value="Please select a product for deleting" />
		<c:param name="buttonType" value="btn-danger" />
	</c:redirect>
</c:if>

<sql:query dataSource="${dbCon}" var="result">
	SELECT * FROM products WHERE id = ?
    <sql:param value="${param.id}" />
</sql:query>
<c:choose>
	<c:when test="${result.rowCount==0}">
		<c:redirect url="product_list.jsp">
			<c:param name="msg" value="The product is not exist!" />
			<c:param name="buttonType" value="btn-danger" />
		</c:redirect>
	</c:when>
	<c:otherwise>
		<c:catch var="e">
			<sql:update dataSource="${dbCon}" var="result">
					DELETE FROM products WHERE id = ?
	    		<sql:param value="${param.id}" />
			</sql:update>
		</c:catch>

		<c:choose>
			<c:when test="${e != null}">
				<c:redirect url="product_list.jsp">
					<c:param name="msg" value="Can't not delete product!" />
					<c:param name="buttonType" value="btn-success" />
				</c:redirect>
			</c:when>
			<c:otherwise>
				<c:redirect url="product_list.jsp">
					<c:param name="msg" value="The product is deleted successfully!" />
					<c:param name="buttonType" value="btn-success" />
				</c:redirect>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>

