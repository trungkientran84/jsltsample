<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="name" value="" scope="session" />
<c:set var="username" value="" scope="session" />
<c:set var="role" value="" scope="session" />
<c:redirect url="login.jsp"/>