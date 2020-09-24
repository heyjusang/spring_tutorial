<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@include file="../includes/header.jsp" %>

<!-- Page Heading -->
<h1 class="h3 mb-2 text-gray-800">Board Register</h1>
<p class="mb-4">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>

<div class="card shadow mb-4">
	<div class="card-header py-3">
    	<h6 class="m-0 font-weight-bold text-primary">Register Content</h6>
    </div>
    <div class="card-body">
        <form role="form" action="/board/modify" method="post">
        	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <input type='hidden' id='pageNum' name='pageNum' value='<c:out value="${cri.pageNum }"/>'>
        	<input type='hidden' id='amount' name='amount' value='<c:out value="${cri.amount }"/>'>
        	<input type='hidden' id='keyword' name='keyword' value='<c:out value="${cri.keyword }"/>'>
        	<input type='hidden' id='type' name='type' value='<c:out value="${cri.type }"/>'>     
        	
        	<div class="form-group">
        		<label>Bno</label>
        		<input class="form-control" name="bno" value='<c:out value="${board.bno }"/>' readonly="readonly">
       		</div>
       	 	<div class="form-group">
        		<label>Title</label>
        		<input class="form-control" name="title" value='<c:out value="${board.title }"/>'>
        	</div>
        	<div class="form-group">
        		<label>Content</label>
        		<textarea class="form-control" rows="3" name="content"><c:out value="${board.content}"/>
        		</textarea>
        	</div>
        	<div class="form-group">
        		<label>Writer</label>
        		<input class="form-control" name="writer" value='<c:out value="${board.writer }"/>' readonly="readonly">
        	</div>
        	<div class="form-group">
        		<label>RegDate</label>
        		<input class="form-control" name="regDate" 
        			value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.regdate}"/>' readonly="readonly">
        	</div>
        	<div class="form-group">
        		<label>Update Date</label>
        		<input class="form-control" name="updateDate" 
        			value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.updateDate}"/>' readonly="readonly">
        	</div>
        	
        	<sec:authentication property="principal" var="pinfo" />
        	
        	<sec:authorize access="isAuthenticated()">
        		<c:if test="${pinfo.username eq board.writer }">
        			<button type="submit" data-oper='modify' class="btn btn-primary">Modify</button>
        			<button type="submit" data-oper='remove' class="btn btn-secondary">Remove</button>
        		</c:if>
        	</sec:authorize>
        	<button type="submit" data-oper='list' class="btn btn-secondary">List</button>
        </form>      
    </div>
 </div>

<%@include file="../includes/footer.jsp" %>
<script type="text/javascript">
$(document).ready(function() {
	var formObj = $("form");
	
	$('button').on("click", function(e) {
		e.preventDefault();
		
		var operation = $(this).data("oper");
		
		if (operation === 'remove') {
			formObj.attr("action", "/board/remove");
		}
		else if (operation === 'list') {
			formObj.attr("action", "/board/list");
			formObj.attr("method", "get");
			
			var pageNumTag = $("input[name='pageNum']").clone();
			var amountTag = $("input[name='amount']").clone();
			var keywordTag = $("input[name='keyword']").clone();
			var typeTag = $("input[name='type']").clone();		
			
			formObj.empty();
			formObj.append(pageNumTag);
			formObj.append(amountTag);
			formObj.append(keywordTag);
			formObj.append(typeTag);
		}
		formObj.submit();
	});
});
</script>
  </body>

</html>