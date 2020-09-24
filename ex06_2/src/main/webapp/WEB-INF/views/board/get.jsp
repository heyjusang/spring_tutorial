<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@include file="../includes/header.jsp" %>

<sec:authentication property="principal" var="pinfo" />
<!-- Page Heading -->
<h1 class="h3 mb-2 text-gray-800">Board Register</h1>
<p class="mb-4">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>

<div class="card shadow mb-4">
	<div class="card-header py-3">
    	<h6 class="m-0 font-weight-bold text-primary">Board Read Page</h6>
    </div>
    <div class="card-body">
      	<div class="form-group">
        	<label>Bno</label>
        	<input class="form-control" name="bno" value='<c:out value="${board.bno }"/>' readonly="readonly">
       	</div>  
        	<div class="form-group">
        		<label>Title</label>
        		<input class="form-control" name="title" value='<c:out value="${board.title }"/>' readonly="readonly">
        	</div>
        	<div class="form-group">
        		<label>Content</label>
        		<textarea class="form-control" rows="3" name="content" readonly="readonly"><c:out value="${board.content}"/>
        		</textarea>
        	</div>
        	
        	<div class="form-group">
        		<label>Writer</label>
        		<input class="form-control" name="writer" value='<c:out value="${board.writer }"/>' readonly="readonly">
        	</div>
        		<sec:authorize access="isAuthenticated()">
        			<c:if test="${pinfo.username eq board.writer}">
        				<button data-oper="modify" class="btn btn-primary">Modify</button>
        			</c:if>
        		</sec:authorize>
        	<button data-oper="list" class="btn btn-default">List</button>
        		
        	<form id="operForm" action="/board/modify" method="get">
        		<input type='hidden' id='bno' name='bno' value='<c:out value="${board.bno }"/>'>
        		<input type='hidden' id='pageNum' name='pageNum' value='<c:out value="${cri.pageNum }"/>'>
        		<input type='hidden' id='amount' name='amount' value='<c:out value="${cri.amount }"/>'>
        		<input type='hidden' id='keyword' name='keyword' value='<c:out value="${cri.keyword }"/>'>
        		<input type='hidden' id='type' name='type' value='<c:out value="${cri.type }"/>'>        		        		
        	</form>
      
    </div>
 </div>
 
 <div class='row'>
 	<div class="col-lg-12">
 	
 		<div class="card shadow m4">
 			<div class="card-header">
 				<i class="fa fa-comments fa-fw"></i> Reply
 				<sec:authorize access="isAuthenticated()">
 				<button id='addReplyBtn' class='btn btn-primary btn-xs float-right'>New Reply</button>
 				</sec:authorize>
 			</div>
 			
 			<div class="card-body">
 				<ul class="list-group list-group-flush chat">
 					<li class="list-group-item left clearfix" data-rno='12'>
 						<div>
 							<div class="header">
 								<strong class="primary-font">user00</strong>
 								<small class="float-right text-muted">2020-01-01 01:13 </small>
 							</div>
 							<p> Good job!</p>
 						</div>
 					</li>
 				</ul>
 			</div>
 			
 			<div class="card-footer" id="reply-paginator">
 			</div>
 		</div>
 	</div>
 </div>

<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="myModalLabel">REPLY MODAL</h5>
          <button class="close" type="button" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">x</span>
          </button>
        </div>
        <div class="modal-body">
        	<div class="form-group">
        		<label>Reply</label>
        		<input class="form-control" name="reply" value="New Reply!!">
        	</div>
        	<div class="form-group">
        		<label>Replyer</label>
        		<input class="form-control" name="replyer" value="replyer" readonly="readonly">
        	</div>
        	<div class="form-group">
        		<label>Reply Date</label>
        		<input class="form-control" name="replyDate" value="">
        	</div>        	        
        </div>
        <div class="modal-footer">
        	<button id='modalModBtn' type="button" class="btn btn-warning">Modify</button>
        	<button id='modalRemoveBtn' type="button" class="btn btn-danger">Remove</button>
        	<button id='modalRegisterBtn' type="button" class="btn btn-primary" data-dismiss="modal">Register</button>
        	<button id='modalCloseBtn' type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>

<%@include file="../includes/footer.jsp" %>

<script type="text/javascript" src="/resources/js/reply.js" ></script>

<script>

