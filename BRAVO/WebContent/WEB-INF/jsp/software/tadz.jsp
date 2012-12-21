<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>

	<div class="indent">
		<h3>
			TADZ Products
			<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif" width="14" height="14" alt="contextual field help icon"/>
		</h3>
	</div>
	<display:table name="tadzList" requestURI="" class="bravo" id="small">
		<display:setProperty name="basic.empty.showtable" value="true"/>	
 
	  	<display:column property="softwareItem.name" title="FEATURE NAME" headerClass="blue-med"/>
	    <display:column property="softwareItem.mainframeVersion.manufacturer.manufacturerName" title="MANUFACTURER" headerClass="blue-med"/>
		<display:column property="softwareItem.mainframeVersion.version" title="Version" headerClass="blue-med"/>
		<display:column property="softwareItem.mainframeFeature.eId" title="EID" headerClass="blue-med"/> 
	    <display:column property="useCount" title="USEcn" headerClass="blue-med"/>
	    <display:column property="lastUsed" title="LastUP" headerClass="blue-med"/>
	</display:table>
