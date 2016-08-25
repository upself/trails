<%@ taglib prefix="s" uri="/struts-tags"%>

<s:url id="trails" action="home" namespace="/" includeContext="true"
	includeParams="none">
</s:url>

<s:url id="reports" action="home" namespace="/reports"
	includeContext="true" includeParams="none">
</s:url>

<s:url id="alerts" action="home" namespace="/reports/alertRedAging"
	includeContext="true" includeParams="none">
</s:url>

<p id="breadcrumbs">
<s:a href="%{trails}">TRAILS</s:a> &gt; 
<s:a href="%{reports}">Reports</s:a> &gt; 
<s:a href="%{alerts}">Aging red alerts</s:a> &gt; 

<s:if test="geography != null && region != null && countryCode != null && department != null">
	<s:url id="geographyLink" action="geography"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
	</s:url>
	<s:a href="%{geographyLink}">Geography</s:a> &gt;
	
	<s:url id="regionLink" action="region"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{regionLink}">Region</s:a> &gt;
	
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
	
	<s:url id="departmentLink" action="department"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="geographyId" value="geography.id" />
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>
	<s:a href="%{departmentLink}">Department</s:a> &gt;
</s:if> 
<s:elseif test="geography != null && region != null && countryCode != null">
	<s:url id="geographyLink" action="geography"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
	</s:url>
	<s:a href="%{geographyLink}">Geography</s:a> &gt;
	
	<s:url id="regionLink" action="region"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{regionLink}">Region</s:a> &gt;
	
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
</s:elseif>
<s:elseif test="geography != null && region != null && department != null">
	<s:url id="geographyLink" action="geography"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
	</s:url>
	<s:a href="%{geographyLink}">Geography</s:a> &gt;
	
	<s:url id="regionLink" action="region"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{regionLink}">Region</s:a> &gt;
	
	<s:url id="departmentLink" action="department"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{departmentLink}">Department</s:a> &gt;
</s:elseif> 
<s:elseif test="geography != null && countryCode != null && department != null">
	<s:url id="geographyLink" action="geography"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
	</s:url>
	<s:a href="%{geographyLink}">Geography</s:a> &gt;
	
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
	
	<s:url id="departmentLink" action="department"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{departmentLink}">Department</s:a> &gt;
</s:elseif> 
<s:elseif test="region != null && countryCode != null && department != null">
	<s:url id="regionLink" action="region"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
	</s:url>
	<s:a href="%{regionLink}">Region</s:a> &gt;
	
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
	
	<s:url id="departmentLink" action="department"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{departmentLink}">Department</s:a> &gt;
</s:elseif> 
<s:elseif test="geography != null && countryCode != null">
	<s:url id="geographyLink" action="geography"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
	</s:url>
	<s:a href="%{geographyLink}">Geography</s:a> &gt;
	
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
</s:elseif>
<s:elseif test="region != null && countryCode != null">
	<s:url id="regionLink" action="region"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
	</s:url>
	<s:a href="%{regionLink}">Region</s:a> &gt;
	
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
		<s:param name="regionId" value="region.id" />
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
</s:elseif> 
<s:elseif test="countryCode != null && department != null">
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
	
	<s:url id="departmentLink" action="department"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>
	<s:a href="%{departmentLink}">Department</s:a> &gt;
</s:elseif> 
<s:elseif test="region != null && department != null">
	<s:url id="regionLink" action="region"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
	</s:url>
	<s:a href="%{regionLink}">Region</s:a> &gt;
	
	<s:url id="departmentLink" action="department"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
		<s:param name="regionId" value="region.id" />
	</s:url>
	<s:a href="%{departmentLink}">Department</s:a> &gt;
</s:elseif>
<s:elseif test="geography != null && department != null">
	<s:url id="geographyLink" action="region"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
	</s:url>
	<s:a href="%{geographyLink}">Geography</s:a> &gt;
	
	<s:url id="departmentLink" action="department"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{departmentLink}">Department</s:a> &gt;
