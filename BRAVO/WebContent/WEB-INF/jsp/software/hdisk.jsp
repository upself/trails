<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>
	
	<div class="indent">
		<h3>
			Hard Disk
			<html:link page="/help/help.do#H7">
			<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif" width="14" height="14" alt="contextual field help icon"/>
			</html:link>
		</h3>
	</div>
	<display:table id="hdisk" name="softwareLparHDisk" requestURI="" class="bravo">
		<display:setProperty name="basic.empty.showtable" value="true" />
	    <display:column property="manufacturer" title="Manufacturer" 
	   		headerClass="blue-med" />
		<display:column property="model" title="Model" headerClass="blue-med" />
		<display:column property="serialNumber" title="Serial Number" 
			headerClass="blue-med" />
	    <display:column property="storageType" title="Storage Type" 
	    	headerClass="blue-med" />
		<display:column property="size" title="Size" 
			headerClass="blue-med-ralign" style="text-align: right" />
	</display:table>