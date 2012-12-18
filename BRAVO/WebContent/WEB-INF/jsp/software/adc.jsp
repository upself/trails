<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>
	
	<div class="indent">
		<h3>
			ADC 
			<html:link page="/help/help.do#H7">
			<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif" width="14" height="14" alt="contextual field help icon"/>
			</html:link>
		</h3>
	</div>
	<display:table id="adc" name="softwareLparADC" requestURI="" class="bravo">
		<display:setProperty name="basic.empty.showtable" value="true" />
	    <display:column title="Customer <BR />&nbsp;&nbsp; GU" headerClass="blue-med">
	        <c:out value="${adc.cust}"/>
   	        <br />&nbsp;&nbsp;
	        <c:out value="${adc.gu}"/>   	        
	    </display:column>
		<display:column title="EP Name <BR />&nbsp;&nbsp; EP OID" headerClass="blue-med">
	        <c:out value="${adc.epName}"/>
   	        <br />&nbsp;&nbsp;
	        <c:out value="${adc.epOid}"/>
	    </display:column>
		<display:column title="IP Address <BR />&nbsp;&nbsp; Loc" headerClass="blue-med">
	        <c:out value="${adc.ipAddress}"/>
   	        <br />&nbsp;&nbsp;
	        <c:out value="${adc.loc}"/>
	    </display:column>
	    <display:column title="Server Type <BR />&nbsp;&nbsp; SESDR BP Using" headerClass="blue-med">
	        <c:out value="${adc.serverType}"/>
	        <br />&nbsp;&nbsp;
	        <c:out value="${adc.sesdrBpUsing}"/>
	    </display:column>
	    <display:column title="SESDR Location <BR />&nbsp;&nbsp; SESDR SystID" headerClass="blue-med">
	        <c:out value="${adc.sesdrLocation}"/>
	        <br />&nbsp;&nbsp;
	        <c:out value="${adc.sesdrSystId}"/>
	    </display:column>
	</display:table>