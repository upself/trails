<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!-- Search form -->
<div class="ibm-columns">
    <p class="ibm-confidential">IBM Confidential</p>
 	<div class="ibm-col-4-3">
    	<form onsubmit="searchData(); return false;" action="" class="ibm-column-form" enctype="multipart/form-data" method="post" id="searchForm">
			<p>
				<label style="width:30%" for="softwareName_id">
					Software component:<span class="ibm-required">*</span>
				</label> 
				<span> 
					<input name="softwareName" id="softwareName_id" size="40" value="" type="text">
				</span>
			</p>
			<p>
				<label style="width:30%" for="manufacturerName_id">
					Manufacturer:<span class="ibm-required">*</span>
				</label> 
				<span> 
					<input name="manufacturerName" id="manufacturerName_id" size="40" value="" type="text">
				</span>
			</p>
			<p>
				<label style="width:30%" for="restriction_id">
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
				<label style="width:30%" for="baseOnly_id">
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
				<label style="width:30%" for="capacityDesc_id">
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
				<label style="width:30%" for="statusId_id">
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
	<div class="ibm-col-4-1">
		<%
	boolean admin = request.isUserInRole("com.ibm.tap.admin");
	if(admin){
		%>
			<s:set name="admin" value="1" ></s:set>
			<p class="ibm-button-link">
				<a class="ibm-btn-small" href="${pageContext.request.contextPath}/admin/nonInstancebasedSW/manage.htm?type=add">Add Non Instance base SW</a> 
				<a class="ibm-btn-small" href="${pageContext.request.contextPath}/ws/noninstance/download">Export Non Instance based SW</a>
				<a class="ibm-btn-small" href="${pageContext.request.contextPath}/admin/nonInstancebasedSW/upload.htm">Import Non Instance based SW</a> 
			</p>
		<%
		} else{
			
		%>
			<s:set name="admin" value="0" ></s:set>
			<p class="ibm-button-link">
				<a class="ibm-btn-small" href="${pageContext.request.contextPath}/ws/noninstance/download">Export Non Instance based SW</a>
			</p>
		<%
		}
		%>
	</div>
	
</div>
<div class="ibm-columns">
	<!-- SORTABLE DATA TABLE -->
	<div class="ibm-col-1-1">
		<table id="page" cellspacing="0" cellpadding="0" border="0" class="ibm-data-table"
			summary="Non Instance based SW table">
			<thead>
				<tr>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Software component</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Manufacturer</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Restriction</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Non Instance based only</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Non Instance capacity type</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Status</span><span class="ibm-icon"></span></a></th>
					<th scope="col" style="min-width:180px; text-align:center" class="ibm-sort"><a href="javascript:void(0)"><span>Operation</span><span class="ibm-icon"></span></a></th>
				</tr>
			</thead>
			<tbody id="non_instance_list">
			</tbody>
		</table>
	</div>
</div>

<script>

$(function(){
	searchData();
});

function searchData(){
	$("#page").paginationTable('destroy').paginationTable({
		remote: {
			url: "${pageContext.request.contextPath}/ws/noninstance/search",
			type: "POST",
			params: $("#searchForm").serialize(),
			success: function(result, pageIndex){
				var html = '';
				var list = result.data.list;
				if(null == list || list == undefined || list.length == 0){
					html += "<tr><td colspan='7' align='center'>No data found</td></tr>"
				}else{
					for(var i = 0; i < list.length; i++){
						html += "<tr>";
						html += "<td><input type='hidden' value='" + list[i].id + "'>" + list[i].software.softwareName + "</td>";
						html += "<td>" + list[i].manufacturer.manufacturerName + "</td>";
						html += "<td>" + list[i].restriction + "</td>";
						if(list[i].baseOnly == 1){
							html += "<td>Y</td>";
						}else{
							html += "<td>N</td>";
						}
						html += "<td>" + list[i].capacityType.description +"</td>";
						html += "<td>" + list[i].status.description + "</td>";
						html += "<td style='text-align:center'>";
						<s:if test='#admin eq 1'>
							html += "<p class='ibm-button-link'>"
							html += "<a class='ibm-btn-small' href='javascript:void(0)' onclick='openLink(\"${pageContext.request.contextPath}/admin/nonInstancebasedSW/manage.htm?type=update&nonInstanceId="+list[i].id+"\")'>Update</a>";
							html += "&nbsp;&nbsp;<a class='ibm-btn-small' href='javascript:void(0)' onclick='openLink(\"${pageContext.request.contextPath}/admin/nonInstancebasedSW/history.htm?nonInstanceId="+list[i].id+"\"); return false;'>View history</a></p>"
						</s:if>
							
						<s:if test='#admin eq 0'>
							html += "<a class='ibm-btn-small' href='${pageContext.request.contextPath}/admin/nonInstancebasedSW/history.htm?nonInstanceId="+list[i].id+"'>View history</a></td>";
						</s:if>
							
						html += "</tr>";
					}
				}
				$("#non_instance_list").html(html);
			}
		},
		orderColumns: ['software.softwareName','manufacturer.manufacturerName','restriction','baseOnly','capacityType.description','status.description','id']
	}); 
};

function openLink(url){
	window.location.href = url;
}
</script>






