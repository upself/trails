<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>

<!-- start content -->
<div id="content">
<h1 class="access">Start of main content</h1>
<!-- start content head -->
<div id="content-head">
<p id="date-stamp"><%
        out.println(new java.util.Date().toString());
    %></p>
<div class="hrule-dots"></div>


<p id="breadcrumbs"></p>
</div>
<!-- stop content head --> <!-- start main content -->
<div id="content-main">
<h1>Microsoft License System Error</h1>
<br>

A System error has occurred: <html:errors /></div>
<!-- stop main content --></div>
<!-- stop content -->
