<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>
	
	<div class="indent">
		<h3>
			IP Address
			<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif" width="14" height="14" alt="contextual field help icon"/>
		</h3>
	</div>
	<display:table id="ipAddress" name="softwareLparIPAddress" requestURI="" class="bravo">
		<display:setProperty name="basic.empty.showtable" value="true" />
		<display:column title="Gateway <BR />&nbsp;&nbsp; Instance ID" headerClass="blue-med">
	        <c:out value="${ipAddress.gateway}"/>
	        <br />&nbsp;&nbsp;
	        <c:out value="${ipAddress.instanceId}"/>
	    </display:column>
	    <display:column title="Domain<br />&nbsp;&nbsp;Host Name" headerClass="blue-med">
	        <c:out value="${ipAddress.ipDomain}"/>
	        <br />&nbsp;&nbsp;
	        <c:out value="${ipAddress.ipHostName}"/>
	    </display:column>
		<display:column title="IP Address<br />&nbsp;&nbsp;IP V6 Address" headerClass="blue-med">
	        <c:out value="${ipAddress.ipAddress}"/>
   	        <br />&nbsp;&nbsp;
   	        <c:out value="${ipAddress.ipv6Address}"/>
	    </display:column>
		<display:column title="IP Subnet<br />&nbsp;&nbsp;Permanent Mac Address" headerClass="blue-med">
	        <c:out value="${ipAddress.ipSubnet}"/>
   	        <br />&nbsp;&nbsp;
   	        <c:out value="${ipAddress.permMacAddress}"/>
	    </display:column>
	    <display:column title="Primary DNS<br />&nbsp;&nbsp;Secondary DNS" headerClass="blue-med">
	        <c:out value="${ipAddress.primaryDNS}"/>
   	        <br />&nbsp;&nbsp;
   	        <c:out value="${ipAddress.secondaryDNS}"/>
	    </display:column>
	    <display:column title="DHCP" headerClass="blue-med">
	        <c:out value="${ipAddress.isDHCP}"/>
	    </display:column>
	</display:table>