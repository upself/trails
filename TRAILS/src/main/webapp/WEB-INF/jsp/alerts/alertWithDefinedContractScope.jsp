<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-v17ePagination-1.0.0.js"></script>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!-- Search form -->
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<h6>IBM Confidential</h6>
		<p>This page displays number of active auditable software instances on active software scans where contract scope is not defined in Schedule F section of TRAILS. Assigment of these alerts can be performed in the reconciliation workspace</p>
		
		<div style="text-align:right">
			<a href="${pageContext.request.contextPath}/ws/alertWithDefinedContractScope/download/${accountId}">Download SOM3: SW INSTANCES WITH DEFINED CONTRACT SCOPE alert report</a>
		</div>
		<br />
	</div>
	
<!-- 	<div class="ibm-col-1-1"> -->
<!-- 		<div class="ibm-rule"> -->
<!-- 				<hr /> -->
<!-- 		</div> -->
<!-- 		<form onsubmit="return false;" action="" class="ibm-column-form" enctype="multipart/form-data" method="post"> -->
<!-- 			<p> -->
<!-- 				<label for="commons"> -->
<%-- 					Comments:<span class="ibm-required">*</span> --%>
<!-- 				</label>  -->
<%--                 <span> --%>
<!-- 					<textarea id="comments" cols="38" rows="7" name="message"></textarea> -->
<%-- 				</span> --%>
<!-- 			</p> -->
			
<!-- 			<div class="ibm-columns"> -->
<!-- 				<div class="ibm-col-1-1" style="text-align:right"> -->
<!-- 					<input type="submit" value="assign/update" name="ibm-cancel" class="ibm-btn-cancel-pri ibm-btn-small" onclick="assigncomments(0)" /> -->
<!-- 					<input type="submit" value="unassign" name="ibm-cancel" class="ibm-btn-cancel-pri ibm-btn-small" onclick="unassigncomments(0)" /> -->
<!-- 					<input type="submit" value="assign all" name="ibm-cancel" class="ibm-btn-cancel-pri ibm-btn-small" onclick="assigncomments(1)" /> -->
<!-- 					<input type="submit" value="unassign all" name="ibm-cancel" class="ibm-btn-cancel-pri ibm-btn-small" onclick="unassigncomments(1)" /> -->
<!-- 				</div> -->
<!-- 			</div> -->
<!-- 		</form> -->
<!-- 		<div class="ibm-rule"> -->
<!-- 			<hr /> -->
<!-- 		</div> -->
		
<!-- 		<div class="ibm-columns"> -->
<!-- 			<div class="ibm-col-1-1" style="text-align:right"> -->
<!-- 				<input type="submit" value="Select all" name="ibm-cancel" class="ibm-btn-cancel-pri ibm-btn-small" onclick="toggleSelects(true)" /> -->
<!-- 				<input type="submit" value="Unselect all" name="ibm-cancel" class="ibm-btn-cancel-pri ibm-btn-small" onclick="toggleSelects(false)" /> -->
<!-- 			</div> -->
<!-- 		</div> -->
<!-- 	</div> -->
	
	<!-- SORTABLE DATA TABLE -->
	<div class="ibm-col-1-1">
		<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table" summary="Sortable Non Instance based SW table">
			<thead>
				<tr>
					<th scope="col" class="ibm-sort nobreak">Oldest alert status</th>
					<th scope="col" class="ibm-sort nobreak">Installed component</th>
					<th scope="col" class="ibm-sort nobreak">Number of instances</th>
					<th scope="col" class="ibm-sort nobreak">Date loaded</th>
					<th scope="col" class="ibm-sort nobreak">Oldest alert age</th>
				</tr>
			</thead>
			<tbody id="tb">
				
			</tbody>
		</table>
		<p class="ibm-table-navigation" id="pagebar"></p>
		
	</div>
</div>
<script>
$(function(){
	searchData();
});

