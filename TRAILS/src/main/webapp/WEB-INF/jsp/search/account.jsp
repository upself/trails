<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<script type="text/javascript">
function popupCNDB(accountId) {
newWin=window.open('//${cndbServerName}/OSCAR/ViewDetail.do?method=customer&customerId=' + accountId,'popupWindow','height=600,width=1200,resizable=yes,menubar=yes,status=yes,toolbar=yes,scrollbars=yes'); 
newWin.focus(); 
void(0);
}

function submitEnter(pEvent, pfoInput) {
	var lfoButton = document.getElementById("go-btn");
	var liKeyCode;

	if (window.event) {
		liKeyCode = window.event.keyCode;
	} else if (pEvent) {
		liKeyCode = pEvent.which;
	} else {
		return true;
	}

	if (liKeyCode == 13) {
		lfoButton.click();
		return false;
	} else {
		return true;
	}
}
</script>

<h1>Accounts</h1>
<h4>Search form</h4>
<p class="confidential">IBM Confidential</p>
<br />
<p>Use this form to search for an account within TRAILS. The search
string must contain at least 2 characters. You must select to search on
account name or an account number. To search on out of scope accounts,
click on the corresponding check box. Click on "Go" to execute the
search. Required fields are marked with an asterisk(*).</p>
<div class="hrule-dots"></div>
<br />
<s:form action="accounts" method="post" namespace="/search"
	theme="simple">
	<s:if test="hasErrors()">
		<s:actionerror />
		<s:fielderror />
	</s:if>
	<table cellspacing="0" cellpadding="0" class="basic-table">
		<tr>
			<td><label for="search_for">*Search for:</label> 
			<s:textfield name="searchAccount.searchString" id="search_for" onkeypress="return submitEnter(event, this)"/> 
				 <span class="button-blue">
			<s:submit method="search" value="GO"  alt="Search account"/> </span></td>
		</tr>
		<tr>
			<td><s:checkbox label="Search account names"
				name="searchAccount.nameSearch" value="true"  /> <label
				for="accounts_searchAccount_nameSearch">Search account names</label>
			</td>
		</tr>
		<tr>
			<td><s:checkbox label="Search account numbers"
				name="searchAccount.accountNumberSearch" value="true" /> <label
				for="accounts_searchAccount_accountNumberSearch">Search
			account numbers</label></td>
		</tr>
		<tr>
			<td><s:checkbox label="Search out of scope accounts"
				name="searchAccount.outOfScopeSearch" /> <label
				for="accounts_searchAccount_outOfScopeSearch">Include out of
			scope accounts</label></td>
		</tr>
	</table>
</s:form>
<div class="hrule-dots"></div>
<br />

<display:table name="accountSearch" class="basic-table" id="row"
	decorator="com.ibm.tap.trails.framework.DisplayTagDecorator"
	cellspacing="1" cellpadding="0" summary="Search results" requestURI="accounts.htm">
	<display:setProperty name="css.header.tr" value="gray-med" />
	<display:caption media="html">TRAILS results for:
<s:property value="searchAccount.searchString" />
	</display:caption>
	<display:column sortProperty="scope" title="Scope" sortable="true"
		class="scope" value="" />
	<display:column property="accountName" title="Name" sortable="true"
		href="/TRAILS/account/home.htm" paramId="accountId"
		paramProperty="accountId" />
	<display:column property="dept" title="Dept." sortable="true" />
	<display:column property="sector" title="Sector" sortable="true" />
	<display:column property="type" title="Type" sortable="true" />
	<display:column property="dpe" title="DPE" sortable="true" />
	<display:column title="Account #" sortable="true">
		<a
			href="javascript:popupCNDB(<s:property value="%{#attr.row.accountId}"/>)">
		${row.account}</a>
	</display:column>
</display:table>