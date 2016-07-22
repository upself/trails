<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<script type="text/javascript">
	function popupCNDB(accountId) {
		/*newWin=window.open('//${cndbServerName}/OSCAR/ViewDetail.do?method=customer&customerId=' + accountId,'popupWindow','height=600,width=1200,resizable=yes,menubar=yes,status=yes,toolbar=yes,scrollbars=yes');*/
		newWin = window
				.open(
						'https://ralbz001073.raleigh.ibm.com/cndbLegacy/faces/home/home.jsp',
						'popupWindow',
						'height=600,width=1200,resizable=yes,menubar=yes,status=yes,toolbar=yes,scrollbars=yes');
		newWin.focus();
		void (0);
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
<div style="padding-left: 10px; width: 100%">
	<s:form action="accounts" method="post" namespace="/search"
		theme="simple">
		<table class="basic-table" cellspacing="0" cellpadding="0">
			<tr>
				<td><s:textfield name="searchAccount.searchString"
						onkeypress="return submitEnter(event, this)"
						id="searchAccount.searchString" /> <s:submit method="search"
						value="GO" id="go-btn" cssClass="ibm-btn-search"
						alt="Search account" /></td>
			</tr>
			<tr>
				<td><s:checkbox label="Search account names"
						name="searchAccount.nameSearch" value="true" /> <label
					for="accounts_searchAccount_nameSearch">Search account
						names</label></td>
			</tr>
			<tr>
				<td><s:checkbox label="Search account numbers"
						name="searchAccount.accountNumberSearch" value="true" /> <label
					for="accounts_searchAccount_accountNumberSearch">Search
						account numbers</label></td>
			</tr>
		</table>
	</s:form>
</div>
<br />

<display:table name="accountSearch"
	class="ibm-data-table ibm-sortable-table" id="row"
	decorator="com.ibm.tap.trails.framework.DisplayTagDecorator"
	cellspacing="1" cellpadding="0" summary="Search results"
	requestURI="accounts.htm">
	<display:setProperty name="css.header.tr" value="gray-med" />
	<display:caption media="html">TRAILS results for:
<s:property value="searchAccount.searchString" />
	</display:caption>
	<display:column property="accountName" title="Name" sortable="true"
		href="/TRAILS/account/home.htm" paramId="accountId"
		paramProperty="accountId" />
	<display:column title="Account #" sortable="true">
		<a href="javascript:popupCNDB(<s:property value="%{#attr.row.accountId}"/>)">${row.account}</a>
	</display:column>
	<display:column title="License Management Scope" sortable="true">
		<s:if test="%{#attr.row.scope == 'yes' || #attr.row.scope == 'YES'}">
			Y
		</s:if>
		<s:else>
			N
		</s:else>
	</display:column>
	<display:column title="Software Tracking Scope" sortable="true">
		<s:if test="%{#attr.row.swTrackingScope == 'yes' || #attr.row.swTrackingScope == 'YES'}">
			Y
		</s:if>
		<s:else>
			N
		</s:else>
	</display:column>
	<display:column property="dept" title="Dept." sortable="true" />
	<display:column property="sector" title="Sector" sortable="true" />
	<display:column property="type" title="Type" sortable="true" />
	<display:column property="dpe" title="DPE" sortable="true" />
</display:table>