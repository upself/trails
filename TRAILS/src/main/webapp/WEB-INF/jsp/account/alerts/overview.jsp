<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1>Alert overview: <s:property value="account.name" />(<s:property
	value="account.account" />)</h1>
<p class="confidential">IBM Confidential</p>
<br />
<small>
	Data last refreshed: <s:date name="reportTimestamp" format="MM-dd-yyyy HH:mm:ss 'EST'" /><br />
	Data age (in minutes): <s:property value="reportMinutesOld" /><br />
</small>
<br />
<display:table name="data.list" class="basic-table"
   summary="Account Alerts Overview"
	decorator="org.displaytag.decorator.TotalTableDecorator" cellspacing="1" cellpadding="0">
	<display:column property="alertName" title="Alert" />
	<display:column property="assignedCount" title="Assigned #"
		total="true" format="{0,number,0}" />
	<display:column property="greenSum" title="Green(0-45)" total="true"
		format="{0,number,0}" />
	<display:column property="yellowSum" title="Yellow(46-90)" total="true"
		format="{0,number,0}" />
	<display:column property="redSum" title="Red(91+)" total="true"
		format="{0,number,0}" />

</display:table>
