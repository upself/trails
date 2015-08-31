<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<table class="basic-table" cellspacing="0" cellpadding="0">
	<s:iterator value="alertSummary">
		<s:if test="type == 'ALERT'">
			<s:if test="code == 'HARDWARE'">
				<s:url id="alertUrl" namespace="/account/alerts"
					action="alertHardware" includeParams="none" />
			</s:if>
			<s:if test="code == 'HARDWARE_LPAR'">
				<s:url id="alertUrl" namespace="/account/alerts"
					action="alertHardwareLpar" includeParams="none" />
			</s:if>
			<s:if test="code == 'SOFTWARE_LPAR'">
				<s:url id="alertUrl" namespace="/account/alerts"
					action="alertSoftwareLpar" includeParams="none" />
			</s:if>
			<s:if test="code == 'EXPIRED_SCAN'">
				<s:url id="alertUrl" namespace="/account/alerts"
					action="alertExpiredScan" includeParams="none" />
			</s:if>
			<s:if test="code == 'UNLICENSED_IBM_SW'">
				<s:url id="alertUrl" namespace="/account/alerts"
					action="alertUnlicensedIbmSw" includeParams="none" />
			</s:if>
			<s:if test="code == 'UNLICENSED_ISV_SW'">
				<s:url id="alertUrl" namespace="/account/alerts"
					action="alertUnlicensedIsvSw" includeParams="none" />
			</s:if>
			<s:if test="code == 'EXPIRED_MAINT'">
				<s:url id="alertUrl" namespace="/account/alerts"
					action="alertExpiredMaint" includeParams="none" />
			</s:if>
			<s:if test="code == 'SWIBM'">
				<s:url id="alertUrl" namespace="/account/alerts"
					action="alertIbmSwInstancesReviewed" includeParams="none" />
			</s:if>
			<s:if test="code == 'SWISVNPR'">
				<s:url id="alertUrl" namespace="/account/alerts"
					action="alertPriorityIsvSwInstancesReviewed" includeParams="none" />
			</s:if>
			<s:if test="code == 'HWCFGDTA'">
				<s:url id="alertUrl" namespace="/account/alerts"
					action="alertHardwareCfgData" includeParams="none" />
			</s:if>
			<s:if test="code == 'SWISCOPE'">
				<s:url id="alertUrl" namespace="/account/alerts"
					action="alertWithDefinedContractScope" includeParams="none" />
			</s:if>
			<tr>
				<td><s:property value="total" /></td>
				<td><s:a href="%{alertUrl}">
					<s:property value="name" />
				</s:a></td>
			</tr>
		</s:if>
		<s:else>
			<s:url id="alertUrl" namespace="/account/exceptions"
				action="lpar%{code}" includeParams="none" />
			<tr>
				<td><s:property value="total" /></td>
				<td><s:a href="%{alertUrl}">
					<s:property value="name" />
				</s:a></td>
			</tr>
		</s:else>
	</s:iterator>
</table>