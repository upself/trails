<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"        uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="bean"        uri="http://struts.apache.org/tags-bean" %>
<%@ taglib prefix="tmp"         uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"           uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"     uri="http://displaytag.sf.net" %>

<html lang="en">
<head>
        <title>Bravo Upload TCM Script TAR File: <c:out value="${account.customer.customerName}"/></title>
        <tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp"/>
</head>

<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp"/>
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp"/>
<div id="content">
<!-- START CONTENT HERE -->

        <h1 class="access">Start of main content</h1>
        <!-- start content head -->

        <div id="content-head">
                <p id="date-stamp">New as of 26 June 2006</p>
                <div class="hrule-dots"></div>
                <p id="breadcrumbs">
                        <html:link page="/">
                                BRAVO
                        </html:link>
                        &gt;
                        <html:link page="/account/view.do?accountId=${account.customer.accountNumber}">
                                <c:out value="${account.customer.customerName}"/>
                        </html:link>
                        &gt;
                        <html:link page="/upload/tivoli.do?id=${account.customer.accountNumber}">
                                Upload TCM Script TAR File
                        </html:link>
                </p>
        </div>

        <!-- start main content -->
        <div id="content-main">

        <h1>Upload TCM Script TAR File: <font class="green-dark"><c:out value="${account.customer.customerName}"/></font></h1>
        <p class="confidential">IBM Confidential</p>
        <br/><br/>

<p><font color="red">The legacy standalone scan solution, often referred to as the TCM or TLCM Script,  has been discontinued.  BRAVO no longer accepts scan output files from the legacy solution.   All copies of the legacy scripts should be removed from IBM managed systems.  A replacement solution based on TAD4D technology has been deployed.  Please follow this link to the replacement solution:  <a href="http://tap.raleigh.ibm.com/EMEA/StandaloneScanScripts/">TAD4D Standalone solution</a></font></p>

<!-- END CONTENT HERE -->
        </div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
</body>
</html>