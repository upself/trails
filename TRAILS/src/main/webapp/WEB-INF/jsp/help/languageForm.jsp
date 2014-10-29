<%@taglib prefix="s" uri="/struts-tags"%>

<s:form id="country-language-drop-down" theme="simple"
	action="home" namespace="/help" method="post">
	<p><label for="request_locale">Language</label>: <s:select id="request_locale"
		name="request_locale" list="languageDropDown" listKey="key"
		listValue="value" value="language"/> <span class="button-blue"> <input
		type="submit" class="go" value="GO"  alt="Change language"/> </span></p>
</s:form>
<%--
<p id="date-stamp">&nbsp;</p>
--%>
<div class="hrule-clear"></div>
<%-- Note: hrule-clear, not hrule-dots --%>

<%-- TODO we need to update this..but later 
<p id="breadcrumbs"><a href="null">Site home</a> &gt; <a href="null">Top
level 3</a> &gt; <a href="null">Second level 3</a> &gt;</p>
--%>
<p id="date-stamp">New as of 18 January 2008</p>
<div class="hrule-dots"></div>
<p id="breadcrumbs" />
