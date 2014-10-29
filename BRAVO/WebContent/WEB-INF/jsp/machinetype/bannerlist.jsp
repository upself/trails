<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>
	
	<display:table name="list" requestURI="" class="ibm-data-table ibm-sortable-table ibm-alternate-two" id="small">
		<display:setProperty name="basic.empty.showtable" value="true"/>
		
		<display:column property="statusImage" title="" headerClass="purple" class="status"/>
	  	<display:column property="name" title="Name" href="/BRAVO/admin/machinetype/view.do?action=View&searchtype=${searchtype}&search=${search}" paramId="id" paramProperty="id" sortable="true" headerClass="purple"/>
	  	<display:column property="type" title="Type" headerClass="purple"/>
	</display:table>
	