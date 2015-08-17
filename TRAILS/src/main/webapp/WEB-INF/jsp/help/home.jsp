<%@taglib prefix="s" uri="/struts-tags"%>
<h3>Resources</h3>
<!-- User Guides -->

<s:url id="userGuide" action="userGuide" namespace="/help"
	includeContext="true" includeParams="none">
</s:url>

<s:a href="%{userGuide}">
	<s:text name="help.link.guides.text" />
</s:a>

<br />

<s:url id="faq" action="faq" namespace="/help" includeContext="true"
	includeParams="none">
</s:url>

<s:a href="%{faq}">
	<s:text name="help.link.faqs.text" />
</s:a>

<br />

<s:url id="onPageRef" action="onPageRef" namespace="/help" includeContext="true"
	includeParams="none" />
<s:a href="%{onPageRef}">
	<s:text name="help.link.oprs.text" />
</s:a>
<br />

<br />
<h3>Git hash:</h3>
<s:set var="varGit" value="gitHash" />
<s:property value="varGit" />

<!--
<br />
<s:url id="admin" action="admin" namespace="/help" includeContext="true"
	includeParams="none">
</s:url>

<s:a href="%{admin}">
	<s:text name="help.link.admin.text" />
</s:a>
-->
