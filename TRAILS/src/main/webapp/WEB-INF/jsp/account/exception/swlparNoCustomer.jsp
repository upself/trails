<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-paginationTable-1.0.js"></script>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!-- Search form -->
<div class="ibm-columns">
	<div class="ibm-col-1-1">
	<h6>IBM Confidential</h6>
	<p>This page displays the data exception record which is software lpars without Customer, you can do assign/unassign/assign all/unassign all operation with 
	clicking proper button below. You must enter a comment to successfully update the data exceptions.</p>
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
	
	<div class="ibm-col-1-1">
		<table id="page" cellspacing="0" cellpadding="0" border="0" class="ibm-data-table" summary="SW LPAR NO CUSTOM">
			<thead>
				<tr>
					<th scope="col" class="ibm-sort nobreak"><a href="javascript:void(0)"><span>Assign/UnAssign</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort nobreak"><a href="javascript:void(0)"><span>Name</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort nobreak"><a href="javascript:void(0)"><span>Scantime</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort nobreak"><a href="javascript:void(0)"><span>Create date</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort nobreak"><a href="javascript:void(0)"><span>Serial</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort nobreak"><a href="javascript:void(0)"><span>OS Name</span><span class="ibm-icon"></span></a></th>
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
	$("#titleContent").text($("#titleContent").text() + ": ${account.name}(${account.account})");
	searchData();
});

function searchData(){
	var params = {};
	params['accountId'] = '${accountId}';
	params['sort'] = 'id';
	params['dir'] = 'desc';
	
	$("#page").paginationTable('destroy').paginationTable({
		remote: {
			url: "${pageContext.request.contextPath}/ws/exceptions/NOCUST/search",
			type: "POST",
			params: params,
			success: function(result, pageIndex){
				var html = '';
				var list = result.data.list;
				if(null == list || list == undefined || list.length == 0){
					html += "<tr><td colspan='8' align='center'>No data found</td></tr>"
				}else{
					for(var i = 0; i < list.length; i++){
						html += "<tr>";
						html += "<td><input value='"+list[i].dataExpId+"' type='checkbox'></td>";
						html += "<td><a href='javascript:void()' onclick='popupBravoSl("+list[i].swLparAccountNumber + ",\""+ list[i].swLparName + "\","+list[i].dataExpId + ");return false;'>"+list[i].swLparName+"</a></td>";
						html += "<td>" + list[i].swLparScanTime + "</td>";
						html += "<td>" + list[i].dataExpCreationTime + "</td>";
						html += "<td>" + list[i].swLparSerial + "</td>";
						html += "<td>" + list[i].swLparOSName + "</td>";
						html += "<td>" + list[i].dataExpAssignee + "</td>";
						html += "<td><a href='javascript:void()' onclick='displayPopUp(\"${pageContext.request.contextPath}/account/exceptions/exceptionSwlparHistory.htm?alertId="+list[i].dataExpId+"&dataExpType="+list[i].dataExpType+"\");return false;'>View</a></td>";
						html += "</tr>";
					}
				}
				$("#tb").html(html);
			}
		},
		orderColumns: ['id','softwareLpar.name','softwareLpar.scanTime','creationTime','softwareLpar.serial','softwareLpar.osName','assignee','id']
	}); 
};
function assignComments(type){
	
	var comments = $('#comments').val();
	var url = '${pageContext.request.contextPath}/ws/exceptions/NOCUST/';
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
		url +=  'assignAll';
		params['comments'] = comments;
		params['accountId'] = '${accountId}';
	}
	
	if(type == 0){
		//not assign all
		url += 'assign'
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
	var url = '${pageContext.request.contextPath}/ws/exceptions/NOCUST/';
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
		url +=  'unassignAll';
		params['comments'] = comments;
		params['accountId'] = '${accountId}';
	}
	
	if(type == 0){
		//not assign all
		url += 'unassign'
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

function popupBravoSl(accountId,lparName,swId) {
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


