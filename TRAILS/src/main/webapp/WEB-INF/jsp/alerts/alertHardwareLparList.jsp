<script src="${pageContext.request.contextPath}/js/jquery-paginationTable-1.0.js"></script>
<!-- Search form -->
<!-- story 19455 -->
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<p class="ibm-confidential">IBM Confidential</p>
		<p>This page displays hardware lpars without an associated software lpar. Use the checkboxes to assign, update or unassign alerts. You must enter a comment to successfully update the alert.</p>
		<div style="text-align:right">
			<a href="${pageContext.request.contextPath}/ws/alertHardwareLpar/download/${accountId}">Download SOM2a: HW LPAR with SW LPAR alert report</a>
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
					<input type="submit" value="Assign/Update" name="ibm-cancel" class="ibm-btn-cancel-pri ibm-btn-small" onclick="assignComments(0)" />
					<input type="submit" value="Unassign" name="ibm-cancel" class="ibm-btn-cancel-pri ibm-btn-small" onclick="unassignComments(0)" />
					<input type="submit" value="Assign All" name="ibm-cancel" class="ibm-btn-cancel-pri ibm-btn-small" onclick="assignComments(1)" />
					<input type="submit" value="Unassign All" name="ibm-cancel" class="ibm-btn-cancel-pri ibm-btn-small" onclick="unassignComments(1)" />
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
		<table id="page" cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-alternating" summary="SOM2a: HW LPAR with SW LPAR">
			<thead>
				<tr>
					<th scope="col" class="ibm-sort nobreak"><a href="javascript:void(0)"><span>Assign/Unassign</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort nobreak"><a href="javascript:void(0)"><span>Status</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort nobreak"><a href="javascript:void(0)"><span>Name</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort nobreak"><a href="javascript:void(0)"><span>Create date</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort nobreak"><a href="javascript:void(0)"><span>Age(days)</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort nobreak"><a href="javascript:void(0)"><span>Assignee</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort nobreak"><a href="javascript:void(0)"><span>Comments</span><span class="ibm-icon"></span></a></th>
				</tr>
			</thead>
			<tbody id="tb">
				
			</tbody>
		</table>
	</div>
</div>
<script>
$(function(){
	$("#titleContent").text($("#titleContent").text() + " Alert: ${account.name}(${account.account})");
	searchData();
});

function searchData(){
	var params = {};
	params['accountId'] = '${accountId}';
	params['sort'] = 'alertAge';
	params['dir'] = 'desc';
	
	$("#page").paginationTable('destroy').paginationTable({
		remote: {
			url: "${pageContext.request.contextPath}/ws/alertHardwareLpar/search",
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
						html += "<td><a href='javascript:void()' onclick='popupHardwarelpar(" + list[i].account.account + ",\"" +list[i].hardwareLpar.name+ "\"," + list[i].hardwareLpar.id + ");return false;'>" + list[i].hardwareLpar.name + "</a></td>";
						html += "<td>" + list[i].creationTime + "</td>";
						html += "<td>" + list[i].alertAge + "</td>";
						html += "<td>" + list[i].remoteUser + "</td>";
						html += "<td><a href='javascript:void()' onclick='displayPopUp(\"alertHardwareLparHistory.htm?id="+list[i].tableId+"\");return false;'>View</a></td>";
						html += "</tr>";
					}
				}
				$("#tb").html(html);
			}
		},
		orderColumns: ['tableId','alertAge','hardwareLpar.name','creationTime','alertAge','remoteUser','tableId']
	}); 
};
function assignComments(type){
	
	var comments = $('#comments').val();
	var url = '${pageContext.request.contextPath}/ws/alertHardwareLpar/';
	var params = {};
	
	//validate comments
	if(comments.trim() == ''){
		alert('Please input comments.');
		return;
	}
	
	if(comments.trim().length > 255){
		alert('Comments must be less than 255 characters');
		return;
	}
	
	if(type == 1){
		//assign all
		url +=  'assign/all';
		params['comments'] = comments;
		params['accountId'] = '${accountId}';
	}
	
	if(type == 0){
		//not assign all
		url += 'assign/ids'
		if($('#tb input:checked').length <= 0){
			alert('Please select at least one column of data to assign comments ');
			return;
		}else{
			var assignIds = '';
			$('#tb input:checked').each(function(){
				assignIds += $(this).val() + ',';
			});
			assignIds = assignIds.substring(0,assignIds.length - 1);
			
			params['comments'] = comments;
			params['assignIds'] = assignIds;
		}
	}
	
	assignOrNot(url,params);
}

function unassignComments(type){
	
	var comments = $('#comments').val();
	var url = '${pageContext.request.contextPath}/ws/alertHardwareLpar/';
	var params = {};
	
	//validate comments
	if(comments.trim() == ''){
		alert('Please input comments.');
		return;
	}
	
	if(comments.trim().length > 255){
		alert('Comments must be less than 255 characters');
		return;
	}
	
	if(type == 1){
		//assign all
		url +=  'unassign/all';
		params['comments'] = comments;
		params['accountId'] = '${accountId}';
	}
	
	if(type == 0){
		//not assign all
		url += 'unassign/ids'
		if($('#tb input:checked').length <= 0){
			alert('Please select at least one column of data to unassign comments ');
			return;
		}else{
			var unassignIds = '';
			$('#tb input:checked').each(function(){
				unassignIds += $(this).val() + ',';
			});
			unassignIds = unassignIds.substring(0,unassignIds.length - 1);

			params['comments'] = comments;
			params['unassignIds'] = unassignIds;
		}
	}
	
	assignOrNot(url,params);
}

function assignOrNot(url,params){
	$.ajax({
		url: url,
		data: params,
		type: 'POST',
		dataType: 'json',
		beforeSend:function(){
			$("#page").paginationTable('showLoading');
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

function popupHardwarelpar(accountId, lparName, hwId) {
	newWin=window.open('//${bravoServerName}/BRAVO/lpar/view.do?accountId=' + accountId + '&lparName=' + lparName + '&hwId=' + hwId,'popupWindow','height=600,width=1200,resizable=yes,menubar=yes,status=yes,toolbar=yes,scrollbars=yes'); 
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