</s:elseif>
<s:elseif test="countryCode != null">
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
</s:elseif>  
<s:else>
  	<s:url id="departmentLink" action="department"
		namespace="/reports/alertRedAging" includeContext="true" includeParams="none">
	</s:url>
	<s:a href="%{departmentLink}">Department</s:a> &gt;
</s:else>
</p>

<h1>Account</h1>
<h4>Aging red alerts reports</h4>
<s:if test="geography != null || region != null || countryCode != null || department != null">
<p class="confidential">IBM Confidential</p>
<p>The following reports reflect metric purification where customer financial responsible software has been counted towards closed alerts where IBM has documented report delivery dates in Schedule F Report Date Tracking.</p>
</s:if>
<br />

Data last refreshed: <s:date name="reportTimestamp" format="MM-dd-yyyy HH:mm:ss 'EST'" /><br />
Data age (in minutes): <s:property value="reportMinutesOld" /><br />

<div id="fourth-level">

<s:if test="geography != null && region != null && countryCode != null && department != null">

	<br />
	<h2 class="green-dark">Geography: <s:property value="geography.name" /></h2>
	<h2 class="green-dark">Region: <s:property value="region.name" /></h2>
	<h2 class="green-dark">Country code: <s:property value="countryCode.name" /></h2>
	<h2 class="green-dark">Department: <s:property value="department.name" /></h2>
</s:if> 
<s:elseif test="geography != null && region != null && countryCode != null">
	<s:url id="departmentLink" value="department.htm" includeContext="false"
		includeParams="none">
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>

	<s:url id="accountLink" value="account.htm"
		includeContext="false" includeParams="none">
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>

	<ul class="text-tabs">
		<li><s:a href="%{departmentLink}">Department alerts</s:a>|</li>
		<li><s:a href="%{accountLink}" cssClass="active">Account alerts</s:a></li>
	</ul>

	<br />
	<h2 class="green-dark">Geography: <s:property value="geography.name" /></h2>
	<h2 class="green-dark">Region: <s:property value="region.name" /></h2>
	<h2 class="green-dark">Country code: <s:property value="countryCode.name" /></h2>
</s:elseif>
<s:elseif test="geography != null && region != null && department != null">

	<br />
	<h2 class="green-dark">Geography: <s:property value="geography.name" /></h2>
	<h2 class="green-dark">Region: <s:property value="region.name" /></h2>
	<h2 class="green-dark">Department: <s:property value="department.name" /></h2>
</s:elseif> 
<s:elseif test="geography != null && countryCode != null && department != null">

	<br />
	<h2 class="green-dark">Geography: <s:property value="geography.name" /></h2>
	<h2 class="green-dark">Country code: <s:property value="countryCode.name" /></h2>
	<h2 class="green-dark">Department: <s:property value="department.name" /></h2>
</s:elseif> 
<s:elseif test="region != null && countryCode != null && department != null">

	<br />
	<h2 class="green-dark">Region: <s:property value="region.name" /></h2>
		<h2 class="green-dark">Country code: <s:property value="countryCode.name" /></h2>
	<h2 class="green-dark">Department: <s:property value="department.name" /></h2>
</s:elseif> 
<s:elseif test="geography != null && countryCode != null">
	<s:url id="regionLink" value="region.htm" includeContext="false"
		includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>

	<s:url id="countryCodeLink" value="countryCode.htm"
		includeContext="false" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>

	<s:url id="departmentLink" value="department.htm"
		includeContext="false" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>

	<ul class="text-tabs">
		<li><s:a href="%{regionLink}">Region alerts</s:a>|</li>
		<li><s:a href="%{countryCodeLink}">Country code alerts</s:a>|</li>
		<li><s:a href="%{departmentLink}" cssClass="active">Department alerts</s:a></li>
	</ul>

	<br />
	<h2 class="green-dark">Geography: <s:property value="geography.name" /></h2>
	<h2 class="green-dark">Department: <s:property value="department.name" /></h2>
