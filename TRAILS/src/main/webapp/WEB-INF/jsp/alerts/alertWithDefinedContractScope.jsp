<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!-- Search form -->
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<h6>IBM Confidential</h6>
		<p>This page displays hardware without critical configuration data populated. Use the checkboxes to assign, update or unassign alerts. You must enter a comment to successfully update the alert.</p>
		<div style="text-align:right">
			<a href="${pageContext.request.contextPath}/ws/alertHardwareCfgData/download/${accountId}">Download SOM3: SW INSTANCES WITH DEFINED CONTRACT SCOPE alert report</a>
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
					<th scope="col" class="ibm-sort nobreak">Serial</th>
					<th scope="col" class="ibm-sort nobreak">MachineType</th>
					<th scope="col" class="ibm-sort nobreak">Create date</th>
					<th scope="col" class="ibm-sort nobreak">Age(days)</th>
					<th scope="col" class="ibm-sort nobreak">Assignee</th>
					<th scope="col" class="ibm-sort nobreak">Comments</th>
				</tr>
			</thead>
			<tbody id="tb">
				
			</tbody>
		</table>
		<span class="ibm-spinner-large" id="loading" style="display:none"></span>
		<p class="ibm-table-navigation" id="paginationBar"></p>
		
	</div>
</div>
<script>
var total;
var pageSize;
var currentPage;
var accountId = '${accountId}'

$(function(){
	pageSize = 20;
	goPage(1);
});

function goPage(pageNo){
	var params = {};
	params['accountId'] = accountId;
	params['currentPage'] = pageNo;
	params['pageSize'] = pageSize;
	params['sort'] = 'alertAge';
	params['dir'] = 'desc';
	var url =  "${pageContext.request.contextPath}/ws/alertHardwareCfgData/search";
	$.ajax({
		url: url,
		data: params,
		type: 'POST',
		dataType: 'json',
		beforeSend: function(){
			$('#tb').html('');
			$('#paginationBar').html('');
			showLoading();
		},
		success: function(wsMsg){
			if(wsMsg.status != '200'){
				alert(wsMsg.msg);
			}else{
				var html = '';
				for(var i = 0; i < wsMsg.data.list.length; i++){
					html += "<tr>";
					html += "<td><input value='"+wsMsg.data.list[i].tableId+"' type='checkbox'></td>";
					html += "<td>" + wsMsg.data.list[i].alertStatus + "</td>";
					html += "<td><a href='javascript:void()' onclick='popupHardwareCfgData();return false;'>" + wsMsg.data.list[i].hardware.serial + "</a></td>";
					html += "<td>" + wsMsg.data.list[i].hardware.machineType.type + "</td>";
					html += "<td>" + wsMsg.data.list[i].creationTime + "</td>";
					html += "<td>" + wsMsg.data.list[i].alertAge + "</td>";
					html += "<td>" + wsMsg.data.list[i].remoteUser + "</td>";
					html += "<td><a href='javascript:void()' onclick='displayPopUp(\"alertHardwareCfgDataHistory.htm?id="+wsMsg.data.list[i].tableId+"\");return false;'>View</a></td>";
					html += "</tr>";
				}
				$('#tb').html(html);
				total = wsMsg.data.total;
				pageSize = wsMsg.data.pageSize;
				currentPage = wsMsg.data.currentPage;
				refreshPaginationBar();
			}
		},
		error: function(response,status,error){
			alert(error);
		},
		complete: function(){
			hideLoading();
		}
	});
}

function assignComments(type){
	
	var comments = $('#comments').val();
	var url = '${pageContext.request.contextPath}/ws/alertHardwareCfgData/';
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
		params['accountId'] = accountId;
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
	var url = '${pageContext.request.contextPath}/ws/alertHardwareCfgData/';
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
		params['accountId'] = accountId;
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
			$('#tb').html('');
			$('#paginationBar').html('');
			showLoading();
		},
		success: function(wsMsg){
			if(wsMsg.status != '200'){
				alert(wsMsg.msg);
			}
		},
		error: function(response,status,error){
			alert(error);
		},
		complete: function(){
			goPage(currentPage);
		}
	});
}

function popupHardwareCfgData() {
	newWin=window.open('//${bravoServerName}/BRAVO/account/view.do?accountId=${accountId}','popupWindow','height=600,width=1200,resizable=yes,menubar=yes,status=yes,toolbar=yes,scrollbars=yes'); 
	newWin.focus(); 
	void(0);
}

function displayPopUp(page) {
	
	window.open(page, 'PopUpWindow', 'left=200,top=180,resizable=yes,scrollbars=yes,width=840,height=500');
}
function goPrePage(){
	if(currentPage == 1){
		alert('The first page ');
		return;
	}else{
		goPage(currentPage - 1);
	}
}

function goNextPage(){
	if(currentPage * pageSize > total){
		alert('The last page ');
		return;
	}else{
		goPage(currentPage + 1);
	}
	
}

function changePageSize(ps){
	pageSize = ps;
	goPage(currentPage);
}

function refreshPaginationBar(){
	var html = "";
	
	//ibm primary navigation
	html +="<span class='ibm-primary-navigation'>";
	html += "<strong>" + ((currentPage-1) * pageSize + 1) + '-' + (currentPage * pageSize) + "</strong> of <strong>" + total + "</strong> results ";
	if(currentPage <= 1){
		html += "<span class='ibm-table-navigation-links'> | <a class='ibm-forward-em-link' href='javascript:void(0)' onclick='goNextPage()'>Next</a></span>";
	}else if(currentPage >1 && currentPage * pageSize < total){
		html += "<span class='ibm-table-navigation-links'> | <a class='ibm-forward-em-link' href='javascript:void(0)' onclick='goPrePage()'>Pre</a>";
		html += " | <a class='ibm-forward-em-link' href='javascript:void(0)' onclick='goNextPage()'>Next</a></span>"
	}else if(currentPage * pageSize >= total){
		html += "<span class='ibm-table-navigation-links'> | <a class='ibm-forward-em-link' href='javascript:void(0)' onclick='goPrePage()'>Pre</a></span>";
	}else{
		html += "<span class='ibm-table-navigation-links'>Initilization pagination bar failed</span>";
	}
	html +="</span>"

	//ibm secondary navigation
	html += "<span class='ibm-secondary-navigation'>";
	html += "<span>Results per page: </span> <strong>" + pageSize + "</strong>";
	if(pageSize == 20){
		html += "<span class='ibm-table-navigation-links'> | <a href='#' onclick='changePageSize(50); return false;'>50</a>";
		html += " | <a href='#' onclick='changePageSize(100); return false;'>100</a></span>";
	}
	
	if(pageSize == 50){
		html += "<span class='ibm-table-navigation-links'> | <a href='#' onclick='changePageSize(20); return false;'>20</a>";
		html += " | <a href='#' onclick='changePageSize(100); return false;'>100</a></span>";
	}
	
	if(pageSize == 100){
		html += "<span class='ibm-table-navigation-links'> | <a href='#' onclick='changePageSize(20); return false;'>20</a>";
		html += " | <a href='#' onclick='changePageSize(50); return false;'>50</a></span>";
	}
	html += "</span>";
	
	$('#paginationBar').html(html);
}

function showLoading(){
	$('#loading').show();
}

function hideLoading(){
	$('#loading').hide();
}

function toggleSelects(type){
	$("#tb input[type='checkbox']").prop("checked", type); 
}
</script>