<%@ taglib prefix="s" uri="/struts-tags"%>
<script src="${pageContext.request.contextPath}/js/jquery.js"
	type="text/javascript"></script>
<script type="text/javascript">
	$(function() {
		$("#clearButton").click(function() {
			$("input:text").val("");
			$("select :first-child").attr("selected", true);
		});
		
	});
	
	function updateSettings(){
		document.settings.action="settings!update.htm";
		document.settings.submit();
	}
</script>
 
<p>Use the form below to modify the reconciliation workspace settings. All fields are optional.</p>
<div class="ibm-rule"> <hr /> </div>
		
<div class="ibm-column-form">
<s:form action="settings" method="post" namespace="/account/recon" theme="simple">
	
	<div id="recon_settings" class="ibm-columns">
		<div class="ibm-col-1-1" style="float:left;width:100%">
			<h4>Reconciliation settings</h4>
			<div style="float:left;width:25%">
				<label for="reconcileType">Reconcile type:</label>
			</div>
		
			<div style="float:left;width:45%">
				<s:select name="reconSetting.reconcileType" label="Reconciliation type" id="reconcileType" list="reconcileTypes" listKey="id" listValue="name" headerKey="" headerValue="All" />
			</div>
		</div>
	</div>
	<div class="ibm-rule"> <hr /> </div>
	
	<div id="alert_settings" class="ibm-columns">
		<h4>Alert settings</h4>
		<div class="ibm-col-1-1" style="float:left;width:100%">
			<div style="float:left;width:25%">
				<label for="alertStatus">Alert status:</label>
			</div>
			<div style="float:left;width:45%">
				<s:select name="reconSetting.alertStatus" label="Alert status"
					id="alertStatus" list="#{'OPEN':'Open','CLOSED':'Closed' }"
					headerKey="" headerValue="All" />
			</div>
		</div>
		<br /><br/>
		<div class="ibm-col-1-1" style="float:left;width:100%">
			<div style="float:left;width:25%">
				<label for="alertColor">Alert color:</label>
			</div>
			<div style="float:left;width:45%">
				<s:select name="reconSetting.alertColor" label="Alert color"
					id="alertColor"
					list="#{'Green':'Green','Yellow':'Yellow','Red':'Red' }" headerKey=""
					headerValue="All" />
			</div>
		</div>
		<br/><br/>
		<div class="ibm-col-1-1" style="float:left;width:100%">
			<div style="float:left;width:25%">
				<label for="assigned">Assignment</label>
			</div>
			<div style="float:left;width:45%">
				<s:select id="assigned" name="reconSetting.assigned"
					label="Is this alert assigned?"
					list="#{'Assigned':'Assigned','Unassigned':'Unassigned'}"
					headerKey="" headerValue="All" />
			</div>
		</div>
		<br/><br/>
		<div class="ibm-col-1-1" style="float:left;width:100%">
			<div style="float:left;width:25%">
				<label for="assignee">Assignee:</label>
			</div>
			<div style="float:left;width:45%">
				<s:textfield name="reconSetting.assignee" label="Specify an assignee"
					id="assignee" />
			</div>
		</div>
	</div>
	<div class="ibm-rule"> <hr /> </div>
	
	<div id="hardware_settings" class="ibm-columns">
		<h4>Hardware settings</h4>
			<div class="ibm-col-1-1" style="float:left;width:100%">
				<div style="float:left;width:25%">
					<label for="ownerSelect">Owner:</label>
				</div>
				<div style="float:left;width:45%">
					<s:select name="reconSetting.owner" label="Owner" id="ownerSelect"
						list="#{'IBM':'IBM','Customer':'Customer'}" headerKey=""
						headerValue="All" />
				</div>
			</div>
			<br />
			<br />
			<div class="ibm-col-1-1" style="float:left;width:100%">
				<div style="float:left;width:25%">Country(s):</div>
				<div style="float:left;width:75%">
					<div class="input-note">Use exact values</div>
					<div>
						<s:textfield name="reconSetting.countries[0]" maxlength="2" id="countries_1" />
						<s:textfield name="reconSetting.countries[1]" maxlength="2" id="countries_2" />
						<s:textfield name="reconSetting.countries[2]" maxlength="2" id="countries_3" />
						<br />
						<s:textfield name="reconSetting.countries[3]" maxlength="2" id="countries_4" />
						<s:textfield name="reconSetting.countries[4]" maxlength="2" id="countries_5" />
						<s:textfield name="reconSetting.countries[5]" maxlength="2" id="countries_6" />
					</div>
				</div>
			</div>
			<br />
			<br />
			<div class="ibm-col-1-1" style="float:left;width:100%">
				<div style="float:left;width:25%">
					<label>Hostname(s):</label>
				</div>
				<div style="float:left;width:75%">
					<div class="input-note">Use exact values</div>
					<div class="date">
						<s:textfield name="reconSetting.names[0]" maxlength="255" id="hostname_1" />
						<s:textfield name="reconSetting.names[1]" maxlength="255" id="hostname_2" />
						<s:textfield name="reconSetting.names[2]" maxlength="255" id="hostname_3" />
						<br />
						<s:textfield name="reconSetting.names[3]" maxlength="255" id="hostname_4" />
						<s:textfield name="reconSetting.names[4]" maxlength="255" id="hostname_5" />
						<s:textfield name="reconSetting.names[5]" maxlength="255" id="hostname_6" />
					</div>
				</div>
			</div>
			<br />
			<br />
			<div class="ibm-col-1-1" style="float:left;width:100%">
				<div style="float:left;width:25%">
					<label>Serial number(s):</label>
				</div>
				<div style="float:left;width:75%">
					<div class="input-note">Use exact values</div>
					<div class="date">
						<s:textfield name="reconSetting.serialNumbers[0]" maxlength="32" id="serialNo_1" />
						<s:textfield name="reconSetting.serialNumbers[1]" maxlength="32" id="serialNo_2" />
						<s:textfield name="reconSetting.serialNumbers[2]" maxlength="32" id="serialNo_3" />
						<br />
						<s:textfield name="reconSetting.serialNumbers[3]" maxlength="32" id="serialNo_4" />
						<s:textfield name="reconSetting.serialNumbers[4]" maxlength="32" id="serialNo_5" />
						<s:textfield name="reconSetting.serialNumbers[5]" maxlength="32" id="serialNo_6" />
					</div>
				</div>
			</div>
	</div>
	<div class="ibm-rule"> <hr /> </div>

	<div id="software_settings" class="ibm-columns">
		<h4>Software settings</h4>
		<div class="ibm-col-1-1" style="float:left;width:100%">
			<div style="float:left;width:25%">
				<label>Product(s):</label>
			</div>
			<div style="float:left;width:75%">
				<div class="input-note">Use exact values</div>
				<div class="date">
					<s:textfield name="reconSetting.productInfoNames[0]" maxlength="128" id="product_1" />
					<s:textfield name="reconSetting.productInfoNames[1]" maxlength="128" id="product_2" />
					<s:textfield name="reconSetting.productInfoNames[2]" maxlength="128" id="product_3" />
					<br />
					<s:textfield name="reconSetting.productInfoNames[3]" maxlength="128" id="product_4" />
					<s:textfield name="reconSetting.productInfoNames[4]" maxlength="128" id="product_5" />
					<s:textfield name="reconSetting.productInfoNames[5]" maxlength="128" id="product_6" />
				</div>
			</div>
		</div>
	</div>
	<div class="ibm-rule"> <hr /> </div>
	<div style="float:right">
		<div>
			 <span class="ibm-btn-pri"> 
			 <input type="button" class="ibm-btn-pri" id="ibm-submit" value="Submit" onclick="updateSettings();">
			</span>
			 <input type="button" class="ibm-btn-pri" value="Clear" id="clearButton" alt="clear filter" />
		</div>
	</div>
</s:form>
</div>