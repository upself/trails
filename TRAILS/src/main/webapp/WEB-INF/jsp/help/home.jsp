<%@taglib prefix="s" uri="/struts-tags"%>
<h1 class="oneline">Help</h1><div style="font-size:22px; display:inline">&nbsp;resources</div><br>
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
<!--
<br />
<s:url id="admin" action="admin" namespace="/help" includeContext="true"
	includeParams="none">
</s:url>

<s:a href="%{admin}">
	<s:text name="help.link.admin.text" />
</s:a>
-->
