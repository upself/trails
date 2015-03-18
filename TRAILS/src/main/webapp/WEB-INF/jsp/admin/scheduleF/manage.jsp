<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/js/jquery.liveSearch.css" />
<script src="${pageContext.request.contextPath}/js/jquery.js"
	type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/jquery.liveSearch.js"
	type="text/javascript"></script>
<script type="text/javascript">
    $( document ).ready(function() {
    	
    	//AB added begin
    	var scopeSelectedVal = $('#scopeArrayList option:selected').text().split(",")[0];
    	if(scopeSelectedVal== 'IBM owned'){
    		$("#swFinanceArrayList").find("option[value='CUSTO']").css({display:"none"});
    		$('#swFinanceArrayList option[value="IBM"]').attr("selected",true);
    	};
    	
    	$("#scopeArrayList").change(function(){
        	var scopeVal = $('#scopeArrayList option:selected').text().split(",")[0];
        	if(scopeVal== 'IBM owned'){
        		$("#swFinanceArrayList").find("option[value='CUSTO']").css({display:"none"});
        		$('#swFinanceArrayList option[value="IBM"]').attr("selected",true);
        	}  else{
        		$("#swFinanceArrayList").find("option[value='CUSTO']").css({display:""});
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
    	if (value == 'HWOWNER') {
			if ($('#hwowerid').length){
			$("div.hwownerLb").show();
			$("#hwownerLabel").show();
			$("div.hwownerva").show();
			$("#hwowerid").show();
			} else {
				$("#levelSpan")
				.after(
						  '<div id="hwownerLb" class="float-left" style="width:30%;"><label id="hwownerLabel" for="hwowerid">Hwowner:</label></div>'
						+ '<div id="hwownerva" class="float-left" style="width:70%;"><select name="scheduleFForm.hwowner" id="hwowerid"  onChange="hwowerChng()"><option value="IBM" selected="selected">IBM</option><option value="CUSTO">CUSTO</option></select></div>');
			}
		} else {
			$("div.hwownerLb").hide();
			$("#hwownerLabel").hide();
			$("div.hwownerva").hide();
			$("#hwowerid").hide();
			$("#alertLabel1").remove();
			$("div.alert1").empty();
			$("#alertLabel2").remove();
			$("div.alert2").empty();
		}
		if (value == 'HWBOX') {
			if ($('#serial').length && $('#machineType').length) {
			$("#serialLabel").show();
			$("#serial").show();
			$("#machineTypeLabel").show();
			$("#machineType").show();
			$("div.serialLb").show();
			$("div.serialva").show();
			$("div.machinetLb").show();
			$("div.machietva").show();
			} else {
				$("#levelSpan")
				.after(
						  '<div id="serialLb" class="float-left" style="width:30%;"><label id="serialLabel" for="serialNumber">Serial:</label></div>'
						+ '<div id="serialva" class="float-left" style="width:70%;"><input type="text" name="scheduleFForm.serial" value="" id="serial"/></div>'
						+ '<div id="machinetLb" class="float-left" style="width:30%;"><label id="machineTypeLabel" for="machineType">MachineType:</label></div>'
						+ '<div id="machietva" class="float-left" style="width:70%;"><input type="text" name="scheduleFForm.machineType" value="" id="machineType" onKeyUp="keyup(this)"/></div>');
			}
		} else {
			$("#serialLabel").hide();
			$("#serial").hide();
			$("#machineTypeLabel").hide();
			$("#machineType").hide();
			$("div.serialLb").hide();
			$("div.serialva").hide();
			$("div.machinetLb").hide();
			$("div.machietva").hide();
			$("#alertLabel1").remove();
			$("div.alert1").empty();
			$("#alertLabel2").remove();
			$("div.alert2").empty();
		}
		if (value == 'HOSTNAME') {
			if ($('#hostname').length) {
			$("#hostnameLabel").show();
			$("#hostname").show();
			$("div.hwownerLb").show();
			$("div.hwownerva").show();
			} else {
				$("#levelSpan")
				.after(  '<div id="hostnameLb" class="float-left" style="width:30%;"><label id="hostnameLabel" for="hostname">Hostname:</label></div>'
						+ '<div id="hostnameva" class="float-left" style="width:70%;"><input type="text" name="scheduleFForm.hostname" value="" id="hostname"/></div>');
			}
		} else {
			$("#hostnameLabel").hide();
			$("#hostname").hide();
			$("div.hwownerLb").hide();
			$("div.hwownerva").hide();
			$("#alertLabel1").remove();
			$("div.alert1").empty();
			$("#alertLabel2").remove();
			$("div.alert2").empty();
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
<h1 class="oneline">Manage</h1><div style="font-size:22px; display:inline">&nbsp;Schedule F: <s:property value="account.name" />(<s:property
	value="account.account" />)</div>
<p class="confidential">IBM Confidential</p>
<br />

<s:if test="hasErrors()">
	<s:actionerror />
	<s:fielderror />
</s:if>
<h2 class="bar-blue-med-light">Schedule F details</h2>
<br />
<s:form action="save" method="post" namespace="/admin/scheduleF" theme="simple">
	<div class="float-left" style="width:30%;">Account:</div>
	<div class="float-left" style="width:70%;">
		<s:property value="account.name" />
	</div>
	<br />
	<br />
	<div class="float-left" style="width:30%;">
		<label for="softwareTitle">Software title:</label>
	</div>
	<div class="float-left" style="width:70%;">
		<s:textfield id="softwareTitle" name="scheduleFForm.softwareTitle"
			required="true" />
	</div>
	<br />
	<br />
	<div class="float-left" style="width:30%;">
		<label for="softwareName">Software name:</label>
	</div>
	<div class="float-left" style="width:70%;">
		<s:textfield id="softwareName" name="scheduleFForm.softwareName"
			required="true" onKeyUp="keyup(this)"/>
	</div>
	<s:hidden id="softwareStatus" name="scheduleFForm.softwareStatus" />
	<br />
	<br />
	<div class="float-left" style="width:30%;">
		<label for="manufacturer">Manufacturer:</label>
	</div>
	<div class="float-left" style="width:70%;">
		<s:textfield id="manufacturer" name="scheduleFForm.manufacturer"
			required="true" />
	</div>
	<br />
	<br />
	<div class="float-left" style="width:30%;">
		<label for="scopeArrayList">Level:</label>
	</div>
	<div class="float-left" style="width:70%;">
		<s:select id="levelArrayList" list="#{'PRODUCT':'PRODUCT', 'HWOWNER':'HWOWNER', 'HWBOX':'HWBOX', 'HOSTNAME':'HOSTNAME'}" name="scheduleFForm.level"  onchange="levelSltChng(this)" />
	</div> 
	<br />
	<br />
	<div class="clear"></div>
	<div id="levelSpan"></div>
  	<s:if  test="%{scheduleFForm.hwowner!=null}"> 
	<div id="hwownerLb" class="float-left" style="width:30%;"><label id="hwownerLabel" for="hwowerid">Hwowner:</label></div>
	<div id="hwownerva" class="float-left" style="width:70%;"><select name="scheduleFForm.hwowner" id="hwowerid"  onChange="hwowerChng()">
	<option value="IBM">IBM</option><option value="CUSTO">CUSTO</option></select>
	</div>
 	</s:if>
 	<s:if  test="%{scheduleFForm.serial!=null && scheduleFForm.machineType!=null}"> 
	<div id="serialLb" class="float-left" style="width:30%;"><label id="serialLabel" for="serialNumber">Serial:</label></div>
	<div id="serialva" class="float-left" style="width:70%;">
		<s:textfield id="serial" name="scheduleFForm.serial"
			 />
	</div>
	<div id="machinetLb" class="float-left" style="width:30%;"><label id="machineTypeLabel" for="machineType">MachineType:</label></div>
	<div id="machietva"  class="float-left" style="width:70%;">
		<s:textfield id="machineType" name="scheduleFForm.machineType" onKeyUp="keyup(this)"
			 />
	</div>
 	</s:if>
	<s:if  test="%{scheduleFForm.hostname!=null}"> 
	<div id="hostnameLb" class="float-left" style="width:30%;">
	      <label id="hostnameLabel" for="hostname">Hostname:</label>
	</div>
	
	<div class="float-left" style="width:70%;">
		<s:textfield id="hostname" name="scheduleFForm.hostname"
			 />
	</div>
	</s:if> 
	<div id="level"></div>
	<div class="clear"></div> 
	<br />
	<div class="float-left" style="width:30%;">
		<label for="scopeArrayList">Scope:</label>
	</div>
	<div class="float-left" style="width:70%;">
		<s:select id="scopeArrayList" list="scopeArrayList" listKey="id"
			listValue="description" name="scheduleFForm.scopeId" onChange="hwowerChng()"/>
	</div>
	<br />
	<br />
	
	<!-- AB added -->
	<div class="float-left" style="width:30%;">
		<label for="swFinanResp">SW Financial Resp:</label>
	</div>
	<div class="float-left" style="width:70%;">
		<s:select id="swFinanceArrayList" list="#{'IBM':'IBM', 'CUSTO':'CUSTO'}" name="scheduleFForm.swFinanResp"/>
	</div>
	<br />
	<br />				
	
	<div class="float-left" style="width:30%;">
		<label for="complianceReporting">Compliance reporting:</label>
	</div>
	<div class="float-left" style="width:70%;">
		<s:text name="account.softwareComplianceManagement" />
	</div>
	<br />
	<br />
	<div class="float-left" style="width:30%;">
		<label for="sourceArrayList">Source:</label>
	</div>
	<div class="float-left" style="width:70%;">
		<s:select id="sourceArrayList" list="sourceArrayList" listKey="id"
			listValue="description" name="scheduleFForm.sourceId" />
	</div>
	<br />
	<br />
	<div class="float-left" style="width:30%;">
		<label for="sourceLocation">Source location:</label>
	</div>
	<div class="float-left" style="width:70%;">
		<s:textfield id="sourceLocation" name="scheduleFForm.sourceLocation"
			required="true" />
	</div>
	<br />
	<br />
	<div class="float-left" style="width:30%;">
		<label for="statusArrayList">Status:</label>
	</div>
	<div class="float-left" style="width:70%;">
		<s:select id="statusArrayList" list="statusArrayList" listKey="id"
			listValue="description" name="scheduleFForm.statusId" />
	</div>
	<br />
	<br />
	<div class="float-left" style="width:30%;">
		<label for="businessJustification">Business justification:</label>
	</div>
	<div class="float-left" style="width:70%;">
		<s:textfield id="businessJustification"
			name="scheduleFForm.businessJustification" required="true" />
	</div>
	<div class="button-bar">
		<div class="buttons"><span class="button-blue">
			<s:submit value="Save" method="doSave" />
			<s:submit value="Cancel" method="doCancel" />
		</span></div>
	</div>
</s:form>
<br />
<br />
<display:table name="scheduleF.scheduleFHList" class="basic-table" id="row" summary="Schedule F list"
	decorator="org.displaytag.decorator.TotalTableDecorator" cellspacing="1"
	cellpadding="0">
	<display:column property="softwareName" title="Software name" />
	<display:column property="level" title="Level" />
	<display:column property="hwOwner" title="Hw owner" />
	<display:column property="hostname" title="Hostname" />
	<display:column property="serial" title="Serial" />
	<display:column property="machineType" title="Machine Type" />
	<display:column property="softwareTitle" title="Software title" />
	<display:column property="manufacturer" title="Manufacturer" />
	<display:column property="scope.description"  title="Scope" />
		<!-- AB added -->
	<display:column property="SWFinanceResp"  title="SW Financial Resp" />
	
	<display:column property="source.description"  title="Source" />
	<display:column property="sourceLocation" title="Source location" />
	<display:column property="status.description" title="Status" />
	<display:column property="businessJustification"
		title="Business justification" />
	<display:column property="remoteUser" title="Remote User" />
	<display:column property="recordTime" class="date"
		format="{0,date,MM-dd-yyyy}" title="Record Time" />
</display:table>
