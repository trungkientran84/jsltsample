<%@ page language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<!-- Define the common data source which will be used to connect to databse -->
<sql:setDataSource 
	var="dbCon" 
	driver="com.mysql.jdbc.Driver"
	url="jdbc:mysql://localhost:3306/product_management?serverTimezone=EST5EDT"
	user="root" 
	password="root"/>