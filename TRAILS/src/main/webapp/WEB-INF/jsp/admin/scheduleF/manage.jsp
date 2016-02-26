<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/js/jquery.liveSearch.css" />
<script src="${pageContext.request.contextPath}/js/jquery.js"
	type="text/javascript"></script>
<script type="text/javascript">
    $( document ).ready(function() {
    	var flag='${scheduleFId}';
    	if(flag=='') {
    		$('#scopeArrayList option[value="3"]').attr("selected",true);
    		$('#swFinanceArrayList option[value="IBM"]').attr("selected",true);
    	}

    	//AB added begin
    	var scopeSelectedVal = $('#scopeArrayList option:selected').text().split(",")[0];
    	var scopeSelectedVal2 = $('#scopeArrayList option:selected').text().split(",")[1];
    	var scopeLoad=scopeSelectedVal+scopeSelectedVal2;

    	if(scopeSelectedVal== 'IBM owned'){
    		$("#swFinanceArrayList").find("option[value='CUSTO']").css({display:"none"});
    		$('#swFinanceArrayList option[value="IBM"]').attr("selected",true);
    	};
    	
    	if(scopeLoad!='Customer owned Customer managed'){
    		$('#swFinanceArrayList option[value="N/A"]').css({display:"none"});
    		$("#swFinanceArrayList").find("option[value='N/A']").css({display:"none"});
    	};
    	
    	$("#scopeArrayList").change(function(){
    		var scopeVal = $('#scopeArrayList option:selected').text().split(",")[0];
    		var scopeVal2 = $('#scopeArrayList option:selected').text().split(",")[1];
    		var scopeInIf = scopeVal+scopeVal2;
    		
        	if(scopeVal== 'IBM owned'){
        		$("#swFinanceArrayList").find("option[value='CUSTO']").css({display:"none"});
        		$('#swFinanceArrayList option[value="IBM"]').attr("selected",true);
        	}  else{
        		$("#swFinanceArrayList").find("option[value='CUSTO']").css({display:""});
        	}  		
    		
        	if(scopeInIf!='Customer owned Customer managed'){
        		$('#swFinanceArrayList option[value="IBM"]').attr("selected",true);
        		$("#swFinanceArrayList").find("option[value='N/A']").css({display:"none"});
        	}else{
        		$("#swFinanceArrayList").find("option[value='N/A']").css({display:""});
        	}  	
    	});
    	//AB added end
    	
    	if ($('#softwareStatus').val() == 'true'){ 		
    		$('select[id="statusArrayList"]').find('option[value="2"]').attr("disabled","disabled");
		} else {
			$('select[id="statusArrayList"]').find('option[value="2"]').removeAttr("disabled");
		}
    	
    	var value = $('#levelArrayList').val();
    	levelChange(value);
		
	});
    
	function levelSltChng(objSelect) {
		var value = objSelect.value;
		levelChange(value);
	}
	
    function levelChange(value){
//     	alert($('#hwowerid').length);
    	if (value == 'HWOWNER') {
			if ($('#p_hwowner').length){
				$("#p_hwowner").show();
			} else {
				var hwOwnerHtml = '<p id="p_hwowner"><label style="width:30%" for="hwOwner"> Hwowner:<span class="ibm-required">*</span></label>';
					hwOwnerHtml += '<span><select name="hwOwner" id="hwOwner">';
					hwOwnerHtml += '<option value="IBM" <s:if test="#request.scheduleF.hwOwner eq 'IBM'">selected="selected"</s:if> >IBM</option>';
					hwOwnerHtml += '<option value="CUSTO" <s:if test="#request.scheduleF.hwOwner eq eq 'CUSTO'">selected="selected"</s:if> >CUSTO</option>';
					hwOwnerHtml += '</span></p>'
				$("#levelSpan")
				.after(hwOwnerHtml);
			}
		} else {
			$("#p_hwowner").hide();
		}
		if (value == 'HWBOX') {
			if ($('#serial').length && $('#machineType').length) {
				$("#p_serial").show();
				$("#p_machineType").show();
			} else {
				var serialHtml = '<p id="p_serial"><label style="width:30%" for="serial"> Serial:<span class="ibm-required">*</span></label>';
					serialHtml += '<span><input name="serial" id="serial" value="<s:property value='#request.scheduleF.serial'/>"';
					serialHtml += 'size="40" type="text" onKeyUp="keyup(this)"></span></p>'
				var machineTypeHtml = '<p id="p_machineType"><label style="width:30%" for="machineType"> Machine Type:<span class="ibm-required">';
					machineTypeHtml += '*</span></label><span><input name="machineType" id="machineType"  value="<s:property value='#request.scheduleF.machineType'/>"';
					machineTypeHtml += 'size="40" type="text" onKeyUp="keyup(this)"></span></p>'

				$("#levelSpan")
				.after(serialHtml+machineTypeHtml);
			}
		} else {
			$("#p_serial").hide();
			$("#p_machineType").hide();
		}
		if (value == 'HOSTNAME') {
			if ($('#hostname').length) {
			$("#p_hostName").show();
			} else {
				var hostNameHtml = '<p id="p_hostName"><label style="width:30%" for="hostName"> Hostname:<span class="ibm-required">*</span></label>';
					hostNameHtml += '<span><input name="hostName" id="hostName" value="<s:property value='#request.scheduleF.hostName'/>"';
					hostNameHtml += ' size="40" type="text" onKeyUp="keyup(this)"></span></p>'
				$("#levelSpan")
				.after(hostNameHtml);
			}
		} else {
			$("#p_hostName").hide();
		}
    }
    
	function hwowerChng() {
		var levelvalue = $('#levelArrayList option:selected').val();
		var hwovalue = $('#hwowerid option:selected').val();
		var selectedVal = $('#scopeArrayList option:selected').text().split(",")[0];
		$("#alertLabel1").remove();
		$("div.alert1").empty();
		$("#alertLabel2").remove();
		$("div.alert2").empty();
	  if (levelvalue == 'HWOWNER') {
		if (hwovalue == 'IBM' &&  selectedVal != 'IBM owned' ) {
		
			$("#level")
			  .after('<div id="alert1" class="float-left" " style="width:30%;color:RED;"><label id="alertLabel1">Your selected HW owner is not matched to selected Scope !</label></div>');		

		  } else {
			$("#alertLabel1").remove();
			$("div.alert1").empty();
		}
		
		if (hwovalue == 'CUSTO' &&   selectedVal != 'Customer owned' ) {
		    
			$("#level")
			  .after('<div id="alert2" class="float-left" " style="width:30%;color:RED;"><label id="alertLabel2">Your selected HW owner is not matched to selected Scope !</label></div>');		
	
		 } else {
			$("#alertLabel2").remove();
			$("div.alert2").empty();
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
				function() {

					$
							.ajax({
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
										liveSearch
												.append("no matched item found.")
									} else {
										liveSearch.append(data);
									}
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
										if(type.name == 'scheduleFForm.softwareName') {
										type.value = $(this).text().slice(11,-10);
										if( $(this).text().slice(-10,$(this).text().length) == '(INACTIVE)'){
											$('select[id="statusArrayList"]').find('option[value="1"]').attr("selected",true);
											$('select[id="statusArrayList"]').find('option[value="2"]').attr("disabled","disabled");
										} else {
											$('select[id="statusArrayList"]').find('option[value="2"]').removeAttr("disabled");
										}
										} else {
											type.value = $(this).text();
										}
									});
								}
							})
				}, 1000);

	}
	
