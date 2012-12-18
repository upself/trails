<%--
<jsp:directive.page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"/>
--%>
<jsp:text>
	<![CDATA[ <?xml version="1.0" encoding="UTF-8" ?> ]]>
</jsp:text>
<jsp:text>
	<![CDATA[ <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"> ]]>
</jsp:text>
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="tiles" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="bean"
	uri="http://jakarta.apache.org/struts/tags-bean"%>
<bean:define id="lang" scope="session" name="lang"
	type="java.lang.String" />
<bean:define id="file" scope="request" name="file"
	type="java.lang.String" />
<bean:define id="displayDropdown" scope="request" name="displayDropdown"
	type="java.lang.Boolean" />
<html:html lang='<bean:write name="lang"/>' xhtml="true">
<head>
<title><bean:message bundle="HelpPrompts" key="help.page.title" /></title>
<tiles:insert page="/WEB-INF/jsp/common/w3Header.jsp" />
</head>
<body id="w3-ibm-com" class="article">
<tiles:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp" />
<tiles:insert page="/WEB-INF/jsp/common/w3Masthead.jsp" />
<div id="content">
<h1 class="access">Start of main content</h1>

<%--
	<div id="content-head">
		<p id="breadcrumbs">
			<a href="/BRAVO/">BRAVO</a>
			&gt;
			<a href="/BRAVO/help/help.do">Help</a>
			&gt;
			<a href="/BRAVO/help/link.do?lang=<bean:write name="lang"/>&file=<bean:write name="file"/>">User Guides</a>
		</p>
	</div>
	<div id="content-main">
--%> <!-- START CONTENT HERE --> <%
     boolean displayForm = ((java.lang.Boolean) request
                 .getAttribute("displayDropdown")).booleanValue();
 %>
<%
    if (displayForm == true) {
%> <html:form action="/form">
	<html:hidden property="fileContext" />
	<label for="languageSelected"><bean:message
		bundle="HelpPrompts" key="help.dict.language" /></label>:&nbsp;
		<html:select property="languageSelected" styleId="languageSelected"
		size="1">
		<html:option bundle="HelpDropdown" key="help.dict.en" value="en" />
		<!--
			<html:option bundle="HelpDropdown" key="help.dict.es" value="es-419"/>
-->
		<html:option bundle="HelpDropdown" key="help.dict.ja" value="ja" />
		<!--
			<html:option bundle="HelpDropdown" key="help.dict.ko" value="ko"/>
			<html:option bundle="HelpDropdown" key="help.dict.th" value="th"/>
			<html:option bundle="HelpDropdown" key="help.dict.zh-hans" value="zh-hans"/>
-->
		<html:option bundle="HelpDropdown" key="help.dict.zh-hant"
			value="zh-hant" />
	</html:select>
	<html:submit property="type" styleId="button-blue">
		<bean:message bundle="HelpPrompts" key="help.dict.select" />
	</html:submit>
</html:form> <br />
<%
    }//if
%>
<p id="breadcrumbs"><a href="/BRAVO/">BRAVO</a> &gt; <a
	href="/BRAVO/help/help.do">Help</a></p>
<tiles:insert
	page="<%=((java.lang.String)((org.apache.struts.action.DynaActionForm)request.getAttribute(\"helpForm\")).get( \"fileContext\" ))%>" />
<!-- END CONTENT HERE --> <%--
	</div>
--%></div>
<tiles:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
</body>
</html:html>