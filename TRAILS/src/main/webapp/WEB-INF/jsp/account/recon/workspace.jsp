<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/js/jquery.liveSearch.css" />
<script src="${pageContext.request.contextPath}/js/jquery.js"
	type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/jquery.liveSearch.js"
	type="text/javascript"></script>
<script type="text/javascript">
	function popupBravoSl(id) {
		newWin = window
				.open(
						'//${bravoServerName}/BRAVO/software/view.do?id=' + id,
						'popupWindow',
						'height=600,width=1200,resizable=yes,menubar=yes,status=yes,toolbar=yes,scrollbars=yes');
		newWin.focus();
		void (0);
	}

	function popupFreePool(url) {
		newWin = window
				.open(
						url,
						'popupWindow',
						'height=600,width=1200,resizable=yes,menubar=yes,status=yes,toolbar=yes,scrollbars=yes');
		newWin.focus();
		void (0);
	}

	function displayPopUp(page) {

		window
				.open(page, 'PopUpWindow',
						'left=200,top=180,resizable=yes,scrollbars=yes,width=700,height=500');
	}

	function rcnTypSltChng(objSelect) {
		var value = objSelect.value;
		if (value == 1) {
			$("#filterSpan")
					.after(
							'<input id="btnAddFltr" type="button" value="+filter" onclick="addFltr()"/>');
		} else {
			$("#btnAddFltr").remove();
			$("div.fltr").empty();
		}
	}

	var fltrCntr = 0;
	function addFltr() {

		var filter = '<div class="fltr">'
				+ '<div class="clear"></div>'
				+ '<div class="hrule-dots"></div>'
				+ '<div class="clear"></div>'
				+ '<input type="button" value="delete" onclick="delFltr(this)"/>'
				+ ' Capacity Type:';
		$
				.ajax({
					url : "${pageContext.request.contextPath}/account/recon/getCapcityTypes.htm",
					async : false,
					data : {
						index : fltrCntr
					},
					beforeSend : function() {
						$("#filters").html("loading capacity types...");
					},
					success : function(data, result) {
						filter += data + '</br></br>';
					},
					complete : function() {
						$("#filters").empty();
					}
				});
		filter += ' Manufacturer(s): <input type="text" name="filter['
				+ fltrCntr
				+ '].manufacturer" autocomplete="off" onKeyUp="keyup(this)"/>'
				+ ' Product name(s):<input type="text" name="filter['
				+ fltrCntr
				+ '].productName" autocomplete="off" onKeyUp="keyup(this)"/>'
				+ ' PO number(s):<input type="text" name="filter['+fltrCntr+'].poNo"/>'
				+ ' SWCM ID:<input type="text" name="filter['+fltrCntr+'].swcmId"/>'
				+ '</div>';

		$("#filters").after(filter);
		fltrCntr++;
	}

	function delFltr(fltr) {
		$(fltr).parent("div").empty();
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
								url : "${pageContext.request.contextPath}/account/recon/quickSearch.htm",
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
										type.value = $(this).text();
									});
								}
							})
				}, 1000);

	}
	
</script>

<s:url id="freepool" action="licenseFreePool"
	namespace="/account/license" includeContext="true" includeParams="none">
</s:url>

<h1>
	Reconcile workspace:
	<s:property value="account.name" />
	(
	<s:property value="account.account" />
	)
</h1>
<p class="confidential">IBM Confidential</p>
<br />
<p>The results from your reconciliation workspace settings are
	displayed below. Select an action to take by using the dropdown box
	below and then select the assets in which you would like to use for the
	basis of your action. The actions, manual license allocation and
	included with other product, will only accept a single line item
	selection. Once your selection is complete, depress the "GO" button to
	be taken to the next screen.</p>
<br />
<div style="float: right">
	<s:include value="/WEB-INF/jsp/include/reportModule.jsp" />
</div>
<br />
<br />
<div class="hrule-dots"></div>
<br />
<s:if test="hasErrors()">
	<s:actionerror />
	<s:fielderror />
