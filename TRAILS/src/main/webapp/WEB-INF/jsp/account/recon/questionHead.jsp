<%@ taglib prefix="s" uri="/struts-tags"%>

<s:url id="settingsLink" action="settings" namespace="/account/recon"
	includeContext="true" includeParams="none">
</s:url>

<s:url id="workspaceLink" action="workspace" namespace="/account/recon"
	includeContext="true" includeParams="none">
</s:url>

<p id="breadcrumbs"><a href="${settingsLink}"> Workspace
settings </a> &gt; <a href="${workspaceLink}"> Workspace</a> &gt;</p>
