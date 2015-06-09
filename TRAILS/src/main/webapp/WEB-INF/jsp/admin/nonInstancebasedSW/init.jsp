<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<!-- Search form -->
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<form onsubmit="searchData(); return false;" action="" class="ibm-column-form" enctype="multipart/form-data" method="post">
			<p>
				<label for="softwareName_id">
					Software title:<span class="ibm-required">*</span>
					<span class="ibm-item-note">(e.g., KANA IQ)</span>
				</label> 
				<span> 
					<input name="softwareName" id="softwareName_id" size="40" value="" type="text">
				</span>
			</p>
			<p>
				<label for="manufacturerName_id">
					Manufacturer:<span class="ibm-required">*</span>
					<span class="ibm-item-note">(e.g., KANA)</span>
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
						<option value="account">account</option>
						<option value="machine">machine</option>
						<option value="LPAR">LPAR</option>
					</select> 
				</span>
			</p>
			<p>
				<label for="baseOnly_id">
					Non Instance based only :<span class="ibm-required">*</span>
				</label> 
				<span> 
					<select class="iform" name="baseOnly" id="baseOnly_id">
						<option value="" selected="selected">Please select one</option>
						<option value="1">Y</option>
						<option value="0">N</option>
					</select> 
				</span>

			</p>
			<p>
				<label for="capacityDesc_id">
					Capacity type:<span class="ibm-required">*</span>
					<span class="ibm-item-note">(e.g., USERS)</span>
				</label> 
				<span> 
					<input name="capacityDesc" id="capacityDesc_id" size="40" value="" type="text">
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
</div>

<!-- SORTABLE DATA TABLE -->
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table"
			summary="Sortable Non Instance based SW table">
			<thead>
				<tr>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Software title</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Manufacturer</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Restriction</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Non Instance based only</span><span
							class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Capacity type </span><span class="ibm-icon"></span></a>
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
<script>

$(function(){
	searchData();
});

function searchData(){
	var softwareName = $("#softwareName_id").val();
	var manufacturerName = $("#manufacturerName_id").val();
	var restriction = $("#restriction_id").val();
	var baseOnly = $("#baseOnly_id").val();
	var capacityDesc = $("#capacityDesc_id").val();
	var statusId = $("#statusId_id").val();


	var searchParam = "?";
	searchParam += "softwareName=" + softwareName;
	searchParam += "&manufacturerName=" + manufacturerName;
	searchParam += "&restriction=" + restriction;
	if(baseOnly != ''){
		searchParam += "&baseOnly=" + baseOnly;
	}
	searchParam += "&capacityDesc=" + capacityDesc;
	if(statusId != ''){
		searchParam += "&statusId=" + statusId;
	}

	var url =  "${pageContext.request.contextPath}/ws/noninstance/search" + searchParam;

	$.ajax({
		url: url,
		type: "GET",
		dataType:'json',
		success:function(data){
			var html = '';
			if(null != data){
				for(var i = 0; i < data.length; i++){
					html += "<tr>";
					html += "<td><input type='hidden' value='" + data[i].id + "'>" + data[i].softwareName + "</td>";
					html += "<td>" + data[i].manufacturerName + "</td>";
					html += "<td>" + data[i].restriction + "</td>";
					if(data[i].baseOnly == 1){
						html += "<td>Y</td>";
					}else{
						html += "<td>N</td>";
					}
					html += "<td>" + data[i].capacityDesc +"</td>";
					html += "<td>" + data[i].statusDesc + "</td>";
					html += "<td>";
					html += "<a href='${pageContext.request.contextPath}/admin/nonInstancebasedSW/addOrUpdate.htm?id="+data[i].id+"'>Update</a>&nbsp;|&nbsp;";
					html += "<a href='${pageContext.request.contextPath}/admin/nonInstancebasedSW/history.htm?nonInstanceId="+data[i].id+"'>View history</a></td>";
					html += "</tr>";
				}
			}
			$("#non_instance_list").html(html);
		}
	}); 
};
</script>






