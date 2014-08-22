<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<h1>Manage By Software: <span class="orange-dark"><bean:write
	name="user.container" property="product.name" /></span></h1>

<div id="fourth-level">

<ul class="text-tabs">
	<li><html:link page="/SoftwareFilter.do" styleClass="active">Filters</html:link>
	|</li>
	<li><html:link page="/SoftwareSignature.do">Sigs</html:link></li>
</ul>
</div>

<h2>Software Filter Listing</h2>
<br>
<p>The following is a list of software filters used to discover this
product.</p>
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>

<display:table id="row" name="report" class="bravo" defaultsort="2"
	defaultorder="descending">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:caption>Assigned Software Filters</display:caption>
	<display:column title="Status" property="statusImage"
		headerClass="blue-med" />
	<display:column title="Filter Name" property="softwareName" style="white-space:pre;"
		headerClass="blue-med" />
	<display:column title="Filter Version" property="softwareVersion"
		headerClass="blue-med" />
	<display:column title="Map Version" property="mapSoftwareVersion"
		headerClass="blue-med" />
	<display:column title="Last Editor" property="remoteUser"
		headerClass="blue-med" />
</display:table>