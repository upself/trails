<div class="ibm-columns">
    <p class="ibm-confidential">IBM Confidential</p>
	<!-- SORTABLE DATA TABLE -->
	<div class="ibm-col-1-1">
		<div style="height:180px;width: 100%; float: left">
			<div style="line-height:150px;width:30%;float: left">
				View as Level:
				<select id="selectLevel">
					<option value="all">ALL</option>
					<option value="global">GLOBAL</option>
					<option value="account">ACCOUNT</option>
				</select>
			</div>
			<div style="float: right">
				<div style="width:200px">
					<p class='ibm-button-link'>
						<a class="ibm-btn-small" href="javascript:void(0)" onclick="openLink('${pageContext.request.contextPath}/admin/priorityISV/add.htm')" id="addPriorityISV">Add Priority ISV SW</a>
					</p>
				</div>
				<div style="width:200px">
					<p class="ibm-button-link">
						<a class="ibm-btn-small" id="download" href="#">Export Priority ISV SW</a>
					</p>
				</div>
				<div style="width:200px">
					<p class="ibm-button-link">
						<a class="ibm-btn-small" href="${pageContext.request.contextPath}/admin/priorityISV/upload.htm">Import Priority ISV SW</a> 
					</p>
				</div>
			</div>	
		</div>
		<br><br>
		<table id="isvTable" cellspacing="0" cellpadding="0" border="0"
			class="ibm-data-table ibm-alternating" summary="Priority ISV list">
			<thead>
				<tr>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Manufacturer Name</span><span class="ibm-icon"></span></a></th>
					<th scope="col" id="level_th" class="ibm-sort"><a href="javascript:void(0)"><span>Level</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>CNDB Name</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>CNDB ID</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Evidence Location</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Status</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Business Justification</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Remote User</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Record Time</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Operation</span><span class="ibm-icon"></span></a></th>
				</tr>
			</thead>
			<tbody id="priority_isv_list" />
		</table>
	</div>

</div>
<script>

	Date.prototype.format = function(format) {
		var o = {
			"M+" : this.getMonth() + 1,
			"d+" : this.getDate(),
			"h+" : this.getHours(),
			"m+" : this.getMinutes(),
			"s+" : this.getSeconds(),
			"q+" : Math.floor((this.getMonth() + 3) / 3),
			"S" : this.getMilliseconds()
		}
		if (/(y+)/.test(format)) {
			format = format.replace(RegExp.$1, (this.getFullYear() + "")
					.substr(4 - RegExp.$1.length));
		}
		for ( var k in o) {
			if (new RegExp("(" + k + ")").test(format)) {
				format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k]
						: ("00" + o[k]).substr(("" + o[k]).length));
			}
		}
		return format;
	}

	$(function() {
		searchData();
	});

	$("#download").click(function() {
				var levelType = $("#selectLevel option:selected").text();
				$(this).attr("href","${pageContext.request.contextPath}/ws/priorityISV/isv/alldatafile")
			});

	$("#selectLevel").change(function() {
		var levelVal = $("#selectLevel option:selected").text();
		$("table tr").each(function(item) {
			var td_value = $(this).find("#level_td").text();
			if (item > 0) {
				if (levelVal.toLowerCase() == "all") {
					$(this).css({
						display : ""
					});
				} else {
					if (td_value.toLowerCase() == levelVal.toLowerCase()) {
						$(this).css({
							display : ""
						});
					} else {
						$(this).css({
							display : "none"
						});
					}
				}

			}
		})
	});

	function getSmpFormatDateByLong(l, isFull) {
		return getSmpFormatDate(new Date(l), isFull);
	}
	
	function getSmpFormatDate(date, isFull) {
		var pattern = "";
		if (isFull == true || isFull == undefined) {
			pattern = "yyyy-MM-dd hh:mm:ss";
		} else {
			pattern = "yyyy-MM-dd";
		}
		return getFormatDate(date, pattern);
	}

	function getFormatDate(date, pattern) {
		if (date == undefined) {
			date = new Date();
		}
		if (pattern == undefined) {
			pattern = "yyyy-MM-dd hh:mm:ss";
		}
		return date.format(pattern);
	}

	function searchData() {
		$("#isvTable").paginationTable('destroy').paginationTable({
			remote: {
				url: "${pageContext.request.contextPath}/ws/priorityISV/isv/all",
				type: "GET",
				success: function(result, pageIndex){
					var html = '';
					var list = result.data.list;
					if(null == list || list == undefined || list.length == 0){
						html += "<tr><td colspan='7' align='center'>No data found</td></tr>"
					}else{
						for(var i = 0; i < list.length; i++){
							html += "<tr>";
							html += "<td><a href='${pageContext.request.contextPath}/admin/priorityISV/update.htm?id="
									+ list[i].id
									+ "'>"
									+ list[i].manufacturerName
									+ "</a></td>";		
							html += "<td id='level_td'>" + list[i].level
									+ "</td>";
							html += "<td>" + (list[i].accountName == null ? "ALL" : list[i].accountName) + "</td>";
							html += "<td>" + (list[i].accountNumber == null ? "" : list[i].accountNumber) + "</td>"
							html += "<td>" + list[i].evidenceLocation
									+ "</td>";
							html += "<td>" + list[i].statusDesc + "</td>";
							html += "<td>" + list[i].businessJustification
									+ "</td>";
							html += "<td>" + list[i].remoteUser + "</td>";
							html += "<td>" + list[i].recordTime + "</td>";
							html += "<td style='text-align:center'>";
							html += "<p class='ibm-button-link'>";
							html += "<a class='ibm-btn-small' href='javascript:void(0)' onclick='openLink(\"${pageContext.request.contextPath}/admin/priorityISV/update.htm?id="
								+ list[i].id + "\")'>Update</a>";
							html += "<a class='ibm-btn-small' href='javascript:void(0)' onclick='openLink(\"${pageContext.request.contextPath}/admin/priorityISV/history.htm?priorityISVSoftwareId="
									+ list[i].id + "\"); return false;'>View History</a></p>";
							html += "</tr>"; 
						}
					}
					$("#priority_isv_list").html(html);
				}
			},
			orderColumns: ['manufacturerName','level','accountName','accountNumber','evidenceLocation','statusDesc','businessJustification','remoteUser','recordTime','id']
		});
	}

	function openLink(url) {
		window.location.href = url; 
	}
</script>
