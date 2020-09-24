<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
	<title>Home</title>
</head>
<body>
<h2>
	logout
</h2>

<form method='post' action='/customLogout'>
	<input type='hidden' name="${_csrf.parameterName}" value="${_csrf.token}" />
	<button>logout</button>
</form>

</body>
</html>
