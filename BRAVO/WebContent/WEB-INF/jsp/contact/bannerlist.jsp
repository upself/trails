<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>


	<div class="indent">
		<h3>
			Click on Icon to Remove from Contact List
		</h3>
	</div>
	<display:table name="contactList" requestURI="" class="bravo">
		<display:setProperty name="basic.empty.showtable" value="true"/>
		
		<display:column value="${imageTag}" title="" href="/BRAVO/contact/edit.do?lparName=${lparName}&accountId=${accountId}&context=${context}&customerid=${customerid}" paramId="id" paramProperty="contact.id" headerClass="blue-med" />
		<display:column property="contact.id" title="ID" headerClass="blue-med" />
		<display:column property="contact.name" title="NAME" headerClass="blue-med" />
	  	<display:column property="contact.serial" title="SERIAL" headerClass="blue-med"/>
	  	<display:column property="contact.serialMgr1" title="1st Line Mgr" headerClass="blue-med"/>
	  	<display:column property="contact.serialMgr2" title="2nd Line Mgr" headerClass="blue-med"/>
	  	<display:column property="contact.serialMgr3" title="3rd Line Mgr" headerClass="blue-med"/>
	  	<display:column property="contact.isManager" title="Is Manager" headerClass="blue-med"/>
	</display:table>
	