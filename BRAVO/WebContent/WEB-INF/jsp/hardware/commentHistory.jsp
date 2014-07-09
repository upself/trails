<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>

	<div class="indent">
		<h3>
			Comment History
			<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif" width="14" height="14" alt="contextual field help icon"/>
		</h3>
	</div>
	<display:table name="commentList" requestURI="" class="ibm-data-table ibm-sortable-table ibm-alternate-two">
		<display:setProperty name="basic.empty.showtable" value="true"/>
		
		<display:column property="action" title="Action" headerClass="blue-med"/>
		<display:column property="remoteUser" title="User" headerClass="blue-med"/>
		<display:column property="recordTime" title="Record Time" headerClass="blue-med"/>
		<display:column property="comment" title="Comment" headerClass="blue-med"/>
	</display:table>
	