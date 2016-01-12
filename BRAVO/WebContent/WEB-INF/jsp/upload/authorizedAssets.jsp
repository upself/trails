<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"    uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="bean"    uri="http://struts.apache.org/tags-bean" %>
<%@ taglib prefix="tmp"     uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"       uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display" uri="http://displaytag.sf.net" %>

<html lang="en">
<head>
    <title>Bravo Upload authorized Assets: <c:out value="${account.customer.customerName}"/></title>
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
            <html:link page="/upload/authorizedAssets.do?id=${account.customer.accountNumber}">
                Upload authorized Assets
            </html:link>
        </p>
    </div>

    <!-- start main content -->
    <div id="content-main">
    
    <!-- start partial-sidebar -->
    <div id="partial-sidebar">
        <h2 class="access">Start of sidebar content</h2>

        <div class="action">
            <h2 class="bar-gray-med-dark">
                Actions
                <html:link page="/help/help.do#H9"><img alt="Help" src="//w3.ibm.com/ui/v8/images/icon-help-contextual-light.gif" width="14" height="14" alt="contextual field help icon"/></html:link>
            </h2>
            <p>
                <!-- Download authorized Assets Template -->
                <img src="//w3.ibm.com/ui/v8/images/icon-link-download.gif" width="14" height="12"/>
                <a href="/BRAVO/download/BRAVO Authorized Assets Template.xls?name=authorizedAssetsBlank&accountId=${account.customer.accountNumber}">Authorized Assets Upload Template</a>

            </p>
        </div><br/>

    </div>
    <!-- stop partial-sidebar -->

    <h1>Upload authorized Assets: <font class="green-dark"><c:out value="${account.customer.customerName}"/></font></h1>
    <p class="confidential">IBM Confidential</p>
    <br/><br/>
    
    <html:form action="/upload/upload" enctype="multipart/form-data">
    <html:hidden property="uploadType" value="authorizedAssets"/>
    <html:hidden property="accountId" value="${account.customer.accountNumber}"/>
    <html:hidden property="hardwareSoftwareId" value="none"/>
    
    <table border="0" width="80%" cellspacing="10" cellpadding="0">
    <tbody>
        <tr>
            <td nowrap="nowrap" width="1%">Filename:</td>
            <td><html:file property="file" size="60"/></td>
            <td></td>
        </tr>
        <tr>
            <td></td>
            <td class="error"><html:errors property="error"/></td>
            <td></td>
        </tr>
        <tr>
            <td></td>
            <td nowrap="nowrap">
                <span class="button-blue">
                    <html:submit property="action" value="Upload File"/>
                </span>
            </td>
        </tr>
        </tbody>
    </table>
    </html:form>
        
<!-- END CONTENT HERE -->
    </div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
 <script type="text/javascript"> var _paq = _paq || []; _paq.push(['trackPageView']); _paq.push(['enableLinkTracking']); (function() { var u="http://lexbz181197.cloud.dst.ibm.com:8085/"; _paq.push(['setTrackerUrl', u+'piwik.php']); _paq.push(['setSiteId', 1]); var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0]; g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s); })(); </script> <noscript><p><img src="http://lexbz181197.cloud.dst.ibm.com:8085/piwik.php?idsite=1" style="border:0;" alt="" /></p></noscript> </body>
</html>

