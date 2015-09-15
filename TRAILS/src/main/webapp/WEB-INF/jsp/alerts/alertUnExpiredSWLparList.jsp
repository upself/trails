<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-v17ePagination-1.0.0.js"></script>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!-- Search form -->
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<h6>IBM Confidential</h6>
		<p>This page displays hardware lpars without an associated software lpar. Use the checkboxes to assign, update or unassign alerts. You must enter a comment to successfully update the alert.</p>
		<div style="text-align:right">
			<a href="${pageContext.request.contextPath}/ws/alertUnExpiredSWLpar/download/${accountId}">Download SOM2c: UNEXPIRED SW LPARalert report</a>
		</div>
	</div>
	
	<div class="ibm-col-1-1">
		<div class="ibm-rule">
				<hr />
		</div>
		<form onsubmit="return false;" action="" class="ibm-column-form" enctype="multipart/form-data" method="post">
			<p>
				<label for="commons">
					Comments:<span class="ibm-required">*</span>
				</label> 
                <span>
					<textarea id="comments" cols="38" rows="7" name="message"></textarea>
				</span>
			</p>
			
			<div class="ibm-columns">
				<div class="ibm-col-1-1" style="text-align:right">
					<input type="submit" value="Assign/Update" name="ibm-cancel" class="ibm-btn-cancel-pri ibm-btn-small" onclick="assignOrUnAssign('assign', false)" />
					<input type="submit" value="Unassign" name="ibm-cancel" class="ibm-btn-cancel-pri ibm-btn-small" onclick="assignOrUnAssign('unassign', false)" />
					<input type="submit" value="Assign All" name="ibm-cancel" class="ibm-btn-cancel-pri ibm-btn-small" onclick="assignOrUnAssign('assign', true)" />
					<input type="submit" value="Unassign All" name="ibm-cancel" class="ibm-btn-cancel-pri ibm-btn-small" onclick="assignOrUnAssign('unassign', true)" />
				</div>
			</div>
		</form>
		<div class="ibm-rule">
			<hr />
		</div>
		
		<div class="ibm-columns">
			<div class="ibm-col-1-1" style="text-align:right">
				<input type="submit" value="Select all" name="ibm-cancel" class="ibm-btn-cancel-pri ibm-btn-small" onclick="toggleSelects(true)" />
				<input type="submit" value="Unselect all" name="ibm-cancel" class="ibm-btn-cancel-pri ibm-btn-small" onclick="toggleSelects(false)" />
			</div>
		</div>
	</div>
	
	<!-- SORTABLE DATA TABLE -->
	<div class="ibm-col-1-1">
		<table id="abcd" cellspacing="0" cellpadding="0" border="0" class="ibm-data-table" summary="Sortable Non Instance based SW table">
			<thead>
				<tr>
					<th scope="col" class="ibm-sort nobreak">Assign/Unassign</th>
					<th scope="col" class="ibm-sort nobreak">Status</th>
					<th scope="col" class="ibm-sort nobreak">Name</th>
					<th scope="col" class="ibm-sort nobreak">Scantime</th>
					<th scope="col" class="ibm-sort nobreak">Alert Age(days)</th>
					<th scope="col" class="ibm-sort nobreak">Assignee</th>
					<th scope="col" class="ibm-sort nobreak">Comments</th>
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
			url: "${pageContext.request.contextPath}/ws/alertUnExpiredSWLpar/search",
			type: "POST",
			params: params,
			success: function(result, pageIndex){
				var html = '';
				var list = result.data.list;
				if(null == list || list == undefined || list.length == 0){
					html += "<tr><td colspan='7' align='center'>No data found</td></tr>"
				}else{
					for(var i = 0; i < list.length; i++){
						html += "<tr>";
						html += "<td><input value='"+list[i].tableId+"' type='checkbox'></td>";
						html += "<td>" + list[i].alertStatus + "</td>";
						html += "<td><a href='javascript:void()' onclick='popupBravoSl(${accountId},\"" + list[i].softwareLpar.name + "\"," + list[i].softwareLpar.id +");return false;'>" + list[i].softwareLpar.name + "</a></td>";
						html += "<td>" +list[i].softwareLpar.scanTime + "</td>";
						html += "<td>" + list[i].alertAge + "</td>";
						html += "<td>" + list[i].remoteUser + "</td>";
						html += "<td><a href='javascript:void()' onclick='displayPopUp(\"alertExpiredScanHistory.htm?id="+list[i].tableId+"\");return false;'>View</a></td>";
						html += "</tr>";
					}
				}
				$("#tb").html(html);
			}
		}
	}); 
};

function assignOrUnAssign(assignType,isAll){
	var comments = $('#comments').val();
	var url = '${pageContext.request.contextPath}/ws/alertUnExpiredSWLpar/';
	var params = {};
	var ids = '';
	
	//validate comments
	if(comments.trim() == ''){
		alert('Please input comments.');
		return;
	}
	
	if(comments.trim().length > 255){
		alert('Comments must be less than 255 characters');
		return;
	}
	
	//validate ids
	if(!isAll){
		if($('#tb input:checked').length <= 0){
			alert('Please select at least one column of data to ' + assignType + ' comments ');
			return;
		}else{
			$('#tb input:checked').each(function(){
				ids += $(this).val() + ',';
			});
			ids = ids.substring(0,ids.length - 1);
		}
	}
	
	//init url
	if(isAll){
		url += assignType+"/all";
	}else{
		url += assignType+"/ids";
		params['ids'] = ids;
	}
	
	//init params
	params['comments'] = comments;
	params['accountId'] = '${accountId}';
	
	//do assignOrUnassign
	doAssignOrNot(url,params);
}

function doAssignOrNot(url,params){
	$.ajax({
		url: url,
		data: params,
		type: 'POST',
		dataType: 'json',
		beforeSend: function(){
			$("#pagebar").v17ePagination('showLoading');
		},
		success: function(wsMsg){
			if(wsMsg.status != '200'){
				alert(wsMsg.msg);
			}
			$('#comments').val('');
		},
		error: function(response,status,error){
			alert(error);
		},
		complete: function(){
			searchData();
		}
	});
}

function popupBravoSl( accountId, lparName, swId) {
	newWin=window.open('//${bravoServerName}/BRAVO/lpar/view.do?accountId=' + accountId + '&lparName=' + lparName + '&swId=' + swId,'popupWindow','height=600,width=1200,resizable=yes,menubar=yes,status=yes,toolbar=yes,scrollbars=yes'); 
	newWin.focus(); 
	void(0);
}

function displayPopUp(page) {
	
	window.open(page, 'PopUpWindow', 'left=200,top=180,resizable=yes,scrollbars=yes,width=840,height=500');
}

function toggleSelects(type){
	$("#tb input[type='checkbox']").prop("checked", type); 
}
</script>


