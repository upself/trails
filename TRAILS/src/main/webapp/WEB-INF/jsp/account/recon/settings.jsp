<%@ taglib prefix="s" uri="/struts-tags"%>
<script src="${pageContext.request.contextPath}/js/jquery.js"
	type="text/javascript"></script>
<script type="text/javascript">
$(function(){
	 $("#clearButton").click(function(){
		$("input:text").val("");
		$("select :first-child").attr("selected",true);
	 });
	
})
</script>

<h1>Reconciliation workspace settings</h1>
<br />
<p>Use the form below to modify the reconciliation workspace
settings. All fields are optional.</p>
<br />
<div class="hrule-dots"></div>

<s:form action="settings" method="post" namespace="/account/recon"
	theme="simple">
	<p class="sub-title">Reconciliation settings</p>

	<div class="float-left" style="width: 30%;"><label
		for="reconcileType">Reconcile type:</label></div>

	<div class="float-left" style="width: 70%;"><s:select
		name="reconSetting.reconcileType" label="Reconciliation type" id="reconcileType"
		list="reconcileTypes" listKey="id" listValue="name" headerKey=""
		headerValue="All" /></div>

	<div class="clear"></div>
	<div class="hrule-dots"></div>

	<p class="sub-title">Alert settings</p>

	<div class="float-left" style="width: 30%;"><label
		for="alertStatus">Alert status:</label></div>
	<div class="float-left" style="width: 70%;"><s:select
		name="reconSetting.alertStatus" label="Alert status" id="alertStatus"
		list="#{'OPEN':'Open','CLOSED':'Closed' }" headerKey=""
		headerValue="All" /></div>
	<br />
	<br />
	<div class="float-left" style="width: 30%;"><label
		for="alertColor">Alert color:</label></div>
	<div class="float-left" style="width: 70%;"><s:select
		name="reconSetting.alertColor" label="Alert color" id="alertColor"
		list="#{'Green':'Green','Yellow':'Yellow','Red':'Red' }" headerKey=""
		headerValue="All" /></div>
	<br />
	<br />
	<div class="float-left" style="width: 30%;"><label for="assigned">Assignment</label></div>
	<div class="float-left" style="width: 70%;"><s:select id="assigned"
		name="reconSetting.assigned" label="Is this alert assigned?"
		list="#{'Assigned':'Assigned','Unassigned':'Unassigned'}" headerKey=""
		headerValue="All" /></div>
	<br />
	<br />
	<div class="float-left" style="width: 30%;"><label for="assignee">Assignee:</label></div>
	<div class="float-left" style="width: 70%;"><s:textfield
		name="reconSetting.assignee" label="Specify an assignee" id="assignee"/></div>

	<div class="clear"></div>
	<div class="hrule-dots"></div>

	<p class="sub-title">Hardware settings</p>

	<div class="float-left" style="width: 30%;"><label for="ownerSelect">Owner:</label></div>
	<div class="float-left" style="width: 70%;"><s:select
		name="reconSetting.owner" label="Owner" id="ownerSelect"
		list="#{'IBM':'IBM','Customer':'Customer'}" headerKey=""
		headerValue="All"/></div>
	<br />
	<br />
	<div class="float-left" style="width: 30%;">Country(s):</div>
	<div class="float-left" style="width: 70%;">
	<div class="input-note">Use exact values</div>
	<div class="date">
	<label for="countries_1">country one</label>
	<label for="countries_2">country two</label>
	<label for="countries_3">country three</label>
	<label for="countries_4">country four</label>
	<label for="countries_5">country five</label>
	<label for="countries_6">country six</label> 
	<s:textfield name="reconSetting.countries[0]" maxlength="2"
		id="countries_1" /> <s:textfield name="reconSetting.countries[1]"
		maxlength="2" id="countries_2" /> <s:textfield
		name="reconSetting.countries[2]" maxlength="2" id="countries_3" /> <br />
	<s:textfield name="reconSetting.countries[3]" maxlength="2"
		id="countries_4" /> <s:textfield name="reconSetting.countries[4]"
		maxlength="2" id="countries_5" /> <s:textfield
		name="reconSetting.countries[5]" maxlength="2" id="countries_6" /></div></div>
	<br />
	<br />
	<div class="float-left" style="width: 30%;"><label>Hostname(s):</label></div>
	<div class="float-left" style="width: 70%;">
	<div class="input-note">Use exact values</div>
		<div class="date">
	<label for="hostname_1">hostname one</label>
	<label for="hostname_2">hostname two</label>
	<label for="hostname_3">hostname three</label>
	<label for="hostname_4">hostname four</label>
	<label for="hostname_5">hostname five</label>
	<label for="hostname_6">hostname six</label> 
	<s:textfield name="reconSetting.names[0]" maxlength="255" id="hostname_1" />
	<s:textfield name="reconSetting.names[1]" maxlength="255" id="hostname_2" />
	<s:textfield name="reconSetting.names[2]" maxlength="255" id="hostname_3" />
	<br />
	<s:textfield name="reconSetting.names[3]" maxlength="255" id="hostname_4" />
	<s:textfield name="reconSetting.names[4]" maxlength="255" id="hostname_5" />
	<s:textfield name="reconSetting.names[5]" maxlength="255" id="hostname_6" /></div></div>
	<br />
	<br />
	<div class="float-left" style="width: 30%;"><label>Serial
	number(s):</label></div>
	<div class="float-left" style="width: 70%;">
	<div class="input-note">Use exact values</div>
			<div class="date">
	<label for="serialNo_1">serialNo one</label>
	<label for="serialNo_2">serialNo two</label>
	<label for="serialNo_3">serialNo three</label>
	<label for="serialNo_4">serialNo four</label>
	<label for="serialNo_5">serialNo five</label>
	<label for="serialNo_6">serialNo six</label> 
	<s:textfield name="reconSetting.serialNumbers[0]" maxlength="32"
		id="serialNo_1" /> <s:textfield name="reconSetting.serialNumbers[1]"
		maxlength="32" id="serialNo_2" /> <s:textfield
		name="reconSetting.serialNumbers[2]" maxlength="32" id="serialNo_3" />
	<br />
	<s:textfield name="reconSetting.serialNumbers[3]" maxlength="32"
		id="serialNo_4" /> <s:textfield name="reconSetting.serialNumbers[4]"
		maxlength="32" id="serialNo_5" /> <s:textfield
		name="reconSetting.serialNumbers[5]" maxlength="32" id="serialNo_6" /></div></div>

	<div class="clear"></div>
	<div class="hrule-dots"></div>

	<p class="sub-title">Software settings</p>

	<div class="float-left" style="width: 30%;"><label>Product(s):</label></div>
	<div class="float-left" style="width: 70%;">
	<div class="input-note">Use exact values</div>
				<div class="date">
	<label for="product_1">product one</label>
	<label for="product_2">product two</label>
	<label for="product_3">product three</label>
	<label for="product_4">product four</label>
	<label for="product_5">product five</label>
	<label for="product_6">product six</label> 
	<s:textfield name="reconSetting.productInfoNames[0]" maxlength="128"
		id="product_1" /> <s:textfield name="reconSetting.productInfoNames[1]"
		maxlength="128" id="product_2" /> <s:textfield
		name="reconSetting.productInfoNames[2]" maxlength="128" id="product_3" />
	<br />
	<s:textfield name="reconSetting.productInfoNames[3]" maxlength="128"
		id="product_4" /> <s:textfield name="reconSetting.productInfoNames[4]"
		maxlength="128" id="product_5" /> <s:textfield
		name="reconSetting.productInfoNames[5]" maxlength="128" id="product_6" /></div></div>

	<div class="clear"></div>
	<div class="hrule-dots"></div>
	<div class="button-bar">
	<div class="buttons">
		<span class="button-blue"> 
			<input type="button" value="Clear" id="clearButton" alt="clear filter"/>
		</span>
		<span class="button-blue"> 
			<s:submit value="Submit" method="update" alt="Submit" /> 
		</span>
	</div>
	</div>
</s:form>