</script>
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<form id="myForm" onsubmit="submitForm(); return false;" action="/" class="ibm-column-form" enctype="multipart/form-data" method="post">
<%-- 			<s:if test="#request.nonInstanceDisplay != null"> --%>
<%-- 				<input name="id" value="<s:property value='#request.nonInstanceDisplay.id'/>" type="hidden" /> --%>
<%-- 			</s:if> --%>
			<p>
				<label style="width:30%" for="softwareTitle">Software title:
					<span class="ibm-required">*</span> 
				</label> 
				<span>
					<input name="softwareTitle" id="softwareTitle" value="<s:property value='#request.scheduleF.softwareTitle'/>" size="40" type="text" onKeyUp="keyup(this)">
				</span>
			</p>
			<p>
				<label style="width:30%" for="softwareName"> Software name:
					<span class="ibm-required">*</span> 
				</label> 
				<span> 
					<input name="softwareName" id="softwareName" value="<s:property value='#request.scheduleF.softwareName'/>" size="40" type="text" onKeyUp="keyup(this)">
				</span>
			</p>
			
			<p>
				<label style="width:30%" for="manufacturer"> Manufacturer:
					<span class="ibm-required">*</span>
				</label> 
				<span> 
					<input name="manufacturer" id="manufacturer" value="<s:property value='#request.scheduleF.manufacturer'/>" size="40" type="text" onKeyUp="keyup(this)">
				</span>
			</p>
			
			<p>
				<label style="width:30%" for="level"> Level:
					<span class="ibm-required">*</span>
				</label> 
				<span> 
					<select name="level" id="level" onchange="levelSltChng(this)">
						<option value="PRODUCT" <s:if test="#request.scheduleF.level eq 'PRODUCT'">selected="selected"</s:if> >PRODUCT</option>
						<option value="HWOWNER" <s:if test="#request.scheduleF.level eq eq 'HWOWNER'">selected="selected"</s:if> >HWOWNER</option>
						<option value="HWBOX" <s:if test="#request.scheduleF.level eq eq 'HWBOX'">selected="selected"</s:if>>HWBOX</option>
						<option value="HOSTNAME" <s:if test="##request.scheduleF.level eq eq 'HOSTNAME'">selected="selected"</s:if>>HOSTNAME</option>
					</select>
				</span>
			</p>
			
			<p id="levelSpan"></p>
			<p id="p_hwowner">
				<label style="width:30%" for="hwOwner"> Hwowner:
					<span class="ibm-required">*</span>
				</label> 
				<span size="40"> 
					<select name="hwOwner" id="hwOwner">
						<option value="IBM" <s:if test="#request.scheduleF.hwOwner eq 'IBM'">selected="selected"</s:if> >IBM</option>
						<option value="CUSTO" <s:if test="#request.scheduleF.hwOwner eq eq 'CUSTO'">selected="selected"</s:if> >CUSTO</option>
					</select>
				</span>
			</p>

			<p id="p_serial">
				<label style="width:30%" for="serial"> Serial:
					<span class="ibm-required">*</span>
				</label> 
				<span> 
					<input name="serial" id="serial" value="<s:property value='#request.scheduleF.serial'/>" size="40" type="text" onKeyUp="keyup(this)">
				</span>
			</p>

			<p id="p_machineType">
				<label style="width:30%" for="machineType"> Machine Type:
					<span class="ibm-required">*</span>
				</label> 
				<span> 
					<input name="machineType" id="machineType" value="<s:property value='#request.scheduleF.machineType'/>" size="40" type="text" onKeyUp="keyup(this)">
				</span>
			</p>
			
			<p id="p_hostName">
				<label style="width:30%" for="hostName"> Hostname:
					<span class="ibm-required">*</span>
				</label> 
				<span> 
					<input name="hostName" id="hostName" value="<s:property value='#request.scheduleF.hostName'/>" size="40" type="text" onKeyUp="keyup(this)">
				</span>
			</p>

			<p>
				<label style="width:30%" for="scope"> Scope:
					<span class="ibm-required">*</span>
				</label> 
				<span> 
					<select name="scope" id="scope">
