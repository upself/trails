<script type="text/javascript">
	var loadingMsg = "<p id=\"dialogmsg\">please wait a while.</p><div id=\"progressbar\"></div>";
	
	var levelstatus;
	var swStatusFlag;
	var machineTypeFlag=true;
	var manuStatusFlag=true;		
	function schFstatus(){
		if(levelstatus=="HWBOX"){
			if(!swStatusFlag && manuStatusFlag && machineTypeFlag){
				$("#statusDescription").find('option[value="ACTIVE"]').removeAttr("disabled");
			}else{
				$("#statusDescription").find('option[value="INACTIVE"]').attr("selected",true);
				$("#statusDescription").find('option[value="ACTIVE"]').attr("disabled",	true);
			}
		}else if(levelstatus!="MANUFACTURER"){
			if(!swStatusFlag && manuStatusFlag){
				$("#statusDescription").find('option[value="ACTIVE"]').removeAttr("disabled");
			}else{
				$("#statusDescription").find('option[value="INACTIVE"]').attr("selected",true);
				$("#statusDescription").find('option[value="ACTIVE"]').attr("disabled",	true);
			}
		}else{
			if(manuStatusFlag){
				$("#statusDescription").find('option[value="ACTIVE"]').removeAttr("disabled");
			}else{
				$("#statusDescription").find('option[value="INACTIVE"]').attr("selected",true);
				$("#statusDescription").find('option[value="ACTIVE"]').attr("disabled",	true);
			}
		}
	}
	
	function isArray(obj) {
		return Object.prototype.toString.call(obj) === '[object Array]';
	}
	
	$(function() {
		
		var scheduleFId = '${scheduleFForm.scheduleFId}';
		 $("#schFhTable").hide();
		 $("#btnSubmit").attr('disabled', true);
		 $("#accountId").val('${account.id}');
		populateArraryList();
		setTimeout(function (){  
		if (scheduleFId == null || scheduleFId == ""
				|| scheduleFId == undefined) {
			$("#spinner").hide();
			$("#scopeDescription").val("IBM owned, IBM managed");
			$('#level').val("PRODUCT");
			$("#btnSubmit").attr('disabled', false);
		} else {
			feedPage(scheduleFId);
			searchData(scheduleFId);
		}

		scopeFlip();
		
		$("#scopeDescription").change(
				function() {
					var scopeVal = $('#scopeDescription option:selected')
							.text().split(",")[0];
					var scopeVal2 = $('#scopeDescription option:selected')
							.text().split(",")[1];
					var scopeInIf = scopeVal + scopeVal2;

					if (scopeVal == 'IBM owned') {
						$("#swfinanceResp").find("option[value='CUSTO']").css({
							display : "none"
						});
						$("#swfinanceResp").val("IBM");
					} else {
						$("#swfinanceResp").find("option[value='CUSTO']").css({
							display : ""
						});
					}

					if (scopeInIf != 'Customer owned Customer managed') {
						$('#swfinanceResp option[value="IBM"]').attr(
								"selected", true);
						$("#swfinanceResp").find("option[value='N/A']").css({
							display : "none"
						});
					} else {
						$("#swfinanceResp").find("option[value='N/A']").css({
							display : ""
						});
					}
					if ( $('#level').val() == 'HWOWNER' ){
						 hwowerChng();
					}
				});
		if ($('#softwareStatus').val() == true) {
			swStatusFlag=true;
		} else {
			swStatusFlag=false;
		}
		schFstatus();

		var value = $('#level').val();
		levelChange(value);
	 }, 1000); 
		
		var manufacturerJsonURI = "${pageContext.request.contextPath}/admin/manufacturer.htm";
		$("#manufacturer").autocomplete(
				{
					change : function(event, ui) {
						if (ui.item == null) {
							if ($('#manufacturer').val() != null || $('#manufacturer').val() != ''){
									manuStatusFlag=false;
								} 
								if ($('#manufacturer').val() == null || $('#manufacturer').val() == '') {
									manuStatusFlag=true;
								}
						}
						schFstatus();
					},
					source : function(request, response) {
						$.ajax({
							url : manufacturerJsonURI,
							dataType : "json",
							data : {
								q : request.term
							},
							success : function(data) {
								if (isArray(data)) {
									var result = new Array()
									for (i = 0; i < data.length; i++) {
										var obj = {
											"id" : data[i].id,
											"label" : data[i].manufacturerName,
											"value" : data[i].manufacturerName,
										};
										result.push(obj);
									}
									response(result);
								} else {
									response(data);
								}
							}
						});
					},
					minLength : 3,
					select : function(event, ui) {
						$("#manufacturerId").val(ui.item.id);
						manuStatusFlag=true;
						schFstatus();
					}
				});
	});

	function feedPage(scheduleFId) {
		var urlRequest = "${pageContext.request.contextPath}/ws/scheduleF/"
				+ scheduleFId + "";
		var accountId = '${account.id}';
		jQuery.ajax({
			url : urlRequest,
			type : "POST",
			data : {
				"accountId" : accountId
			},
			dataType : 'json',
			timeout : 180000,
			beforeSend : function() {
				$("#spinner").show();
				$("#btnSubmit").attr('disabled', true);
			},
			complete : function(XMLHttpRequest, status) {
				$("#spinner").hide();
				$("#btnSubmit").attr('disabled', false);
				if (status == 'timeout') {
					alert("Request Timeout !");
					this.abort();
				}
			},
			success : function(result) {
				if (result.status != '200') {
					alert(result.msg);
					$("#spinner").hide();
					$("#btnSubmit").attr('disabled', false);
				}
				$("#id").val(result.data.id);
				$("#softwareTitle").val(result.data.softwareTitle);
				$("#softwareName").val(result.data.softwareName);
				$("#softwareStatus").val(result.data.softwareStatus);
				$("#manufacturer").val(result.data.manufacturer);
				$("#level").val(result.data.level);
				$("#hwOwner").val(result.data.hwOwner);
				$("#serial").val(result.data.serial);
				$("#machineType").val(result.data.machineType);
				$("#hostName").val(result.data.hostName);
				$("#scopeDescription").val(result.data.scopeDescription);
				$("#sourceDescription").val(result.data.sourceDescription);
				$("#statusDescription").val(result.data.statusDescription);
				$("#swfinanceResp").val(result.data.swfinanceResp);
				$("#sourceLocation").val(result.data.sourceLocation);
				$("#businessJustification").val(
						result.data.businessJustification);
				levelChange(result.data.level);
				
				levelstatus=$("#manufacturer").val()
				swStatusFlag=$("#softwareStatus").val();
			},
			error : function(jqXHR, status, error) {
				alert(status + ":" + error);
				$("#spinner").hide();
				$("#btnSubmit").attr('disabled', true);
			}
		});
	}

	function populateArraryList() {
		jQuery.ajax({
			url : "${pageContext.request.contextPath}/ws/scheduleF/scopes",
			type : "GET",
			success : function(result) {
				outputlist("scopeDescription", result.dataList);
			},
			error : function(jqXHR, status, error) {
				alert(status + ":" + error);
				$("#spinner").hide();
				$("#btnSubmit").attr('disabled', true);
			}
		});

		jQuery.ajax({
			url : "${pageContext.request.contextPath}/ws/scheduleF/sources",
			type : "GET",
			success : function(result) {
				outputlist("sourceDescription", result.dataList);
			},
			error : function(jqXHR, status, error) {
				alert(status + ":" + error);
				$("#spinner").hide();
				$("#btnSubmit").attr('disabled', true);
			}
		});

		jQuery.ajax({
			url : "${pageContext.request.contextPath}/ws/scheduleF/status",
			type : "GET",
			success : function(result) {
				outputlist("statusDescription", result.dataList);
			},
			error : function(jqXHR, status, error) {
				alert(status + ":" + error);
				$("#spinner").hide();
				$("#btnSubmit").attr('disabled', true);
			}
		});
	}

	function outputlist(elemet, items) {
		for (var i = 0; i < items.length; i++) {
			$("#" + elemet + "").append(
					"<option id='"+items[i].id+"' value='"+items[i].description+"'>"
							+ items[i].description + "</option>");
		}
	}

	function submitForm() {
		if (validateForm()) {
			$.ajax({
				cache : true,
				type : "POST",
				url : '${pageContext.request.contextPath}/ws/scheduleF/save',
				data : $('#myScheduleFForm').serialize(),
				dataType : 'json',
				async : false,
				beforeSend : function(XMLHttpRequest) {
					$("#spinner").show();
					$("#btnSubmit").attr('disabled', true);
				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
					alert(textStatus);
				},
				success : function(data) {
					alert(data.msg);
				},
				complete : function(XMLHttpRequest, textStatu) {
					$("#spinner").hide();
					$("#btnSubmit").attr('disabled', false);
				}
			});
		}
	}

	function validateForm() {
		var softwareName = $("#softwareName").val();
		var softwareTitle = $("#softwareTitle").val();
		var manufacturer = $("#manufacturer").val();
		var sourceLocation = $("#sourceLocation").val();
		var businessJustification = $("#businessJustification").val();

		if(manufacturer.trim() == ''){
			alert('Manufacturer is required');
			return false;
		}
		
		if(sourceLocation.trim() == ''){
			alert('SourceLocation is required');
			return false;
		}
		
		if(businessJustification.trim() == ''){
			alert('businessJustification is required');
			return false;
		}
		
		return true;
	}

	function scopeFlip() {
		var scopeSelectedVal = $('#scopeDescription option:selected').text()
				.split(",")[0];
		var scopeSelectedVal2 = $('#scopeDescription option:selected').text()
				.split(",")[1];
		var scopeLoad = scopeSelectedVal + scopeSelectedVal2;

		if (scopeSelectedVal == 'IBM owned') {
			$("#swfinanceResp").find("option[value='CUSTO']").css({
				display : "none"
			});
			$("#swfinanceResp").val("IBM");
		}
		if (scopeLoad != 'Customer owned Customer managed') {
			$('#swfinanceResp option[value="N/A"]').css({
				display : "none"
			});
			$("#swfinanceResp").find("option[value='N/A']").css({
				display : "none"
			});
		}
	}

	function levelSltChng(objSelect) {
		var value = objSelect.value;
		levelChange(value);
	}

	function levelChange(value) {
		levelstatus=value;
		schFstatus();
		
		if (value == 'PRODUCT') {
			$("#swTitle").show();
			$("#swName").show();
		} 
		if (value == 'HWOWNER') {
			if ($('#hwOwner').length) {
				$("#hwownerLabel").show();
				$("#hwOwner").show();
				hwowerChng();
			} else {
				$("#levelSpan")
						.after(
								'<label id="hwownerLabel" for="hwOwner">Hwowner:</label>'
										+ '<span><select name="hwOwner" id="hwOwner" onChange="hwowerChng()"> <option value="IBM">IBM</option><option value="CUSTO">CUSTO</option> </select></span>');
			}
		} else {
			$("#hwownerLabel").hide();
			$("#hwOwner").hide();
			$("#alertLabel1").remove();
			$("#alertLabel2").remove();
		}
		if (value == 'HWBOX') {
			if ($('#serial').length && $('#machineType').length) {
				$("#serialLabel").show();
				$("#serial").show();
				$("#machineTypeLabel").show();
				$("#machineType").show();
			} else {
				$("#levelSpan")
						.after(
								'<label id="serialLabel" for="serialNumber">Serial:</label>'
										+ '<span><input name="serial" id="serial" value="" size="40"></span>'
										+ '<label id="machineTypeLabel" for="machineType">MachineType:</label>'
										+ '<span><input name="machineType" id="machineType" value="" size="40" onKeyUp="keyup(this)"></span>');
			}
		} else {
			$("#serialLabel").hide();
			$("#serial").hide();
			$("#machineTypeLabel").hide();
			$("#machineType").hide();
			$("#alertLabel1").remove();
			$("#alertLabel2").remove();
		}
		if (value == 'HOSTNAME') {
			if ($('#hostName').length) {
				$("#hostnameLabel").show();
				$("#hostName").show();
			} else {
				$("#levelSpan")
						.after(
								'<label id="hostnameLabel" for="hostName">Hostname:</label>'
										+ '<span><input name="hostName" id="hostName" value="" size="40"></span>');
			}
		} else {
			$("#hostnameLabel").hide();
			$("#hostName").hide();
			$("#alertLabel1").remove();
			$("#alertLabel2").remove();
		}
		if (value == 'MANUFACTURER') {
			$("#swTitle").hide();
			$("#swName").hide();
		} else {
			$("#swTitle").show();
			$("#swName").show();
			$("#alertLabel1").remove();
			$("#alertLabel2").remove();
		}
	}

	function hwowerChng() {
		var levelvalue = $('#level option:selected').val();
		var hwovalue = $('#hwOwner option:selected').val();
		var selectedVal = $('#scopeDescription option:selected').text().split(
				",")[0];
		$("#alertLabel1").remove();
		$("#alertLabel2").remove();
		if (levelvalue == 'HWOWNER') {
			if (hwovalue == 'IBM' && selectedVal != 'IBM owned') {

				$("#hwownerSpan")
						.after(
								'<span id="alertLabel1">Your selected HW owner is not matched to selected Scope !</span>');

			} else {
				$("#alertLabel1").remove();
			}

			if (hwovalue == 'CUSTO' && selectedVal != 'Customer owned') {

				$("#hwownerSpan")
						.after(
								'<span id="alertLabel2">Your selected HW owner is not matched to selected Scope !</span>');

			} else {
				$("#alertLabel2").remove();
			}
		}
	}

	$(document.body)
			.click(
					function(event) {
						var liveSearch = $("#jquery-live-search");
						if (liveSearch.length) {
							var clicked = $(event.target);
							if (!(clicked.is("#jquery-live-search")
									|| clicked.parents("#jquery-live-search").length || clicked
									.is(this))) {
								liveSearch.slideUp();
							}
						}
					});

	var lastValue = '';

	function keyup(type) {
		var value = $.trim(type.value);
		if (value == $.trim('') || value == '' || value == lastValue) {
			return;
		}
		lastValue = value;

		var liveSearch = $("#jquery-live-search");

		if (!liveSearch.length) {
			liveSearch = $("<div id='jquery-live-search'></div>").appendTo(
					document.body).hide().slideUp(0);
		}

		var inputPos = $(type).position();
		var inputHeight = $(type).outerHeight();

		liveSearch.css({
			"position" : "absolute",
			"top" : inputPos.top + inputHeight + "px",
			"left" : inputPos.left + "px"
		});

		if (this.timer) {
			clearTimeout(this.timer);
		}

		this.timer = setTimeout(
				function() {$.ajax({
								url : "${pageContext.request.contextPath}/admin/liveSearch.htm",
								async : true,
								type : "POST",
								data : {
									key : value,
									label : type.name
								},
								beforeSend : function() {
									liveSearch.empty();
									liveSearch.append("searching...").fadeIn(
											400);
								},
								error : function() {
									liveSearch.empty();
									liveSearch.append("error").fadeIn(400);
								},
								success : function(data, status) {
									liveSearch.empty();
									if (!data.length) {
										if (type.name == 'softwareName'){
											swStatusFlag=true;
										}else{
											machineTypeFlag=false;
										}
										
										liveSearch.append("no matched item found.")
									} else {
										if (type.name == 'softwareName'){
											swStatusFlag=false;
										}else{
											machineTypeFlag=true;
										}
										
										liveSearch.append(data);
									}
									schFstatus();
									
									liveSearch.show("slow");

									var over = {
										"color" : "white",
										"background" : "blue"
									};

									var out = {
										"color" : "black",
										"background" : "white"
									};

									$("li.prompt").hover(function() {
										$(this).css(over);
									}, function() {
										$(this).css(out);
									});

									$("li.prompt").click(function() {
														if (type.name == 'softwareName') {
															type.value = $(this).text().slice(11, -10);
															
															if ($(this).text().slice(-10, $(this).text().length) == '(INACTIVE)') {
																swStatusFlag=true;
															} else {
																swStatusFlag=false;
															}
														} else {
															type.value = $(this).text();
														}
														schFstatus();
														
														liveSearch.empty();
													});
								}
							})
				}, 1000);

	}
	
	function searchData(scheduleFId) {
		var params = {};
		params['sort'] = 'id';
		params['dir'] = 'desc';
		
		$("#schFhTable").paginationTable('destroy').paginationTable({
			remote: {
				url: "${pageContext.request.contextPath}/ws/scheduleF/history/" + scheduleFId +"",
				type: "POST",
				params: params,
				beforeSend : function(XMLHttpRequest) {
					 $("#schFhTable").show();
				},
				success: function(result, pageIndex){
					var html = '';
					var list = result.data.list;
					if(null == list || list == undefined || list.length == 0){
						html += "<tr><td colspan='16' align='center'>No data found</td></tr>"
					}else{
						for(var i = 0; i < list.length; i++){
							html += "<tr>";
							html += "<td>" + list[i].softwareName + "</td>";
							html += "<td>" + list[i].level + "</td>";
							html += "<td>" + list[i].hwOwner + "</td>";
							html += "<td>" + list[i].hostName  + "</td>";
							html += "<td>" + list[i].serial + "</td>";
							html += "<td>" + list[i].machineType + "</td>";
							html += "<td>" + list[i].softwareTitle+ "</td>";
							html += "<td>" + list[i].manufacturer + "</td>";
							html += "<td>" + list[i].scopeDescription + "</td>";
							html += "<td>" + list[i].swfinanceResp + "</td>";
							html += "<td>" + list[i].sourceDescription + "</td>";
							html += "<td>" + list[i].sourceLocation + "</td>";
							html += "<td>" + list[i].statusDescription + "</td>";
							html += "<td>" + list[i].businessJustification + "</td>";
							html += "<td>" + list[i].remoteUser + "</td>";
							html += "<td>" + list[i].recordTime + "</td>";
							html += "</tr>"; 
						}
					}
					$("#scheduleF_history_list").html(html);
				}
			},
			orderColumns: ['softwareName','level','hwOwner','hostname','serial','machineType','softwareTitle','manufacturer']
		});
	}

