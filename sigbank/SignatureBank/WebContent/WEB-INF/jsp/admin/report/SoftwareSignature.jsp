<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1><bean:write name="month" />, <bean:write name="year" />
Software Signature history</h1>
<br>

<display:table id="row" name="report" class="bravo" defaultsort="1"
	defaultorder="ascending" requestURI="">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:caption>Software Signatures</display:caption>
	<display:column title="Ref ID"
		property="softwareSignature.softwareSignatureId" headerClass="blue-med"
		group="1" />
	<display:column title="File Name" property="fileName"
		headerClass="blue-med" />
	<display:column title="File Size" property="fileSize"
		headerClass="blue-med" />
	<display:column title="Product" property="product.name"
		headerClass="blue-med" />
	<display:column title="TCM ID" property="tcmId" headerClass="blue-med" />
	<display:column title="Software Version" property="softwareVersion"
		headerClass="blue-med" />
	<display:column title="Signature Source" property="signatureSource"
		headerClass="blue-med" />
	<display:column title="Checksum Quick" property="checksumQuick"
		headerClass="blue-med" />
	<display:column title="Checksum CRC32" property="checksumCrc32"
		headerClass="blue-med" />
	<display:column title="Checksum MD5" property="checksumMd5"
		headerClass="blue-med" />
	<display:column title="End of support" property="endOfSupport"
		headerClass="blue-med" />
	<display:column title="Operating System" property="osType"
		headerClass="blue-med" />
	<display:column title="Justification" property="changeJustification"
		headerClass="blue-med" />
	<display:column title="Comments" property="comments"
		headerClass="blue-med" />
	<display:column title="Editor" property="remoteUser"
		headerClass="blue-med" />
	<display:column title="Edit Time" property="recordTime"
		headerClass="blue-med" format="{0,date,MM-dd-yyyy}"/>
	<display:column title="Status" property="status" headerClass="blue-med" />
</display:table>

</div>
<!-- stop main content -->

</div>
<!-- stop content -->

