<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>
	
	<div class="indent">
		<h3>
			Processor
			<html:link page="/help/help.do#H7">
			<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif" width="14" height="14" alt="contextual field help icon"/>
			</html:link>
		</h3>
	</div>
	<display:table id="processor" name="softwareLparProcessor" requestURI="" class="ibm-data-table ibm-sortable-table ibm-alternate-two">
		<display:setProperty name="basic.empty.showtable" value="true" />
	    <display:column title="Bus Speed <BR />&nbsp;&nbsp; Cache" headerClass="blue-med">
	        <c:out value="${processor.busSpeed}"/>
   	        <br />&nbsp;&nbsp;
	        <c:out value="${processor.cache}"/>   	        
	    </display:column>
		<display:column title="Current Speed <BR />&nbsp;&nbsp; Max Speed" headerClass="blue-med">
	        <c:out value="${processor.currentSpeed}"/>
   	        <br />&nbsp;&nbsp;
	        <c:out value="${processor.maxSpeed}"/>
	    </display:column>
		<display:column title="Manufacturer <BR />&nbsp;&nbsp; Model" headerClass="blue-med">
	        <c:out value="${processor.manufacturer}"/>
   	        <br />&nbsp;&nbsp;
	        <c:out value="${processor.model}"/>
	    </display:column>
	    <display:column title="Num of boards <BR />&nbsp;&nbsp; Num of Modules" headerClass="blue-med">
	        <c:out value="${processor.numBoards}"/>
	        <br />&nbsp;&nbsp;
	        <c:out value="${processor.numModules}"/>
	    </display:column>
	    <display:column title="Processor Num<BR />&nbsp;&nbsp; PVU" headerClass="blue-med">
	        <c:out value="${processor.processorNum}"/>
	        <br />&nbsp;&nbsp;
	        <c:out value="${processor.pvu}"/>
	    </display:column>
	    <display:column title="Serial Number<BR />&nbsp;&nbsp; Active" headerClass="blue-med">
	        <c:out value="${processor.serialNumber}"/>
	        <br />&nbsp;&nbsp;
	        <c:out value="${processor.isActive}"/>
	    </display:column>
	</display:table>