<jsp:text><![CDATA[<?xml version="1.0" encoding="UTF-8" ?>]]></jsp:text>
<%@ page language="java" contentType="text/html"%>
<%--
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="tiles" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="bean" uri="http://struts.apache.org/tags-bean"%>
--%>
<%@ taglib prefix="html" uri="/WEB-INF/struts-html.tld"%>
<%@ taglib prefix="tiles" uri="/WEB-INF/struts-tiles.tld"%>
<%@ taglib prefix="bean" uri="/WEB-INF/struts-bean.tld" %>
<bean:define id="lang" scope="session" name="lang" type="java.lang.String"/>
<bean:define id="file" scope="request" name="file" type="java.lang.String"/>
<bean:define id="displayDropdown" scope="request" name="displayDropdown" type="java.lang.Boolean"/>
<tiles:insert page="/WEB-INF/jsp/common/w3Head.jsp" />
	<tiles:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp" />
	<tiles:insert page="/WEB-INF/jsp/common/w3MastHead.jsp" />
	<%-- w3MastHead.jsp's 'div's are unbalanced --%>
	</div>
<%--
	<jsp:include page="/WEB-INF/jsp/common/w3Accessibility.jsp" />
	<jsp:include page="/WEB-INF/jsp/common/w3Masthead.jsp" />
--%>
	<div id="content">
	<h1 class="access">Start of main content</h1>

	<div id="content-head">
<%--
		<p id="breadcrumbs">
			<a href="/SignatureBank/">SignatureBank</a>
			&gt;
			<a href="/SignatureBank/help/help.do">Help</a>
			&gt;
			<a href="/SignatureBank/help/link.do?lang=<bean:write name="lang"/>&file=<bean:write name="file"/>">User Guides</a>
		</p>
--%>
	</div>
	<div id="content-main">
	<!-- START CONTENT HERE -->

	<%boolean displayForm = ((java.lang.Boolean)request.getAttribute("displayDropdown")).booleanValue();%>
	<%if(displayForm == true){%>
	<html:form action="/form">
		<html:hidden property="fileContext"/>
		<label for="languageSelected"><bean:message bundle="HelpPrompts" key="help.dict.language"/></label>:&nbsp;
		<html:select property="languageSelected" styleId="languageSelected" size="1">
			<html:option bundle="HelpDropdown" key="help.dict.en" value="en"/>
<!--
			<html:option bundle="HelpDropdown" key="help.dict.es" value="es-419"/>
-->
			<html:option bundle="HelpDropdown" key="help.dict.ja" value="ja"/>
<!--
			<html:option bundle="HelpDropdown" key="help.dict.ko" value="ko"/>
			<html:option bundle="HelpDropdown" key="help.dict.th" value="th"/>
			<html:option bundle="HelpDropdown" key="help.dict.zh-hans" value="zh-hans"/>
-->
			<html:option bundle="HelpDropdown" key="help.dict.zh-hant" value="zh-hant"/>
		</html:select>
		<html:submit property="type" styleId="button-blue"><bean:message bundle="HelpPrompts" key="help.dict.select"/></html:submit>
	</html:form>
	<br/>
	<%}//if%>
		<p id="breadcrumbs">
			<a href="/SignatureBank">SignatureBank</a>
			&gt;
			<a href="/SignatureBank/help/help.do">Help</a>
		</p>
	<tiles:insert page='<%=((java.lang.String)((org.apache.struts.action.DynaActionForm)request.getAttribute("helpForm")).get("fileContext"))%>'/>
	<!-- END CONTENT HERE --></div>
	</div>
	<tiles:insert page="/WEB-INF/jsp/common/staticNav.jsp" />
	<tiles:insert page="/WEB-INF/jsp/common/footer.jsp" />