</script>

<div class="ibm-columns"><div class="ibm-col-1-1">
<p class="ibm-confidential">IBM Confidential</p>
		<h2>Schedule F details</h2>
		<div id="dialog"></div>
		<form id="myScheduleFForm" onsubmit="submitForm(); return false;"
			action="/" class="ibm-column-form" enctype="multipart/form-data"
			method="post">
			<div id="spinner" style="position:relative;z-index:9999;top:150px;">
				<span class="ibm-spinner-large"></span>
			</div>
			<p>
				<input name="id" id="id" value="" type="hidden" />
			</p>
			<p id="swTitle">
				<label for="softwareTitle" style="width: 30%">Software title:</label> <span><input
					name="softwareTitle" id="softwareTitle" value="" size="40" /></span>
			</p>

			<p id="swName">
				<label for="softwareName" style="width: 30%">Software name:</label><span> <input
					name="softwareName" id="softwareName" size="40"
					onKeyUp="keyup(this)" /></span> <span> <input
					name="softwareStatus" id="softwareStatus" value="" type="hidden" />
				</span> 
			</p>

			<p>
				<label for="manufacturer" style="width: 30%">Manufacturer:<span
					class="ibm-required">*</span></label> <span><input size="40"
					id="manufacturer" name="manufacturer" /></span><span
					class="ibm-error-link" id="manufacturerError" style="display: none"></span><input
					type="hidden" id="manufacturerId" />
			</p>

			<p id="levelSpan">
				<label for="level" style="width: 30%">Level:</label> <span><select name="level"
					id="level" onchange="levelSltChng(this)"> 
						<option value="MANUFACTURER">MANUFACTURER</option>
						<option value="PRODUCT">PRODUCT</option>
						<option value="HWOWNER">HWOWNER</option>
						<option value="HWBOX">HWBOX</option>
						<option value="HOSTNAME">HOSTNAME</option>
				</select></span>
				<label id="hwownerLabel" for="hwOwner" style="width: 30%">Hwowner:</label> <span id="hwownerSpan">
					<select name="hwOwner" id="hwOwner" onChange="hwowerChng()">
						<option value="IBM">IBM</option>
						<option value="CUSTO">CUSTO</option>
				</select>
				</span> <label id="serialLabel" for="serialNumber" style="width: 30%">Serial:</label> <span><input
					name="serial" id="serial" value="" size="40"></span> <label
					id="machineTypeLabel" for="machineType" style="width: 30%">MachineType:</label> <span><input
					name="machineType" id="machineType" value="" size="40"
					onKeyUp="keyup(this)"></span> <label id="hostnameLabel"
					for="hostName" style="width: 30%">Hostname:</label> <span><input
					name="hostName" id="hostName" value="" size="40"></span>
			</p>
			<p>
				<label for="scopeDescription" style="width: 30%">Scope:</label> <span><select
					name="scopeDescription" id="scopeDescription">
				</select></span>
			</p>

			<p>
				<label for="swfinanceResp" style="width: 30%">SW Financial Resp:</label> <span><select
					name="swfinanceResp" id="swfinanceResp">
						<option value="N/A">N/A</option>
						<option value="IBM">IBM</option>
						<option value="CUSTO">CUSTO</option>
				</select></span>
			</p>
				<input type="hidden" name="accountId" id="accountId"/>
			<p>
				<label for="sourceDescription" style="width: 30%">Source:</label> <span><select
					name="sourceDescription" id="sourceDescription">
				</select></span>
			</p>
			<p>
				<label for="sourceLocation" style="width: 30%">Source location:<span
					class="ibm-required">*</span></label> <span><input
					name="sourceLocation" id="sourceLocation" value="" size="40"
					type="text"> </span>
			</p>
			<p>
				<label for="statusDescription" style="width: 30%">Status:</label> <span><select
					name="statusDescription" id="statusDescription">
				</select></span>
			</p>
			<p>
				<label for="businessJustification" style="width: 30%">Business Justification:<span
					class="ibm-required">*</span></label> <span> <input type="text"
					value="" size="40" id="businessJustification"
					name="businessJustification" /></span><span class="ibm-error-link"
					id="businessJustificationError" style="display: none"></span>
			</p>
		
			<div class="ibm-buttons-row">
				<p>
					<input type="submit" class="ibm-btn-pri" name="ibm-submit"
						value="Submit" id="btnSubmit" />
				</p>
			</div>
		</form>

		<table id="schFhTable" cellspacing="0" cellpadding="0" border="0" class="ibm-data-table"
			summary="ScheduleF history table">
			<thead>
				<tr>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Software name</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Level</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Hw owner</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Hostname</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Serial</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Machine Type</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Software title</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Manufacturer</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Scope</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>SW Financial Resp</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Source</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Source location</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Status</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Business justification</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>Remote User</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="javascript:void(0)"><span>date</span><span class="ibm-icon"></span></a></th>
				</tr>
			</thead>
			<tbody id="scheduleF_history_list">
			</tbody>
		</table>
	</div>
</div>