</s:if>
<s:form action="showQuestion" namespace="/account/recon" theme="simple">
	<s:hidden name="page" value="%{#attr.page}" />
	<s:hidden name="dir" value="%{#attr.dir}" />
	<s:hidden name="sort" value="%{#attr.sort}" />
	<div class="float-left" style="width: 75%;">
		<label for="action_1">Action:</label>
		<s:select name="reconcileTypeId" label="Action" list="reconcileTypes"
			listKey="id" listValue="name" headerKey="" headerValue="Select one"
			id="action_1" onchange="rcnTypSltChng(this)" />
		<span class="button-blue"> <s:submit value="GO" id="go-btn"
				alt="Submit" />
		</span>
	</div>
	<div class="clear"></div>

	<div id="filterSpan"></div>
	<div id="filters"></div>
	<br />

	<div class="clear"></div>
	<div class="hrule-dots"></div>
	<div class="clear"></div>
	<div class="float-left" style="width: 25%;">
		<a href="javascript:popupFreePool('${freepool}')">License free
			pool</a>
	</div>
	<div class="clear"></div>
	<br />

	<display:table name="data" class="basic-table" id="row"
		summary="Reconciliation Query Results"
		decorator="org.displaytag.decorator.TotalTableDecorator"
		cellspacing="1" cellpadding="0" style="font-size:.8em"
		requestURI="workspace.htm">
		<display:caption media="html">Reconciliation results</display:caption>
		<display:column title="">
			<s:if test="#attr.row.scope eq 'Not specified'">
				<s:checkbox name="list[%{#attr.row_rowNum-1}].selected" theme="simple" id="action" disabled="true"/>
			</s:if>
			<s:else>
				<s:checkbox name="list[%{#attr.row_rowNum-1}].selected" theme="simple" id="action" />
			</s:else>
			<s:hidden name="list[%{#attr.row_rowNum-1}].installedSoftwareId"
				value="%{#attr.row.installedSoftwareId}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].alertAgeI"
				value="%{#attr.row.alertAgeI}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].hostname"
				value="%{#attr.row.hostname}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].serial"
				value="%{#attr.row.serial}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].country"
				value="%{#attr.row.country}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].owner"
				value="%{#attr.row.owner}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].assetType"
				value="%{#attr.row.assetType}" />
			<!-- fake code -->
			<s:hidden name="list[%{#attr.row_rowNum-1}].assetName"
				value="%{#attr.row.assetName}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].scope" value="%{#attr.row.scope}"/>
			<s:hidden name="list[%{#attr.row_rowNum-1}].pid"
				value="%{#attr.row.pid}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].lparServerType"
				value="%{#attr.row.lparServerType}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].hardwareStatus"
				value="%{#attr.row.hardwareStatus}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].lparStatus"
				value="%{#attr.row.lparStatus}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].processorCount"
				value="%{#attr.row.processorCount}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].hardwareProcessorCount"
				value="%{#attr.row.hardwareProcessorCount}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].hwLparEffProcessorCount"
				value="%{#attr.row.hwLparEffProcessorCount}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].hwLparEffProcessorStatus"
				value="%{#attr.row.hwLparEffProcessorStatus}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].processorManufacturer"
				value="%{#attr.row.processorManufacturer}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].mastProcessorType"
				value="%{#attr.row.mastProcessorType}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].nbrCoresPerChip"
				value="%{#attr.row.nbrCoresPerChip}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].mastProcessorModel"
				value="%{#attr.row.mastProcessorModel}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].nbrOfChipsMax"
				value="%{#attr.row.nbrOfChipsMax}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].cpuIFL"
				value="%{#attr.row.cpuIFL}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].effectiveThreads"
				value="%{#attr.row.effectiveThreads}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].cpuLsprMips"
				value="%{#attr.row.cpuLsprMips}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].partLsprMips"
				value="%{#attr.row.partLsprMips}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].cpuGartnerMips"
				value="%{#attr.row.cpuGartnerMips}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].partGartnerMips"
				value="%{#attr.row.partGartnerMips}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].cpuMsu"
				value="%{#attr.row.cpuMsu}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].partMsu"
				value="%{#attr.row.partMsu}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].shared"
				value="%{#attr.row.shared}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].sysplex"
				value="%{#attr.row.sysplex}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].spla"
				value="%{#attr.row.spla}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].internetIccFlag"
				value="%{#attr.row.internetIccFlag}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].productInfoName"
				value="%{#attr.row.productInfoName}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].reconcileTypeName"
				value="%{#attr.row.reconcileTypeName}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].reconcileTypeId"
				value="%{#attr.row.reconcileTypeId}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].assignee"
				value="%{#attr.row.assignee}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].alertId"
				value="%{#attr.row.alertId}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].reconcileId"
				value="%{#attr.row.reconcileId}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].productInfoId"
				value="%{#attr.row.productInfoId}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].chips"
				value="%{#attr.row.chips}" />
		</display:column>
		<display:column property="alertStatus" title="" />
		<display:column property="alertAgeI" title="Age" sortable="true"
			sortProperty="aus.alertAge" />
		<display:column property="hostname" title="Hostname"
			sortProperty="hl.name" sortable="true" />
		<display:column property="serial" title="Serial"
			sortProperty="h.serial" sortable="true" />
		<display:column property="country" title="Ctry"
			sortProperty="h.country" sortable="true" />
		<display:column property="owner" title="Owner" sortProperty="h.owner"
			sortable="true" />
		<display:column property="assetType" title="Asset type"
			sortProperty="mt.type" sortable="true" />
		<display:column property="pid" title="PID"
			sortProperty="sw.pid" sortable="true" />
		<display:column property="hardwareStatus" title="Hardware Status"
			sortProperty="h.hardwareStatus" sortable="true" />
		<display:column property="lparStatus" title="Lpar Status"
			sortProperty="hl.lparStatus" sortable="true" />
		<display:column property="hwLparEffProcessorCount" title="# Proc."
			sortProperty="hle.processorCount" sortable="true" />
		<display:column property="chips" title="# Chips"
			sortProperty="h.chips" sortable="true" />
		<!-- fake code -->
		<display:column property="scope" title="Scope" sortProperty="scope" sortable="true"/>
		<display:column sortProperty="sw.softwareName" title="Software"
			sortable="true">
			<a
				href="javascript:popupBravoSl(<s:property value="%{#attr.row.installedSoftwareId}"/>)">${row.productInfoName}</a>
		</display:column>
		<display:column title="Action" sortProperty="rt.name" sortable="true">
			<s:if test="#attr.row.reconcileId!=null">
				<a
					href="javascript:displayPopUp('reconcileDetails.htm?id=<s:property value="%{#attr.row.reconcileId}" />')">${row.reconcileTypeName}</a>
			</s:if>
		</display:column>
		<display:column title="Assignee" sortable="true"
			sortProperty="assignee">
			<a
				href="javascript:displayPopUp('/TRAILS/account/alerts/alertUnlicensedIbmSwHistory.htm?id=<s:property value="%{#attr.row.alertId}" />')">${row.assignee}</a>
		</display:column>
	</display:table>
</s:form>
