<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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
			<c:if test="${lpar.hardwareLpar.hardware.machineType.type == 'MAINFRAME'}">
				<th class="blue-med">CPU MIPS</th>
				<th class="blue-med">CPU MSU</th>
				<th class="blue-med">Part MIPS</th>
				<th class="blue-med">Part MSU</th>
			</c:if>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><img src="<c:out value="${lpar.hardwareLpar.hardware.statusIcon}"/>"
				width="12" height="10" /></td>
			<td><font class="orange-dark"><c:out
						value="${lpar.hardwareLpar.hardware.country}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${lpar.hardwareLpar.hardware.machineType.type}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${lpar.hardwareLpar.hardware.machineType.name}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${lpar.hardwareLpar.hardware.serial}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${lpar.hardwareLpar.hardware.processorManufacturer}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${lpar.hardwareLpar.hardware.mastProcessorType}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${lpar.hardwareLpar.hardware.processorModel}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${lpar.hardwareLpar.hardware.nbrCoresPerChip}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${lpar.hardwareLpar.hardware.chips}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${lpar.hardwareLpar.hardware.processorCount}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${lpar.hardwareLpar.hardware.nbrOfChipsMax}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${lpar.hardwareLpar.hardware.shared}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${lpar.hardwareLpar.hardware.owner}" /></font></td>
			<td><font class="orange-dark"><c:out
						value="${hardware.hardwareStatus}" /></font></td>
			<c:if test="${lpar.hardwareLpar.hardware.machineType.type == 'MAINFRAME'}">
				<td><font class="orange-dark"><c:out
							value="${lpar.hardwareLpar.hardware.cpuMIPS}" /></font></td>
				<td><font class="orange-dark"><c:out
							value="${lpar.hardwareLpar.hardware.cpuMSU}" /></font></td>
				<td><font class="orange-dark"><c:out
							value="${lpar.hardwareLpar.hardware.partMIPS}" /></font></td>
				<td><font class="orange-dark"><c:out
							value="${lpar.hardwareLpar.hardware.partMSU}" /></font></td>
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
				test="${lpar.hardwareLpar.hardware.machineType.type == 'MAINFRAME'}">
				<th class="blue-med">CPU MIPS</th>
				<th class="blue-med">CPU MSU</th>
				<th class="blue-med">Part MIPS</th>
				<th class="blue-med">Part MSU</th>
			</c:if>
		</tr>
	</thead>
	<tbody>
		<tr>
			<c:choose>
				<c:when test="${lpar.hardwareLpar == null}">
					<td colspan="7" align="center"><font class="orange-dark">
							<html:link
								page="/hardware/lpar/create.do?accountId=${account.customer.accountNumber}&lparName=${lpar.name}">
							No Hardware Record
						</html:link>
					</font></td>
				</c:when>
				<c:otherwise>
					<td><c:choose>
							<c:when test="${lpar.hardwareLpar.status == 'ACTIVE'}">
								<img alt="ACTIVE"
									src="<c:out value="${lpar.hardwareLpar.statusIcon}"/>"
									width="12" height="10" />
							</c:when>
							<c:otherwise>
								<img alt="INACTIVE"
									src="<c:out value="${lpar.hardwareLpar.statusIcon}"/>"
									width="12" height="10" />
							</c:otherwise>
						</c:choose></td>
					<td><font class="orange-dark"> <html:link
								page="/hardware/home.do?lparId=${lpar.hardwareLpar.id}">
								<c:out value="${lpar.hardwareLpar.name}" />
							</html:link>
					</font></td>
					
					<td><font class="orange-dark"><c:out
								value="${lpar.hardwareLpar.hardware.serverType}" /> </font></td>
					<td><font class="orange-dark"><c:out
								value="${lpar.hardwareLpar.hardware.processorCount}" /> </font></td>
					<td><font class="orange-dark"><c:out
								value="${lpar.hardwareLpar.sysplex}" /> </font></td>
					<td><font class="orange-dark"><c:out
								value="${lpar.hardwareLpar.spla}" /> </font></td>
					<td><font class="orange-dark"><c:out
								value="${lpar.hardwareLpar.internetIccFlag}" /> </font></td>
					<td><font class="orange-dark"><c:out
								value="${lpar.hardwareLpar.lparStatus}" /> </font></td>
					<td><font class="orange-dark"><c:out
								value="${lpar.hardwareLpar.extId}" /> </font></td>
					<td><font class="orange-dark"><c:out
								value="${lpar.hardwareLpar.techImageId}" /> </font></td>					
					<c:if
						test="${lpar.hardwareLpar.hardware.machineType.type == 'MAINFRAME'}">
						<td><font class="orange-dark"><c:out
									value="${lpar.hardwareLpar.hardware.cpuMIPS}" /> </font></td>
						<td><font class="orange-dark"><c:out
									value="${lpar.hardwareLpar.hardware.cpuMSU}" /> </font></td>
						<td><font class="orange-dark"><c:out
									value="${lpar.hardwareLpar.partMIPS}" /> </font></td>
						<td><font class="orange-dark"><c:out
									value="${lpar.hardwareLpar.partMSU}" /> </font></td>
					</c:if>
				</c:otherwise>
			</c:choose>
		</tr>
	</tbody>
</table>
