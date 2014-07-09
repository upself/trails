<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>

	<div class="indent">
		<h3>
			TADZ Products
			<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif" width="14" height="14" alt="contextual field help icon"/>
		</h3>
	</div>
	<display:table name="tadzList" requestURI="" class="ibm-data-table ibm-sortable-table ibm-alternate-two" id="small">
		<display:setProperty name="basic.empty.showtable" value="true"/>	

	  	<display:column property="softwareItem.name" title="FEATURE NAME" headerClass="blue-med"/>
 	  
 	    <display:column  title="MANUFACTURER" headerClass="blue-med">
 	    <c:if test="${small.softwareItem.mainframeVersion ne null}">
		<c:out value="${small.softwareItem.mainframeVersion.manufacturer.manufacturerName}"/>
		</c:if>
		<c:if test="${small.softwareItem.mainframeFeature ne null}">
		<c:out value="${small.softwareItem.mainframeFeature.version.manufacturer.manufacturerName}"/>
		</c:if>
		</display:column>
		<display:column title="Version" headerClass="blue-med">
		    <c:if test="${small.softwareItem.mainframeVersion ne null}">
		<c:out value="${small.softwareItem.mainframeVersion.version}"/>
		</c:if>
		<c:if test="${small.softwareItem.mainframeFeature ne null}">
		<c:out value="${small.softwareItem.mainframeFeature.version.version}"/>
		</c:if>
		</display:column>
	    <display:column property="useCount" title="USEcn" headerClass="blue-med"/>
	    <display:column property="lastUsed" title="LastUP" headerClass="blue-med"/>
	</display:table>
