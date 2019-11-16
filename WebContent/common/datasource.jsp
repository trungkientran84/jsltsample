<%@ page language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<sql:setDataSource 
	var="dbCon" 
	driver="com.mysql.jdbc.Driver"
	url="jdbc:mysql://localhost:3306/product_management?serverTimezone=EST5EDT"
	user="root" 
	password="root"/>