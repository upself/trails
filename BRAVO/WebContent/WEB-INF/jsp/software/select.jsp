<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>

<html lang="en">
<head>
	<title>Select Missing Software: <c:out value="${lparName}"/></title>
	<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp"/>
</head>
<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp"/>
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp"/>
<div id="content">
<!-- START CONTENT HERE -->

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
			
			<c:choose>
				<c:when test="${lparId == null || lparId == ''}">
					&gt;
					<c:out value="${lparName}"/>
					&gt;
					Software
				</c:when>
				<c:otherwise>
					&gt;
					<html:link page="/lpar/view.do?accountId=${account.customer.accountNumber}&lparName=${lparName}">
						<c:out value="${lparName}"/>
					</html:link>
					&gt;
					<html:link page="/software/home.do?lparId=${lparId}">
						Software
					</html:link>
				</c:otherwise>
			</c:choose>
					
			&gt;
			<html:link page="/software/selectInit.do?accountId=${account.customer.accountNumber}&lparName=${lparName}&lparId=${lparId}">
				Select		
			</html:link>
		</p>
	</div>

	<!-- start main content -->
	<div id="content-main">
	
	<h1>Select Missing Software</h1>
	<p class="confidential">IBM Confidential</p>
	<br/>

	<html:form action="/software/select">
	<html:hidden property="context" value="lpar"/>
	<html:hidden property="lparId" value="${lparId}"/>
	<html:hidden property="lparName" value="${lparName}"/>
	<html:hidden property="accountId" value="${accountId}"/>
	<table border="0" width="98%" cellspacing="10" cellpadding="0">
		<thead>
			<tr><th>
			Software Name/Mfg Search:
			</th></tr>
		</thead>
		<tbody>
			<tr><td>
				<html:text property="search" styleClass="inputlong"/>
				<span class="button-blue"><html:submit property="type" value="Search"/></span>
			</td></tr>
			<tr><td>
				<font color="red"><html:errors property="search"/></font>
			</td></tr>
		</tbody>
	</table>
	</html:form>
	
	<div class="indent">
		<h3>
			Software
			<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif" width="14" height="14" alt="contextual field help icon"/>
		</h3>
	</div>
    
	<display:table name="list" requestURI="" class="bravo" id="product">
		<display:setProperty name="basic.empty.showtable" value="true"/>
		<display:setProperty name="basic.msg.empty_list_row" value='<tr class="empty" align="center"><td colspan="{0}">No Software</td></tr>'/>
 
		<display:column property="statusImage" title="" headerClass="blue-med"/>
		
		<display:column property="softwareItem.name" title="Name" sortable="true" headerClass="blue-med" href="/BRAVO/software/create.do?accountId=${accountId}&lparName=${lparName}&lparId=${lparId}" paramId="softwareId" paramProperty="id"/>
	  	<display:column property="manufacturer.manufacturerName" title="Manufacturer" sortable="true" headerClass="blue-med"/>
	  	<display:column property="level" title="License Level" sortable="true" headerClass="blue-med"/>
	  	<display:column property="softwareType" title="Type" sortable="true" headerClass="blue-med"/>
		
	  	
	</display:table>

				
<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
</body>
</html>