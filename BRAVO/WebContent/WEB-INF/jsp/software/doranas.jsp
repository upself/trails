<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>

	<div class="indent">
		<h3>
			Dorana Products
			<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif" width="14" height="14" alt="contextual field help icon"/>
		</h3>
	</div>
	<display:table name="doranaList" requestURI="" class="bravo" id="small">
		<display:setProperty name="basic.empty.showtable" value="true"/>
		
		<display:column property="doranaProduct.doranaProduct" title="Dorana Product Name" headerClass="blue-med"/>
		<display:column property="doranaProduct.version" title="Version" headerClass="blue-med"/>
	</display:table>
	