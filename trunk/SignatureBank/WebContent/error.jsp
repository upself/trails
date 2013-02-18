<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tmp" %>
<tmp:insert template="/common/w3Header.jsp"/>

<!-- start content -->
<div id="content">
	<h1 class="access">Start of main content</h1>
	<!-- start content head -->
	<div id="content-head">
	<p id="date-stamp"><% out.println(new java.util.Date().toString()); %></p>
    <div class="hrule-dots">&nbsp;</div>


	<p id="breadcrumbs"></p>
	</div>
	<!-- stop content head -->

	<!-- start main content -->
	<div id="content-main">
		<h1>Signature Bank System Error</h1>
		<br>
		
		A System error has occurred: <html:errors/>
	</div>
	<!-- stop main content -->

</div>
<!-- stop content -->

<!-- start navigation -->
<div id="navigation">
	<tmp:insert template="/common/navigationBar.jsp"/>

</div>
<!-- stop navigation -->
</body>
</html>
