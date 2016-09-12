<%@ taglib prefix="s" uri="/struts-tags"%>

<s:url id="workspaceLink" action="workspace" namespace="/account/recon"
	includeContext="true" includeParams="none">
</s:url>
<div class="ibm-columns">
	<h3>Confirm reconciliation workspace settings</h3>
	<br />
	<div id="msg" class="ibm-col-1-1" style="float:left;width:100%" >
		<s:if test="total > 300">
			<p>Reconciliation workspace settings successfully updated.</p>
			<p>Your workspace settings will return ${total} alerts, would you like to <a href="settings.htm">revise</a> your workspace settings or <s:a href="%{workspaceLink}">continue</s:a> to the workspace?</p>
		</s:if>
		<s:if test="total <= 300">
			<p>Reconciliation workspace settings successfully updated. Use the navigation on the left to proceed to the workspace or click <s:a href="%{workspaceLink}">here</s:a>.</p>
		</s:if>
	</div>
	<div class="ibm-rule"> <hr /> </div>

		<div id="recon_settings" class="ibm-col-1-1" style="float:left;width:100%">
			<h4>Reconciliation settings</h4>
			<div style="float:left;width:25%">
				<label for="reconcileType">Reconcile type:</label>
			</div>
			<div style="float:left;width:45%">
				<s:property value="reconcileTypeName" />
			</div>
		</div>
    <div class="ibm-rule"> <hr /> </div>

	<div id="alert_settings" class="ibm-col-1-1"  style="float:left;width:100%">
		<h4>Alert settings</h4>
		<div style="float:left;width:25%">
			<label for="alertStatus">Alert status:</label>
		</div>
		<div style="float:left;width:45%">
			<s:property	value="reconSetting.alertStatus" />
		</div>
	<br />
			<div style="float:left;width:25%">
				<label for="alertColor">Alert age:</label>
			</div>
			<div style="float:left;width:45%">
				<s:if test="reconSetting.alertFrom != null">
					More than <s:property value="reconSetting.alertFrom"/> days
				</s:if>
				<s:if test="reconSetting.alertFrom!=null && reconSetting.alertTo!=null"> and </s:if>
				<s:if test="reconSetting.alertTo != null">
					Less than <s:property value="reconSetting.alertTo"/> days
				</s:if>
			</div>
	<br />
	
	
			<div style="float:left;width:25%">
				<label for="assigned">Assignment</label>
			</div>
			<div style="float:left;width:45%">
				<s:property	value="reconSetting.assigned" />
			</div>
	<br />
			<div style="float:left;width:25%">
				<label for="assignee">Assignee:</label>
			</div>
			<div style="float:left;width:45%">
				<s:property value="reconSetting.assignee" />
			</div>
	</div>
	<div class="ibm-rule"> <hr /> </div>
	<div id="hardware_settings" class="ibm-col-1-1"  style="float:left;width:100%">
		<h4>Hardware settings</h4>
		<div style="float:left;width:25%">
			<label for="hostname">Owner:</label>
		</div>
		<div style="float:left;width:45%">
			<s:property	value="reconSetting.owner" />
		</div>
		<br />
		<div style="float:left;width:25%">
			<label for="countries">Country:</label>
		</div>
		<div style="float:left;width:45%">
			<s:iterator value="reconSetting.countries">
				<s:property />
			</s:iterator>
		</div>
		<br />
		<div style="float:left;width:25%">
			<label for="hostname">Hostname(s):</label>
		</div>
		<div style="float:left;width:45%">
			<s:iterator	value="reconSetting.names">
				<s:property />
			</s:iterator>
		</div>
		<br />
		<div style="float:left;width:25%">
			<label for="products">Serial number(s):</label>
		</div>
		<div style="float:left;width:45%">
			<s:iterator value="reconSetting.serialNumbers">
				<s:property />
			</s:iterator>
		</div>
	</div>
    <div class="ibm-rule"> <hr /> </div>
	<div id="software_settings" class="ibm-col-1-1"  style="float:left;width:100%">
		<h4>Software settings</h4>
		<div style="float:left;width:25%">
			<label for="products">Product(s):</label>
		</div>
		<div style="float:left;width:45%">
			<s:iterator value="reconSetting.productInfoNames">
				<s:property />
			</s:iterator>
		</div>
		<br/>
		<div style="float:left;width:25%">
			<label for="products">SWCM ID(s):</label>
		</div>
		<div style="float:left;width:45%">
			<s:iterator value="reconSetting.swcmIDs">
				<s:property />
			</s:iterator>
		</div>
		
	</div>
	<div class="ibm-rule"> <hr /> </div>
	<div id="software_settings" class="ibm-col-1-1"  style="float:left;width:100%">
		<h4>Schedule F settings</h4>
		<div style="float:left;width:25%">
			<label for="scope">Scope:</label>
		</div>
		<div style="float:left;width:45%">
			<s:property	value="reconSetting.scope" />
		</div>
		<br />
		<div style="float:left;width:25%">
			<label for="finanResp">SW Financial Resp:</label>
		</div>
		<div style="float:left;width:45%">
			<s:property	value="reconSetting.finanResp" />
		</div>		
	</div>
</div>