$(document).ready(function() {
	var bnoValue = '<c:out value="${board.bno}"/>';
	var replyUL = $(".chat");
	
	showList(1);
	
	function showList(page) {
		replyService.getList({bno:bnoValue, page: page || 1}, function(replyCnt, list) {
			if (page == -1) {
				pageNum = Math.ceil(replyCnt/10.0);
				showList(pageNum);
				return;
			}
			
			
			var str ="";
			if (list == null || list.length == 0) {
				replyUL.html("");
				return;
			}
			
			for (var i = 0, len = list.length; i < len; i++) {
				str += "<li class='list-group-item left clearfix' data-rno='"+list[i].rno+"'>";
				str += "	<div><div class='header'><strong class='primary-font'>"+list[i].replyer+"</strong>";
				str += "	<small class='float-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small></div>";
				str += "	<p>"+list[i].reply+"</p></div></li>";
			}
			
			replyUL.html(str);
			
			showReplyPage(replyCnt);
		})
	}
	
	var pageNum = 1;
	var replyPageFooter = $("#reply-paginator");
	
	function showReplyPage(replyCnt) {
		var endNum = Math.ceil(pageNum / 10.0) * 10;
		var startNum = endNum - 9;
		
		var prev = startNum != 1;
		var next = false;
		
		if (endNum * 10 >= replyCnt) {
			endNum = Math.ceil(replyCnt/10.0);
		}
		
		if (endNum * 10 < replyCnt) {
			next = true;
		}
		
		var str = "<ul class='pagination float-right'>";
		
		if (prev) {
			str += "<li class='page-item'><a class='page-link' href='"+(startNum-1)+"'>Prev</a></li>";
		}

		for (var i = startNum ; i <= endNum; i++) {
			var active = pageNum == i ? "active":"";
			str += "<li class='page-item "+active+" '><a class='page-link' href='"+i+"'>"+i+"</a></li>";
		}
		
		if (next) {
			str += "<li class='page-item'><a class='page-link' href='"+(endNum+1)+"'>Next</a></li>";
		}
		
		str += "</ul></div>";
		
		replyPageFooter.html(str);
	}
	
	
	var modal = $("#myModal");
	var modalInputReply = modal.find("input[name='reply']");
	var modalInputReplyer = modal.find("input[name='replyer']");
	var modalInputReplyDate = modal.find("input[name='replyDate']");
	
	var modalModBtn = $("#modalModBtn");
	var modalRemoveBtn = $("#modalRemoveBtn");
	var modalRegisterBtn = $("#modalRegisterBtn");
	
	var replyer = null;
	
	<sec:authorize access="isAuthenticated()">
		replyer = '<sec:authentication property="principal.username"/>';
	</sec:authorize>
	
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	
	$(document).ajaxSend(function(e, xhr, options) {
		xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	});
	
	modalRegisterBtn.on("click", function(e) {
		var reply = {
				reply: modalInputReply.val(),
				replyer: modalInputReplyer.val(),
				bno:bnoValue
		};
		
		replyService.add(reply, function(result) {
			alert(result);
			
			modal.find("input").val("");
			modal.modal("hide");
			
			showList(-1);
		});
	});
	
	modalModBtn.on("click", function(e) {
		
		var originalReplyer = modalInputReplyer.val();
		
		var reply = {
				rno: modal.data('rno'),
				reply: modalInputReply.val(),
				replyer: originalReplyer
		}
		
		if (!replyer) {
			alert("login please");
			modal.modal("hide");
			return;
		}
		
		if (replyer != originalReplyer) {
			alert("not your reply");
			modal.modal("hide");
			return;
		}
		
		replyService.update(reply, function(result) {
			alert(result);
			
			modal.modal("hide");
			
			showList(pageNum);
		})
	});
	
	modalRemoveBtn.on("click", function(e) {
		var rno = modal.data("rno");
		
		if (!replyer) {
			alert("login please");
			modal.modal("hide");
			return;
		}
		
		var originalReplyer = modalInputReplyer.val();
		
		if (replyer != originalReplyer) {
			alert("not your reply");
			modal.modal("hide");
			return;
		}
		
		replyService.remove(rno, originalReplyer, function(result) {
			alert(result);
			
			modal.modal("hide");
			
			showList(pageNum);
		})
	});
	
	
	$("#addReplyBtn").on("click", function(e) {
		modal.find("input").val("");
		modal.find("input[name='replyer']").val(replyer);
		modalInputReplyDate.closest("div").hide();
		modal.find("button[id !='modalCloseBtn']").hide();
		
		modalRegisterBtn.show();
		
		modal.modal("show");
	});
	
	$(".chat").on("click", "li", function(e) {
		var rno = $(this).data("rno");
		
		replyService.get(rno, function(reply) {
			modalInputReply.val(reply.reply);
			modalInputReplyer.val(reply.replyer);
			modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly", "readonly");
			modal.data("rno", reply.rno);
			
			modal.find("button[id !='modalCloseBtn']").hide();
			modalModBtn.show();
			modalRemoveBtn.show();
			
			modal.modal("show");
		});
	});
	
	replyPageFooter.on("click", "li a", function(e) {
		e.preventDefault();
		var targetPageNum = $(this).attr("href");
		
		pageNum = targetPageNum;
		
		showList(targetPageNum);
	})

})

</script>

<script type="text/javascript">
$(document).ready(function() {
	var operForm = $('#operForm');
	
	$("button[data-oper='modify']").on("click", function(e) {
		operForm.attr("action", "/board/modify");
		operForm.submit();
	});
	
	$("button[data-oper='list']").on("click", function(e) {
		operForm.find("#bno").remove();
		operForm.attr("action", "/board/list");
		operForm.submit();
	});
});
</script>
  </body>

</html>