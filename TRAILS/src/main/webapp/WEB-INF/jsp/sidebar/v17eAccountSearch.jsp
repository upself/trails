<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
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

<div style="padding-left: 20px; width: 100%">
	<h2 style="background-color: #d7d7d8">
		<label style="padding-left: 15px" for="searchAccount.searchString">Search accounts</label>
	</h2>
	<br />
	<div class="table-wrap">
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
				<tr>
					<td><s:checkbox label="Include out of scope accounts"
							name="searchAccount.outOfScopeSearch" /> <label
						for="accounts_searchAccount_outOfScopeSearch">Include out
							of scope accounts</label></td>
				</tr>
			</table>
		</s:form>
	</div>
</div>