<!-- 						to-do scopeArrayList and read it's values here -->
<!-- 						<option value="IBM" <s:if test="#request.scheduleF.scope eq 'IBM'">selected="selected"</s:if> >IBM</option> -->
<!-- 						<option value="CUSTO" <s:if test="#request.scheduleF.hwOwner eq eq 'CUSTO'">selected="selected"</s:if> >CUSTO</option> -->
					</select>
				</span>
			</p>
			
			<p>
				<label style="width:30%" for="swFinanResp"> SW Financial Resp:
					<span class="ibm-required">*</span>
				</label> 
				<span> 
					<select name="swFinanceArrayList" id="swFinanceArrayList"<!-- onchange="levelSltChng(this) "-->>
<!-- 						<option value="N/A" <s:if test="#request.scheduleF.level eq 'N/A'">selected="selected"</s:if> >N/A</option> -->
<!-- 						<option value="IBM" <s:if test="#request.scheduleF.level eq eq 'IBM'">selected="selected"</s:if> >IBM</option> -->
<!-- 						<option value="CUSTO" <s:if test="#request.scheduleF.level eq eq 'CUSTO'">selected="selected"</s:if> >CUSTO</option> -->
					</select>
				</span>
			</p>

			<p>
				<label style="width:30%" for="complianceReporting"> Compliance reporting:
					<span class="ibm-required">*</span>
				</label> 
				<span> 
