<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tmp"%>


<h1>Signature Bank Home</h1>
<br>

<html:img alt="Fingerprint" page="/images/p1_w3v8_11.jpg" align="left" hspace="10"
	vspace="10" />

<p style="color:#7a3" class="caption">Welcome to the Signature Bank
</p>
<p>your one stop shop for software signature research and
administration. From this web interface you can administer the current
signature repository, search the filter library, edit the software
catalog, and manage signature replication to TCM Configuration
repositories throughout IBM.</p>

<br clear="all">

<p style="color:#a00" class="caption">Actions:</p>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>

<div class="hrule-dots">&nbsp;</div>

<br>

<p><html:img alt="Action" page="/images/icon-link-action.gif" /><label for="id_softwareName">Search for
Software</label> <html:form action="/SoftwareSearch">
	<html:text styleId="id_softwareName" property="softwareName" styleClass="input" /> &nbsp; &nbsp;
<span class="button-blue"> <html:submit property="action"
		value="Search" /> </span>
</html:form></p>

<p><html:img alt="Action" page="/images/icon-link-action.gif" /> <html:link
	page="/SoftwareRefineSearch.do">View the Software Catalog</html:link> <br>
</p>

</div>
<!-- stop main content -->

</div>
<!-- stop content -->
