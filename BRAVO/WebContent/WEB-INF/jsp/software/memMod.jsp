<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>
	
	<div class="indent">
		<h3>
			Memory Module
			<html:link page="/help/help.do#H7">
			<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif" width="14" height="14" alt="contextual field help icon"/>
			</html:link>
		</h3>
	</div>
	<display:table id="memMod" name="softwareLparMemMod" requestURI="" class="ibm-data-table ibm-sortable-table ibm-alternate-two">
		<display:setProperty name="basic.empty.showtable" value="true" />
	    <display:column property="socketName" title="Socket Name" headerClass="blue-med" />
	    <display:column property="memoryType" title="Memory Type" headerClass="blue-med" />
		<display:column property="packaging" title="Packaging" headerClass="blue-med" />
		<display:column property="moduleSize" title="Size" 
			headerClass="blue-med-ralign" style="text-align: right" />
		<display:column property="maxModuleSize" title="Max Size" 
			headerClass="blue-med-ralign" style="text-align: right" />
		<display:column property="instMemId" title="No. of modules" 
			headerClass="blue-med-ralign" style="text-align: right" />
	</display:table>