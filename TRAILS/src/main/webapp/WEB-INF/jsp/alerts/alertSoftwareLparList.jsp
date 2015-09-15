<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-v17ePagination-1.0.0.js"></script>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!-- Search form -->
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<h6>IBM Confidential</h6>
		<p>This page displays software lpars without an associated hardware lpar. Use the checkboxes to assign, update or unassign alerts. You must enter a comment to successfully update the alert.</p>
		<div style="text-align:right">
			<a href="${pageContext.request.contextPath}/ws/alertSwLparWithHwLpar/download/${accountId}">Download SOM2b: SW LPAR WITH HW LPAR alert report</a>
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
		<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table" summary="Sortable Non Instance based SW table">
			<thead>
				<tr>
					<th scope="col" class="ibm-sort nobreak">Assign/Unassign</th>
					<th scope="col" class="ibm-sort nobreak">Status</th>
					<th scope="col" class="ibm-sort nobreak">Name</th>
					<th scope="col" class="ibm-sort nobreak">Scantime</th>
					<th scope="col" class="ibm-sort nobreak">Create date</th>
					<th scope="col" class="ibm-sort nobreak">Age(days)</th>
					<th scope="col" class="ibm-sort nobreak">Serial</th>
					<th scope="col" class="ibm-sort nobreak">OS Name</th>
					<th scope="col" class="ibm-sort nobreak">Assignee</th>
					<th scope="col" class="ibm-sort nobreak">Comments</th>
					<th scope="col" class="ibm-sort nobreak">Unassignee</th>
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
			url: "${pageContext.request.contextPath}/ws/alertSwLparWithHwLpar/search",
			type: "POST",
			params: params,
			success: function(result, pageIndex){
				var html = '';
				var serial = '';
				var osName = '';
				var list = result.data.list;
				if(null == list || list == undefined || list.length == 0){
					html += "<tr><td colspan='8' align='center'>No data found</td></tr>"
				}else{
					for(var i = 0; i < list.length; i++){
						if (list[i].softwareLpar.serial != null) { serial = list[i].softwareLpar.serial; };
						if (list[i].softwareLpar.osName != null) { osName = list[i].softwareLpar.osName; };
						html += "<tr>";
						html += "<td><input value='"+list[i].tableId+"' type='checkbox'></td>";
						html += "<td>" + list[i].alertStatus + "</td>";
						html += "<td><a href='javascript:void()' onclick='popupSwLparWHwLpar();return false;'>" + list[i].softwareLpar.name + "</a></td>";
						html += "<td>" +list[i].softwareLpar.scanTime + "</td>";
						html += "<td>" + list[i].creationTime + "</td>";
						html += "<td>" + list[i].alertAge + "</td>";
						html += "<td>" + serial + "</td>";
						html += "<td>" + osName + "</td>";
						html += "<td>" + list[i].remoteUser + "</td>";
						html += "<td><a href='javascript:void()' onclick='displayPopUp(\"alertSoftwareLparHistory.htm?id="+list[i].tableId+"\");return false;'>View</a></td>";
						html += "</tr>";
					}
				}
				$("#tb").html(html);
			}
		}
	}); 
};
function assignComments(type){
	
	var comments = $('#comments').val();
	var url = '${pageContext.request.contextPath}/ws/alertSwLparWithHwLpar/';
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
	var url = '${pageContext.request.contextPath}/ws/alertSwLparWithHwLpar/';
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

function popupSwLparWHwLpar() {
	newWin=window.open('//${bravoServerName}/BRAVO/account/view.do?accountId=${accountId}','popupWindow','height=600,width=1200,resizable=yes,menubar=yes,status=yes,toolbar=yes,scrollbars=yes'); 
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