<!-- 					no example for text only display, all other elements are textfield, so the next line is nonsense -->
					<text name="complianceReporting" id="complianceReporting" value="<s:property value='#account.softwareComplianceManagement'/>" size="40" type="text" onKeyUp="keyup(this)">
				</span>
			</p>

			<p>
				<label style="width:30%" for="source"> Source:
					<span class="ibm-required">*</span>
				</label> 
				<span> 
					<select name="source" id="source">
<!-- 						to-do sourceArrayList and read it's values here -->
<!-- 						<option value="IBM" <s:if test="#request.scheduleF.x eq 'IBM'">selected="selected"</s:if> >IBM</option> -->
<!-- 						<option value="CUSTO" <s:if test="#request.scheduleF.x eq eq 'CUSTO'">selected="selected"</s:if> >CUSTO</option> -->
					</select>
				</span>
			</p>
			
			<p>
				<label style="width:30%" for="sourceLocation"> Source location:
					<span class="ibm-required">*</span>
				</label> 
				<span> 
					<input name="sourceLocation" id="sourceLocation" value="<s:property value='#request.scheduleF.x'/>" size="40" type="text" onKeyUp="keyup(this)">
				</span>
			</p>

			<p>
				<label style="width:30%" for="status"> Status:
					<span class="ibm-required">*</span>
				</label> 
				<span> 
					<select name="status" id="status">
<!-- 						in the old code, there is statusArrayList, so I suppose these active/inactive values are not set? and shall be loaded instead -->
						<option value="ACTIVE" <s:if test="#request.scheduleF.level eq 'N/A'">selected="selected"</s:if> >ACTIVE</option>
						<option value="INACTIVE" <s:if test="#request.scheduleF.level eq eq 'INACTIVE'">selected="selected"</s:if> >INACTIVE</option>
					</select>
				</span>
			</p>

			<p>
				<label style="width:30%" for="businessJustification"> Business justification:
					<span class="ibm-required">*</span>
				</label> 
				<span> 
					<input name="businessJustification" id="businessJustification" value="<s:property value='#request.scheduleF.x'/>" size="40" type="text" onKeyUp="keyup(this)">
				</span>
			</p>		

			<span class="ibm-spinner-large" id="loading" style="display:none"></span>
			<div class="ibm-rule">
				<hr />
			</div>
			<div class="ibm-columns">
				<div class="ibm-col-6-3">
					<p>
						<input value="Save" name="ibm-submit" class="ibm-btn-pri" type="submit">
					</p>
				</div>
			</div>
		</form>
		<!-- FORM_END -->
	</div>
</div>
<script>
function submitForm(){
	if(validateForm()){
		$.ajax({
	        cache: true,
	        type: "POST",
// 	        url: '${pageContext.request.contextPath}/ws/noninstance/saveOrUpdate',
	        data: $('#myForm').serialize(),
	        dataType:'json',
	        async: false,
	        beforeSend: function (XMLHttpRequest) {
            	$("#loading").show();
            },
	        error: function(XMLHttpRequest, textStatus, errorThrown) {
	            alert(textStatus);
	        },
	        success: function(data) {
	            alert(data.msg);
	        },
	        complete: function (XMLHttpRequest, textStatu) {
            	$("#loading").hide();
            }
	    });
	} 
}

function validateForm(){
	var softwareName = $("#softwareName_id").val();
	var manufacturerName = $("#manufacturerName_id").val();
	var restriction = $("#restriction_id").val();
	var baseOnly = $("#baseOnly_id").val();
	var capacityCode = $("#capacityCode_id").val();
	var statusId = $("#statusId_id").val();

	if(softwareName.trim() == ''){
		alert('Software component is required');
		return false;
	}
	
	if(manufacturerName.trim() == ''){
		alert('Manufacturer is required');
		return false;
	}
	
	if(restriction.trim() == ''){
		alert('Restriction is required');
		return false;
	}
	
	if(baseOnly.trim() == ''){
		alert('Non Instance based only is required');
		return false;
	}
	
	if(capacityCode.trim() == ''){
		alert('Non Instance capacity type is required');
		return false;
	}
	
	if(statusId.trim() == ''){
		alert('Status is required');
		return false;
	}
	
	return true;
}

</script>
