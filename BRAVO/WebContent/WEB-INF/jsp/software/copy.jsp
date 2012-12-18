<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="bean"	uri="http://struts.apache.org/tags-bean" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>

<html lang="en">
<head>
	<title>Bravo Account: <c:out value="${account.customer.customerName}"/></title>
	<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp"/>
</head>
<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp"/>
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp"/>
<div id="content">
<!-- START CONTENT HERE -->

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
			<html:link page="/lpar/view.do?accountId=${account.customer.accountNumber}&lparName=${lpar.name}">
				<c:out value="${lpar.name}"/>
			</html:link>
		</p>
	</div>

	<!-- start main content -->
	<div id="content-main">
	<h1>Bravo Account: <c:out value="${account.customer.customerName}"/></h1>
	<p class="confidential">IBM Confidential</p>
	<br />
	<c:set var="checkAll">
	    <input type="checkbox" name="allbox" onclick="checkAll(this.form)" style="margin: 0 0 0 4px" />
	</c:set>
	<html:form action="/software/applyCopy">
			<html:hidden property="lparId" value="${lpar.id}"/>
			<display:table name="list" requestURI="" class="bravo" id="small" >

				<display:setProperty name="basic.empty.showtable" value="true"/>
				
				<display:column title="${checkAll}" headerClass="blue-med">
					<html:multibox property="selected" style="margin: 0 0 0 4px" >
						<c:out value="${small.id}"/>
					</html:multibox>
				</display:column>
			  	<display:column property="name" title="Name" sortable="true" headerClass="blue-med" href="/BRAVO/lpar/view.do?accountId=${account.customer.accountNumber}" paramId="lparName" paramProperty="name" />
			  	<display:column property="biosSerial" title="Bios Serial" sortable="true" headerClass="blue-med"/>
				
			</display:table>
	
		<div class="hrule-dots"></div>
			<div class="indent">
	    	<span class="button-blue">
				<input type="submit" name="action" value="Copy" />
			</span>
		</div>
	</html:form>

<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
</body>
</html>