</s:elseif>
<s:elseif test="region != null && countryCode != null">
	<s:url id="departmentLink" value="department.htm"
		includeContext="false" includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>
	
	<s:url id="accountLink" value="account.htm"
		includeContext="false" includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>

	<ul class="text-tabs">
		<li><s:a href="%{departmentLink}">Department alerts</s:a>|</li>
		<li><s:a href="%{accountLink}" cssClass="active">Account alerts</s:a></li>
	</ul>

	<br />
	<h2 class="green-dark">Region: <s:property value="region.name" /></h2>
	<h2 class="green-dark">Country code: <s:property value="countryCode.name" /></h2>
</s:elseif> 
<s:elseif test="countryCode != null && department != null">
	<s:url id="departmentLink" value="department.htm"
		includeContext="false" includeParams="none">
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>
	
	<s:url id="accountLink" value="account.htm"
		includeContext="false" includeParams="none">
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>

	<ul class="text-tabs">
		<li><s:a href="%{departmentLink}" cssClass="active">Department alerts</s:a>|</li>
		<li><s:a href="%{accountLink}">Account alerts</s:a></li>
	</ul>

	<br />
	<h2 class="green-dark">Country code: <s:property value="countryCode.name" /></h2>
	<h2 class="green-dark">Department: <s:property value="department.name" /></h2>
</s:elseif> 
<s:elseif test="region != null && department != null">
	<s:url id="countryCodeLink" value="countryCode.htm"
		includeContext="false" includeParams="none">
		<s:param name="regionId" value="region.id" />
	</s:url>

	<s:url id="departmentLink" value="department.htm"
		includeContext="false" includeParams="none">
		<s:param name="regionId" value="region.id" />
	</s:url>

	<ul class="text-tabs">
		<li><s:a href="%{countryCodeLink}">Country code alerts</s:a>|</li>
		<li><s:a href="%{departmentLink}" cssClass="active">Department alerts</s:a></li>
	</ul>

	<br />
	<h2 class="green-dark">Region: <s:property value="region.name" /></h2>
	<h2 class="green-dark">Department: <s:property value="department.name" /></h2>
</s:elseif>
<s:elseif test="geography != null && department != null">
	<s:url id="regionLink" value="region.htm" includeContext="false"
		includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>

	<s:url id="countryCodeLink" value="countryCode.htm"
		includeContext="false" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>

	<s:url id="departmentLink" value="department.htm"
		includeContext="false" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>

	<ul class="text-tabs">
		<li><s:a href="%{regionLink}">Region alerts</s:a>|</li>
		<li><s:a href="%{countryCodeLink}">Country code alerts</s:a>|</li>
		<li><s:a href="%{departmentLink}" cssClass="active">Department alerts</s:a></li>
	</ul>

	<br />
	<h2 class="green-dark">Geography: <s:property value="geography.name" /></h2>
	<h2 class="green-dark">Department: <s:property value="department.name" /></h2>
</s:elseif>
<s:elseif test="countryCode != null">
	<s:url id="departmentLink" value="department.htm"
		includeContext="false" includeParams="none">
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>
	
	<s:url id="accountLink" value="account.htm"
		includeContext="false" includeParams="none">
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>

	<ul class="text-tabs">
		<li><s:a href="%{departmentLink}">Department alerts</s:a>|</li>
		<li><s:a href="%{accountLink}" cssClass="active">Account alerts</s:a></li>
	</ul>

	<br />
	<h2 class="green-dark">Country code: <s:property value="countryCode.name" /></h2>
</s:elseif>  
<s:else>

	<br />
	<h2 class="green-dark">Department: <s:property value="department.name" /></h2>
</s:else>
</div>
