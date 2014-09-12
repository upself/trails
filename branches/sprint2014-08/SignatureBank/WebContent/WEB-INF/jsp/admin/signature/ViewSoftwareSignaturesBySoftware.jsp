<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<h1>Manage By Software: <span class="orange-dark"><bean:write
	name="user.container" property="product.name" /></span></h1>

<div id="fourth-level">

<ul class="text-tabs">
	<li><html:link page="/SoftwareFilter.do">Filters</html:link>
	|</li>
	<li><html:link page="/SoftwareFilterSearchSetup.do">Search Filters</html:link>
	|</li>
	<li><html:link page="/SoftwareFilterMove.do">Manage Filters</html:link>
	|</li>
	<li><html:link page="/SoftwareSignature.do" styleClass="active">Sigs</html:link>
	|</li>
	<li><html:link page="/SoftwareSignatureSearchSetup.do">Search Sigs</html:link>
	|</li>
	<li><html:link page="/SoftwareSignatureMove.do">Manage Sigs</html:link>
	|</li>
	<li><html:link page="/AddSoftwareSignature.do">Add Signature</html:link>
	</li>
</ul>
</div>

<h2>Software Signature Listing</h2>
<br>
<p>The following is a list of software signatures used to discover this product.</p>
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
		<display:caption>Assigned Software Signatures</display:caption>
		<display:column title="Status" property="statusImage"
			headerClass="blue-med" />
		<display:column title="File Name" property="fileName" style="white-space:pre;"
			headerClass="blue-med"
			href="/SignatureBank/UpdateSoftwareSignature.do" paramId="id"
			paramProperty="softwareSignatureId" />
		<display:column title="File Size" property="fileSize"
			headerClass="blue-med" />
		<display:column title="Version" property="softwareVersion"
			headerClass="blue-med" />
		<display:column title="CRC" headerClass="blue-med">
			<c:out value="${row.checksumQuick}" />
			<c:out value="${row.checksumCrc32}" />
			<c:out value="${row.checksumMd5}" />
		</display:column>
		<display:column title="Last Editor" property="remoteUser"
			headerClass="blue-med" />
	</display:table>
</div>
<!-- stop main content -->
</div>
<!-- stop content -->
