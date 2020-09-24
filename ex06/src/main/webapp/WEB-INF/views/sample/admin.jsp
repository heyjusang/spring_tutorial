<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>admin</h1>

<p>principal : <sec:authentication property="principal" /></p>
<p>MemberVO : <sec:authentication property="principal.member" /></p>
<p> name : <sec:authentication property="principal.member.userName" /></p>
<p> id : <sec:authentication property="principal.member.userid" /></p>
<p> auth : <sec:authentication property="principal.member.authList" /></p>

<a href="/customLogout">logout</a>
</body>
</html>