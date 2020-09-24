<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


   <%@include file="../includes/header.jsp" %>

   

          <!-- Page Heading -->
          <div class="row">
          	<div class="col-sm-12 col-md-6">
          		<h1 class="h3 mb-2 text-gray-800">Tables</h1>
          	</div>
          	<div class="col-sm-12 col-md-6 ">
          		<button id="regBtn" type="button" class="btn btn-primary float-right">Register New Board</button>
          	</div>
          </div>
          <p class="mb-4">DataTables is a third party plugin that is used to generate the demo table below. For more information about DataTables, please visit the <a target="_blank" href="https://datatables.net">official DataTables documentation</a>.</p>

          <!-- DataTales Example -->
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold text-primary">DataTables Example</h6>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-bordered" id="myDataTable" width="100%" cellspacing="0">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>TITLE</th>
                      <th>WRITER</th>
                      <th>CREATED AT</th>
                      <th>UPDATED AT</th>
                    </tr>
                  </thead>
                  <tfoot>
                    <tr>
                      <th>ID</th>
                      <th>TITLE</th>
                      <th>WRITER</th>
                      <th>CREATED AT</th>
                      <th>UPDATED AT</th>
                    </tr>
                  </tfoot>
                  <tbody>
                  	<c:forEach items="${list}" var="board">
                 	<tr>
                 	    <td><c:out value="${board.bno}" /></td>
                 		<td><a class='move' href='<c:out value="${board.bno}" />'>
                 				<c:out value="${board.title}" />
                 				<b>[<c:out value="${board.replyCnt }" />]</b>
                 			</a>
                 		</td>
                 		<td><c:out value="${board.writer}" /></td>
                 		<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}" /></td>
                 		<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.updateDate}" /></td>
                 	</tr>
                  	</c:forEach>
                  </tbody>
                </table>
                
                <div class='row'>
                	<div class="col-lg-6">
                		<form id="searchForm" action="/board/list" method="get">
                			<select name="type">
                				<option value=""
                				 <c:out value="${pageMaker.cri.type == null ? 'selected':''}"/>>--</option>
                				<option value="T"
                				 <c:out value="${pageMaker.cri.type eq 'T' ? 'selected':''}"/>>제목</option>
                				<option value="C"
                				<c:out value="${pageMaker.cri.type eq 'C' ? 'selected':''}"/>>내용</option>
                				<option value="W"
                				<c:out value="${pageMaker.cri.type eq 'W' ? 'selected':''}"/>>작성자</option>
                				<option value="TC"
                				<c:out value="${pageMaker.cri.type eq 'TC' ? 'selected':''}"/>>제목+내용</option>
                				<option value="TW"
                				<c:out value="${pageMaker.cri.type eq 'TW' ? 'selected':''}"/>>제목+작성자</option>
                				<option value="TWC"
                				<c:out value="${pageMaker.cri.type eq 'TWC' ? 'selected':''}"/>>제목+내용+작성자</option>
                			</select>
                			<input type="text" name="keyword"
                				value='<c:out value="${pageMaker.cri.keyword }"/>' />
                			<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum }'>
							<input type='hidden' name='amount' value='${pageMaker.cri.amount }'>
							<button class="btn btn-default">Search</button>
                		</form>
                	</div>
                	<div class='float-right'>
                	<ul class="pagination">
                		<c:if test="${pageMaker.prev}">
                			<li class="page-item"><a class="page-link" href="${pageMaker.startPage - 1}">Previous</a>
                			</li>
                		</c:if>
                		
                		<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                			<li class="page-item ${pageMaker.cri.pageNum == num ? 'active' : '' }">
                				<a class="page-link" href="${num}">${num}</a>
                			</li>
                		</c:forEach>
           
                		<c:if test="${pageMaker.next}">
                			<li class="page-item"><a class="page-link" href="${pageMaker.endPage + 1}">Next</a>
                			</li>
                		</c:if>
                	</ul>
                	</div>
                </div>
                
              </div>
            </div>
          </div>

<%@include file="../includes/footer.jsp" %>

 <div class="modal fade" id="resultModal" tabindex="-1" role="dialog" aria-labelledby="resultModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="resultModalLabel">Result</h5>
          <button class="close" type="button" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">×</span>
          </button>
        </div>
        <div class="modal-body">Success</div>
        <div class="modal-footer">
          <button class="btn btn-primary" type="button" data-dismiss="modal">OK</button>
        </div>
      </div>
    </div>
  </div>

<form id='actionForm' action="/board/list" method='get'>
	<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum }'>
	<input type='hidden' name='amount' value='${pageMaker.cri.amount }'>
	<input type="hidden" name="keyword" value='${pageMaker.cri.keyword }' >
	<input type="hidden" name="type" value='${pageMaker.cri.type }' >
</form>

<script type="text/javascript">
	$(document).ready(function() {
		
		var result = '<c:out value="${result}"/>';

		checkModal(result);
		
		history.replaceState({}, null, null);

		
		function checkModal(result) {
			if (result === '' || history.state) {
				return;
			}
			
			if (parseInt(result) > 0) {
				$(".modal-body").html("게시글 " + parseInt(result) + "번이 등록되었습니다.");
			}
			
			$("#resultModal").modal("show");
		}
		
		$("#regBtn").on("click", function() {
			self.location = "/board/register";
		});
		
		var actionForm = $("#actionForm");
		$(".page-item a").on("click", function(e) {
			e.preventDefault();

			actionForm.find("input[name='pageNum']").val($(this).attr("href"));
			actionForm.submit();
		});
		
		$(".move").on("click", function(e) {
			e.preventDefault();
			
			actionForm.append("<input type='hidden' name='bno' value='" + $(this).attr("href") + "'>");
			actionForm.attr("action", "/board/get");
			actionForm.submit();
		});
		
		var searchForm = $('#searchForm');
		
		$("#searchForm button").on("click", function(e) {
			if (!searchForm.find("option:selected").val()) {
				alert("검색종류를 선택하세요");
				return false;
			}
			
			if (!searchForm.find("input[name='keyword']").val()) {
				alert("키워드를 입력하세요");
				return false;
			}
			
			searchForm.find("input[name='pageNum']").val("1");
			e.preventDefault();
			
			searchForm.submit();
		});
	});
</script>

  </body>

</html>