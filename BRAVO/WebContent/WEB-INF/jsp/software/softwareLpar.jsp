<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>

	<c:if test="${displayOS}">
	<display:table id="os" name="software" requestURI="" class="ibm-data-table ibm-sortable-table ibm-alternate-two">
		<display:setProperty name="basic.empty.showtable" value="true" />
	    <display:column title="OS Name" headerClass="blue-med">
	        <c:out value="${os.softwareLpar.osName}"/>
	    </display:column>
		<display:column title="OS Type" headerClass="blue-med">
	        <c:out value="${os.softwareLpar.osType}"/>
	    </display:column>
		<display:column title="Major Version" headerClass="blue-med">
	        <c:out value="${os.softwareLpar.osMajorVersion}"/>
	    </display:column>
		<display:column title="Minor Version" headerClass="blue-med">
	        <c:out value="${os.softwareLpar.osMinorVersion}"/>
	    </display:column>
		<display:column title="Sub Version" headerClass="blue-med">
	        <c:out value="${os.softwareLpar.osSubVersion}"/>
	    </display:column>
		<display:column title="Install Date" headerClass="blue-med">
	        <c:out value="${os.softwareLpar.osInstallDate}"/>
	    </display:column>
	</display:table>
	</c:if>

	<c:if test="${displayBios}">
	<display:table id="bios" name="software" requestURI="" class="ibm-data-table ibm-sortable-table ibm-alternate-two">
		<display:setProperty name="basic.empty.showtable" value="false" />
	    <display:column title="Bios Manufacturer" headerClass="blue-med">
	        <c:out value="${bios.softwareLpar.biosManufacturer}"/>
	    </display:column>
	    <display:column title="Bios Model" headerClass="blue-med">
	        <c:out value="${bios.softwareLpar.biosModel}"/>
	    </display:column>
	    <display:column title="Bios Date" headerClass="blue-med">
	        <c:out value="${bios.softwareLpar.biosDate}"/>
	    </display:column>
	    <display:column title="Bios Serial Number" headerClass="blue-med">
	        <c:out value="${bios.softwareLpar.biosSerialNumber}"/>
	    </display:column>
	    <display:column title="Bios Unique ID" headerClass="blue-med">
	        <c:out value="${bios.softwareLpar.biosUniqueId}"/>
	    </display:column>
	</display:table>
	</c:if>
	
	<c:if test="${displayMisc}">
	<display:table id="lpar" name="software" requestURI="" class="ibm-data-table ibm-sortable-table ibm-alternate-two">
		<display:setProperty name="basic.empty.showtable" value="true" />
	    <display:column title="Server Type" headerClass="blue-med">
	        <c:out value="${lpar.softwareLpar.serverType}"/>
	    </display:column>
	    <display:column title="Disk" headerClass="blue-med">
	        <c:out value="${lpar.softwareLpar.disk}"/>
	    </display:column>
	    <display:column title="Board Serial" headerClass="blue-med">
	        <c:out value="${lpar.softwareLpar.boardSerial}"/>
	    </display:column>
	    <display:column title="Case Serial" headerClass="blue-med">
	        <c:out value="${lpar.softwareLpar.caseSerial}"/>
	    </display:column>
	    <display:column title="Case Asset Tag" headerClass="blue-med">
	        <c:out value="${lpar.softwareLpar.caseAssetTag}"/>
	    </display:column>
	</display:table>
	</c:if>

	<c:if test="${displayProcessors}">	
	<display:table id="processors" name="software" requestURI="" class="ibm-data-table ibm-sortable-table ibm-alternate-two">
		<display:setProperty name="basic.empty.showtable" value="true" />
	    <display:column title="Dedicated Processors" headerClass="blue-med">
	        <c:out value="${processors.softwareLpar.dedicatedProcessors}"/>
	    </display:column>
	    <display:column title="Total Processors" headerClass="blue-med">
	        <c:out value="${processors.softwareLpar.totalProcessors}"/>
	    </display:column>
	    <display:column title="Shared Processors" headerClass="blue-med">
	        <c:out value="${processors.softwareLpar.sharedProcessors}"/>
	    </display:column>
	    <display:column title="Processor Type" headerClass="blue-med">
	        <c:out value="${processors.softwareLpar.processorType}"/>
	    </display:column>
	    <display:column title="Shared Proc By Cores" headerClass="blue-med">
	        <c:out value="${processors.softwareLpar.sharedProcByCores}"/>
	    </display:column>
	    <display:column title="Dedicated Proc By Cores" headerClass="blue-med">
	        <c:out value="${processors.softwareLpar.dedicatedProcByCores}"/>
	    </display:column>
	    <display:column title="Total Proc By Cores" headerClass="blue-med">
	        <c:out value="${processors.softwareLpar.totalProcByCores}"/>
	    </display:column>
	</display:table>
	</c:if>

	<c:if test="${displayMemory}">
	<display:table id="lparMemory" name="software" requestURI="" class="ibm-data-table ibm-sortable-table ibm-alternate-two">
		<display:setProperty name="basic.empty.showtable" value="true" />
	    <display:column title="Memory" headerClass="blue-med">
	        <c:out value="${lparMemory.softwareLpar.memory}"/>
	    </display:column>
	    <display:column title="Physical Total (KB)" headerClass="blue-med">
	        <c:out value="${lparMemory.softwareLpar.physicalTotalKB}"/>
	    </display:column>
	    <display:column title="Virtual Memory" headerClass="blue-med">
	        <c:out value="${lparMemory.softwareLpar.virtualMemory}"/>
	    </display:column>
	    <display:column title="Physical Free Memory" headerClass="blue-med">
	        <c:out value="${lparMemory.softwareLpar.physicalFreeMemory}"/>
	    </display:column>
	    <display:column title="Virtual Free Memory" headerClass="blue-med">
	        <c:out value="${lparMemory.softwareLpar.virtualFreeMemory}"/>
	    </display:column>
	    <display:column title="Node Capacity" headerClass="blue-med">
	        <c:out value="${lparMemory.softwareLpar.nodeCapacity}"/>
	    </display:column>
	    <display:column title="LPAR Capacity" headerClass="blue-med">
	        <c:out value="${lparMemory.softwareLpar.lparCapacity}"/>
	    </display:column>
	</display:table>
	</c:if>