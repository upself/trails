<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>

<br>
<br>
<br>
View archived price reports:
<hr>
<html:form action="/PriceReportArchive.do">
	<table border="0" cellpadding="2" cellspacing="0">
		<html:hidden name="priceReportCycle" property="customerId" />
		<tr>
			<td><html:select name="priceReportCycle"
				property="priceReportCycleId">
				<html:option value="0">Current</html:option>
				<html:optionsCollection name="priceReportCycleList" label="recordTime" value="priceReportCycleId"/>
			</html:select></td>
		</tr>
	</table>
	<html:submit>Go</html:submit>
</html:form>
