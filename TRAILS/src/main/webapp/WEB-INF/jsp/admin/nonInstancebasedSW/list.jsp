<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!-- Search form -->
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<form onsubmit="searchData(); return false;" action="" class="ibm-column-form" enctype="multipart/form-data" method="post">
			<p>
				<label for="softwareName_id">
					Software component:<span class="ibm-required">*</span>
				</label> 
				<span> 
					<input name="softwareName" id="softwareName_id" size="40" value="" type="text">
				</span>
			</p>
			<p>
				<label for="manufacturerName_id">
					Manufacturer:<span class="ibm-required">*</span>
				</label> 
				<span> 
					<input name="manufacturerName" id="manufacturerName_id" size="40" value="" type="text">
				</span>
			</p>
			<p>
				<label for="restriction_id">
					Restriction:<span class="ibm-required">*</span>
				</label> 
				<span>
					<select name="restriction" id="restriction_id">
						<option value="">Please select one</option>
						<option value="Account">Account</option>
						<option value="Machine">Machine</option>
						<option value="LPAR">LPAR</option>
					</select> 
				</span>
			</p>
			<p>
				<label for="baseOnly_id">
					Non Instance based only :<span class="ibm-required">*</span>
				</label> 
				<span> 
					<select name="baseOnly" id="baseOnly_id">
						<option value="" selected="selected">Please select one</option>
						<option value="1">Y</option>
						<option value="0">N</option>
					</select> 
				</span>

			</p>
			<p>
				<label for="capacityDesc_id">
					Non Instance capacity type:<span class="ibm-required">*</span>
				</label> 
				<span>
					<select name="capacityCode" id="capacityCode_id" style="max-width:270px;">
						<option value="" selected="selected">Please select one</option>
						<s:iterator value="#request.capacityTypeList" id="capacityType">
							<option value="<s:property value='#capacityType.code'/>" ><s:property value='#capacityType.description'/></option>
						</s:iterator>
					</select>  
					
				</span>
			</p>
			<p>
				<label for="statusId_id">
					Status:<span class="ibm-required">*</span>
				</label>
				<span> 
					<select class="iform" name="statusId" id="statusId_id">
						<option value="" selected="selected">Please select one</option>
						<option value="2">ACTIVE</option>
						<option value="1">INACTIVE</option>
					</select> 
				</span>
			</p>
			
			<div class="ibm-rule">
				<hr />
			</div>
			<div class="ibm-columns">
				<div class="ibm-col-6-3">
					<p>
						<input value="Search" name="ibm-submit" class="ibm-btn-pri" type="submit">
					</p>
				</div>
			</div>
		</form>
		<!-- FORM_END -->
	</div>
	
	<!-- SORTABLE DATA TABLE -->
	<div class="ibm-col-1-1">
		<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table"
			summary="Sortable Non Instance based SW table">
			<thead>
				<tr>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Software component</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Manufacturer</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Restriction</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Non Instance based only</span><span
							class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Non Instance capacity type</span><span class="ibm-icon"></span></a>
					</th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Status</span><span class="ibm-icon"></span></a></th>
					<th scope="col">Operation</th>
				</tr>
			</thead>
			<tbody id="non_instance_list">
				
			</tbody>
		</table>
	</div>
</div>

<%
	boolean admin = request.isUserInRole("com.ibm.tap.admin");
	if(admin){
%>
	<s:set name="admin" value="1" ></s:set>
<%
	} else{
%>
	<s:set name="admin" value="0" ></s:set>
<%
	}
%>

<script>

$(function(){
	searchData();
});

function searchData(){
	var softwareName = $("#softwareName_id").val();
	var manufacturerName = $("#manufacturerName_id").val();
	var restriction = $("#restriction_id").val();
	var baseOnly = $("#baseOnly_id").val();
	var capacityCode = $("#capacityCode_id").val();
	var statusId = $("#statusId_id").val();


	var searchParam = "?";
	searchParam += "softwareName=" + softwareName;
	searchParam += "&manufacturerName=" + manufacturerName;
	searchParam += "&restriction=" + restriction;
	if(baseOnly != ''){
		searchParam += "&baseOnly=" + baseOnly;
	}
	if(capacityCode != ''){
		searchParam += "&capacityCode=" + capacityCode;
	}
	
	if(statusId != ''){
		searchParam += "&statusId=" + statusId;
	}

	var url =  "${pageContext.request.contextPath}/ws/noninstance/search" + searchParam;

	$.ajax({
		url: url,
		type: "GET",
		dataType:'json',
		error: function(XMLHttpRequest, textStatus, errorThrown) {
	            alert(textStatus);
	    },
		success:function(data){
			var html = '';
			if(data.status != 200){
				html += "<tr><td colspan='7'>"+data.msg+"</td></tr>"
			}else{
				var list = data.dataList;
				for(var i = 0; i < list.length; i++){
					html += "<tr>";
					html += "<td><input type='hidden' value='" + list[i].id + "'>" + list[i].softwareName + "</td>";
					html += "<td>" + list[i].manufacturerName + "</td>";
					html += "<td>" + list[i].restriction + "</td>";
					if(list[i].baseOnly == 1){
						html += "<td>Y</td>";
					}else{
						html += "<td>N</td>";
					}
					html += "<td>" + list[i].capacityDesc +"</td>";
					html += "<td>" + list[i].statusDesc + "</td>";
					html += "<td>";
					<s:if test='#admin eq 1'>
						html += "<p class='ibm-button-link-alternate'>"
						html += "<a href='javascript:void(0)' onclick='openLink(\"${pageContext.request.contextPath}/admin/nonInstancebasedSW/manage.htm?type=update&nonInstanceId="+list[i].id+"\")'>Update</a>";
						html += "<a href='javascript:void(0)' onclick='openLink(\"${pageContext.request.contextPath}/admin/nonInstancebasedSW/history.htm?nonInstanceId="+list[i].id+"\"); return false;'>View history</a></p>"
						/* html += "<a href='${pageContext.request.contextPath}/admin/nonInstancebasedSW/manage.htm?type=update&nonInstanceId="+list[i].id+"'>Update</a>&nbsp;|&nbsp;";
						html += "<a href='${pageContext.request.contextPath}/admin/nonInstancebasedSW/history.htm?nonInstanceId="+list[i].id+"'>View history</a></td>"; */
					</s:if>
					
					<s:if test='#admin eq 0'>
						html += "<a href='${pageContext.request.contextPath}/admin/nonInstancebasedSW/history.htm?nonInstanceId="+list[i].id+"'>View history</a></td>";
					</s:if>
					
					html += "</tr>";
				}
			}
			$("#non_instance_list").html(html);
		}
	}); 
};

function openLink(url){
	window.location.href = url;
}
</script>






