<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>

<div class="indent">
	<h3>
		Hardware <img
			src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
			width="14" height="14" alt="contextual field help icon" />
	</h3>
</div>
<table class="bravo" id="small">
	<thead>
		<tr>
			<th class="blue-med" width="1%"></th>
			<th class="blue-med">Country</th>
			<th class="blue-med">Asset Type</th>
			<th class="blue-med">Machine Type</th>
			<th class="blue-med">Serial</th>
			<th class="blue-med">Proc mfg</th>
			<th class="blue-med">Proc type</th>
			<th class="blue-med">Proc model</th>
			<th class="blue-med">Cores per chip</th>
			<th class="blue-med">HW chip</th>
			<th class="blue-med">HW proc</th>
			<th class="blue-med"># chips max</th>
			<th class="blue-med">Shared</th>
			<th class="blue-med">HW Owner</th>
			<th class="blue-med">ATP Status</th>
			<c:if test="${hardware.assetType == 'MAINFRAME'}">
				<th class="blue-med">CPU MIPS</th>
				<th class="blue-med">CPU MSU</th>
			</c:if>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><img src="<c:out value="${hardware.statusIcon}"/>"
				width="12" height="10" /></td>		
			<td><font class="orange-dark"><c:out
						value="${hardware.country}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${hardware.assetType}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${hardware.machineType}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${hardware.serial}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${hardware.processorManufacturer}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${hardware.mastProcessorType}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${hardware.processorModel}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${hardware.nbrCoresPerChip}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${hardware.chips}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${hardware.processorCount}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${hardware.nbrOfChipsMax}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${hardware.shared}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${hardware.owner}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${hardware.hardwareStatus}" /></font></td>
			<c:if test="${hardware.assetType == 'MAINFRAME'}">
				<td><font class="orange-dark"><c:out
							value="${hardware.cpuMIPS}" /></font></td>
				<td><font class="orange-dark"><c:out
							value="${hardware.cpuMSU}" /></font></td>
			</c:if>
		</tr>
	</tbody>
</table>
<div class="indent">
	<h3>
		Hardware LPAR
		<html:link page="/help/help.do#H7">
			<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
				width="14" height="14" alt="contextual field help icon" />
		</html:link>
	</h3>
</div>
<table class="bravo" id="small">
	<thead>
		<tr>
			<th class="blue-med" width="1%"></th>
			<th class="blue-med">Name</th>
			<th class="blue-med">Server Type</th>
			<th class="blue-med">Eff Proc</th>
			<th class="blue-med">Sysplex</th>
			<th class="blue-med">SPLA</th>
			<th class="blue-med">Internet Acc</th>
			<th class="blue-med">Lpar Status</th>
			<th class="blue-med">HW_EXT_ID</th>
			<th class="blue-med">HW_TechImgID</th>			
			<c:if
				test="${hardware.assetType == 'MAINFRAME'}">
				<th class="blue-med">Part MIPS</th>
				<th class="blue-med">Part MSU</th>
			</c:if>
		</tr>
	</thead>
	<tbody>
		<tr>	
					<td><c:choose>
							<c:when test="${hardware.status == 'ACTIVE'}">
								<img alt="ACTIVE"
									src="<c:out value="${hardware.lparStatusIcon}"/>"
									width="12" height="10" />
							</c:when>
							<c:otherwise>
								<img alt="INACTIVE"
									src="<c:out value="${hardware.lparStatusIcon}"/>"
									width="12" height="10" />
							</c:otherwise>
						</c:choose></td>
				    <td><font class="orange-dark"> <html:link
						page="/hardware/lpar/update.do?lparId=${hardware.id}">
						<c:out value="${hardware.lparName}" />
					</html:link>
			        </font></td>
					
					<td><font class="orange-dark"><c:out
								value="${hardware.serverType}" /> </font></td>
					<td><font class="orange-dark"><c:out
								value="${hardware.processorCountEff}" /> </font></td>
					<td><font class="orange-dark"><c:out
								value="${hardware.sysplex}" /> </font></td>
					<td><font class="orange-dark"><c:out
								value="${hardware.spla}" /> </font></td>
					<td><font class="orange-dark"><c:out
								value="${hardware.internetIccFlag}" /> </font></td>
					<td><font class="orange-dark"><c:out
								value="${hardware.lparStatus}" /> </font></td>
					<td><font class="orange-dark"><c:out
								value="${hardware.extId}" /> </font></td>
					<td><font class="orange-dark"><c:out
								value="${hardware.techImageId}" /> </font></td>					
					<c:if
						test="${hardware.assetType == 'MAINFRAME'}">
						<td><font class="orange-dark"><c:out
									value="${hardware.partMIPS}" /> </font></td>
						<td><font class="orange-dark"><c:out
									value="${hardware.partMSU}" /> </font></td>
					</c:if>
		</tr>
	</tbody>
</table>