function searchData(){
	var params = {};
	params['accountId'] = '${accountId}';
	params['sort'] = 'alertAge';
	params['dir'] = 'desc';
	
	$("#pagebar").v17ePagination('destroy').v17ePagination({
		showInfo: true,
		showPageSizes: true,
		remote: {
			url: "${pageContext.request.contextPath}/ws/alertWithDefinedContractScope/search",
			type: "POST",
			params: params,
			success: function(result, pageIndex){
				var html = '';
				var list = result.data.list;
				if(null == list || list == undefined || list.length == 0){
					html += "<tr><td colspan='5' align='center'>No data found</td></tr>"
				}else{
					for(var i = 0; i < list.length; i++){
						html += "<tr>";
// 						html += "<td><input value='"+list[i].tableId+"' type='checkbox'></td>";
						html += "<td>" + list[i].alertStatus + "</td>";
						html += "<td>" + list[i].softwareItemName + "</td>";
						html += "<td>" + list[i].alertCount + "</td>";
						html += "<td>" + list[i].creationTime + "</td>";
						html += "<td>" + list[i].alertAge + "</td>";
// 						html += "<td><a href='javascript:void()' onclick='displayPopUp(\"alertWithDefinedContractScope.htm?id=" + list[i].tableId+"\");return false;'>View</a></td>";
						html += "</tr>";
					}
				}
				$("#tb").html(html);
			}
		}
	}); 
}

// function assignComments(type){
	
// 	var comments = $('#comments').val();
// 	var url = '${pageContext.request.contextPath}/ws/alertWithDefinedContractScope/';
// 	var params = {};
	
// 	//validate comments
// 	if(comments.trim() == ''){
// 		alert('Please input comments.');
// 		return;
// 	}
	
// 	if(comments.trim().length > 255){
// 		alert('Comments must be less than 255 characters');
// 		return;
// 	}
	
// 	if(type == 1){
// 		//assign all
// 		url +=  'assign/all';
// 		params['comments'] = comments;
// 		params['accountId'] = accountId;
// 	}
	
// 	if(type == 0){
// 		//not assign all
// 		url += 'assign/ids'
// 		if($('#tb input:checked').length <= 0){
// 			alert('Please select at least one column of data to assign comments ');
// 			return;
// 		}else{
// 			var assignIds = '';
// 			$('#tb input:checked').each(function(){
// 				assignIds += $(this).val() + ',';
// 			});
// 			assignIds = assignIds.substring(0,assignIds.length - 1);
			
// 			params['comments'] = comments;
// 			params['assignIds'] = assignIds;
// 		}
// 	}
	
// 	assignOrNot(url,params);
// }

// function unassignComments(type){
	
// 	var comments = $('#comments').val();
// 	var url = '${pageContext.request.contextPath}/ws/alertWithDefinedContractScope/';
// 	var params = {};
	
// 	//validate comments
// 	if(comments.trim() == ''){
// 		alert('Please input comments.');
// 		return;
// 	}
	
// 	if(comments.trim().length > 255){
// 		alert('Comments must be less than 255 characters');
// 		return;
// 	}
	
// 	if(type == 1){
// 		//assign all
// 		url +=  'unassign/all';
// 		params['comments'] = comments;
// 		params['accountId'] = accountId;
// 	}
	
// 	if(type == 0){
// 		//not assign all
// 		url += 'unassign/ids'
// 		if($('#tb input:checked').length <= 0){
// 			alert('Please select at least one column of data to unassign comments ');
// 			return;
// 		}else{
// 			var unassignIds = '';
// 			$('#tb input:checked').each(function(){
// 				unassignIds += $(this).val() + ',';
// 			});
// 			unassignIds = unassignIds.substring(0,unassignIds.length - 1);

// 			params['comments'] = comments;
// 			params['unassignIds'] = unassignIds;
// 		}
// 	}
	
// 	assignOrNot(url,params);
// }

// function assignOrNot(url,params){
// 	$.ajax({
// 		url: url,
// 		data: params,
// 		type: 'POST',
// 		dataType: 'json',
// 		success: function(wsMsg){
// 			if(wsMsg.status != '200'){
// 				alert(wsMsg.msg);
// 			}
// 		},
// 		error: function(response,status,error){
// 			alert(error);
// 		},
// 		complete: function(){
// 			searchData();
// 		}
// 	});
// }

function displayPopUp(page) {
	
	window.open(page, 'PopUpWindow', 'left=200,top=180,resizable=yes,scrollbars=yes,width=840,height=500');
}

// function toggleSelects(type){
// 	$("#tb input[type='checkbox']").prop("checked", type); 
// }
</script>