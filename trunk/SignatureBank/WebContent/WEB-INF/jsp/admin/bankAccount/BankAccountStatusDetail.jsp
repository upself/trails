<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<h1>Bank Account Status detail</h1>
<br>


<display:table id="row" name="bankAccount" class="bravo" requestURI="">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:column title="Connection status" property="connectionStatus"
		headerClass="blue-med" />
	<display:column title="Error" headerClass="blue-med"
		property="comments" />
</display:table>
<br>

<a
	href="http://tap2.raleigh.ibm.com/reports/temp/staging/mapping/<bean:write name="bankAccount" property="name"/>.tsv">Unmapped
computers</a>

</div>
<!-- stop main content -->

</div>
<!-- stop content -->

