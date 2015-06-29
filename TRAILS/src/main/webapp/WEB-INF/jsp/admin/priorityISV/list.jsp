<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<%@ taglib prefix="s" uri="/struts-tags"%>
<s:if test="hasErrors()">
	<s:actionerror />
	<s:fielderror />
</s:if>
<div class="ibm-columns">
	<div class="ibm-col-1-1" style="width:100%;float: right">
		<p class='ibm-button-link-alternate'>
			<a href="javascript:void(0)" onclick="openLink('${pageContext.request.contextPath}/admin/priorityISV/add.htm')" class="ibm-btn-small" id="addPriorityISV">Add</a>
		</p>
	</div>
</div>


<div class="ibm-columns">

	<!-- SORTABLE DATA TABLE -->
	<div class="ibm-col-1-1">
		<div style="width: 100%; float: left">
			<div style="width: 30%; float: left">
				View as Level:
				<select id="selectLevel">
					<option value="all">all</option>
					<option value="global">global</option>
					<option value="account">account</option>
				</select>
			</div>
			<div  style="float: right">
				<p class="ibm-button-link-alternate">
					<a class="ibm-btn-small" id="download" href="#">Download Report</a>
				</p>
			</div>
		</div>
		<br><br>
		<table id="isvTable" cellspacing="0" cellpadding="0" border="0"
			class="ibm-data-table ibm-sortable-table" summary="Priority ISV list">
			<thead>
				<tr>
					<th scope="col"><span>Manufacturer name</span><span class="ibm-icon"></span></th>
					<th id="level_th"><span>Level</span><span class="ibm-icon"></span></a></th>
					<th scope="col"><span>Account Name</span><span class="ibm-icon"></span></th>
					<th scope="col"><span>Evidence Location</span><span class="ibm-icon"></span></th>
					<th scope="col"><a href="#sort"><span>Status</span><span class="ibm-icon"></span></a></th>
					<th scope="col"><span>Business Justification</span><span class="ibm-icon"></span></th>
					<th scope="col"><span>Remote User</span><span class="ibm-icon"></span></th>
					<th scope="col"><span>Record Time</span><span class="ibm-icon"></span></th>
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
				$(this).attr("href","${pageContext.request.contextPath}/ws/priorityISV/isv/download")
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
		var url = "${pageContext.request.contextPath}/ws/priorityISV/isv/all";
		$
				.ajax({
					url : url,
					type : "GET",
					dataType : 'json',
					success : function(XMLHttpRequest, textStatus, errorThrown) {
						alert(textStatus);
					},
					error : function(data) {
						var data = {
							'status' : '200',
							'msg' : 'All Priority ISV Software Data have been returned.',
							'data' : null,
							'dataList' : [
									{
										'id' : 1,
										'level' : 'ACCOUNT',
										'customerId' : 16793,
										'accountName' : 'CEMEX U.A.EMIRATES WORKSTATIONS',
										'accountNumber' : 169628,
										'manufacturerId' : 1,
										'manufacturerName' : 'BARRON MCCANN',
										'evidenceLocation' : 'Larry Testing Record',
										'statusId' : 2,
										'statusDesc' : 'ACTIVE',
										'businessJustification' : 'Larry Testing Record',
										'remoteUser' : 'liuhaidl@cn.ibm.com',
										'recordTime' : 1435250754212
									},
									{
										'id' : 2,
										'level' : 'GLOBAL',
										'customerId' : null,
										'accountName' : null,
										'accountNumber' : null,
										'manufacturerId' : 2,
										'manufacturerName' : 'CENTENNIAL SOFTWARE',
										'evidenceLocation' : 'Larry Testing Record 2',
										'statusId' : 2,
										'statusDesc' : 'ACTIVE',
										'businessJustification' : 'Larry Testing Record 2',
										'remoteUser' : 'liuhaidl@cn.ibm.com',
										'recordTime' : 1435264627248
									},
									{
										'id' : 3,
										'level' : 'ACCOUNT',
										'customerId' : 17601,
										'accountName' : 'STATE STREET - CUST OWNED - SERVER',
										'accountNumber' : 173709,
										'manufacturerId' : 3,
										'manufacturerName' : 'COMPTEL',
										'evidenceLocation' : 'Larry Testing Record 3',
										'statusId' : 2,
										'statusDesc' : 'ACTIVE',
										'businessJustification' : 'Larry Testing Record 3',
										'remoteUser' : 'liuhaidl@cn.ibm.com',
										'recordTime' : 1435264627641
									},
									{
										'id' : 4,
										'level' : 'GLOBAL',
										'customerId' : null,
										'accountName' : null,
										'accountNumber' : null,
										'manufacturerId' : 4,
										'manufacturerName' : 'SECURIT',
										'evidenceLocation' : 'Larry Testing Record 4',
										'statusId' : 2,
										'statusDesc' : 'ACTIVE',
										'businessJustification' : 'Larry Testing Record 5',
										'remoteUser' : 'liuhaidl@cn.ibm.com',
										'recordTime' : 1435264627890
									},
									{
										'id' : 5,
										'level' : 'ACCOUNT',
										'customerId' : 7508,
										'accountName' : 'DIAGEO UAE---AEDIAGEO---DIST',
										'accountNumber' : 85190,
										'manufacturerId' : 5,
										'manufacturerName' : 'BEYONDTRUST',
										'evidenceLocation' : 'Larry Testing Record 5',
										'statusId' : 2,
										'statusDesc' : 'ACTIVE',
										'businessJustification' : 'Larry Testing Record 5',
										'remoteUser' : 'liuhaidl@cn.ibm.com',
										'recordTime' : 1435264628165
									} ]
						};
						var html = '';
						if (data.status == 400) {
							html += "<tr><td colspan='7'>" + data.msg
									+ "</td></tr>"
						} else {
							var list = data.dataList;
							for (var i = 0; i < list.length; i++) {
								html += "<tr>";
								html += "<td><a href='${pageContext.request.contextPath}/admin/priorityISV/update.htm?id="
										+ list[i].id
										+ "'>"
										+ list[i].manufacturerName
										+ "</a></td>";
								html += "<td id='level_td'>" + list[i].level
										+ "</td>";
								html += "<td>" + list[i].accountName + "</td>";
								html += "<td>" + list[i].evidenceLocation
										+ "</td>";
								html += "<td>" + list[i].statusDesc + "</td>";
								html += "<td>" + list[i].businessJustification
										+ "</td>";
								html += "<td>" + list[i].remoteUser + "</td>";
								html += "<td>" + getSmpFormatDateByLong(list[i].recordTime,false)
										+ "</td>";
								html += "<td style='text-align:center'>";
								html += "<p class='ibm-button-link-alternate'>"
								//html += "<a class='ibm-btn-small' href='javascript:void(0)' onclick='openLink(\"${pageContext.request.contextPath}/admin/priorityISV/update.htm?id="
									//	+ list[i].id + "\")'>Update</a>";
								html += "<a class='ibm-btn-small' href='javascript:void(0)' onclick='openLink(\"${pageContext.request.contextPath}/admin/priorityISV/history.htm?isvid="
										+ list[i].id + "\"); return false;'>View history</a></p>"
								html += "</tr>";
							}
						}
						$("#priority_isv_list").html(html);
					}
				});
	}

	function openLink(url) {
		window.location.href = url;
	}
</script>






