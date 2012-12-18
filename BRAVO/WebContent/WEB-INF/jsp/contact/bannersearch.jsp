<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>
<%@ taglib prefix="req"     uri="http://jakarta.apache.org/taglibs/request-1.0" %>


			<html:form action="/contact/bluepages/search">
			<html:hidden property="context" value="${context}" />
			<html:hidden property="lparId" value="${lparId}"/>
			<html:hidden property="lparName" value="${lparName}"/>
			<html:hidden property="customerid" value="${customerid}"/>
			<html:hidden property="accountId" value="${accountId}"/>
			<html:hidden property="id" value=""/>

			<table border="0" width="80%" cellspacing="0" cellpadding="5">
				<tbody>
					<tr align="center">
						<td nowrap="nowrap" >
							<div class="invalid"><html:errors property="search"/></div>
						</td>
					</tr>
					<tr align="center">
						<td align="right">
							<select name="action">
								<option value="INTERNET" selected="selected">Internet Email Account</option>
								<option value="SERIAL" >IBM Serial Number</option>
								<option value="NAME" >Full Name (Last, First)</option>
							</select>
						</td>
						<td nowrap="nowrap" >
							<html:text property="search" size="60" styleClass="input"/>
						</td>
					</tr>
					<tr align="center">
						<td nowrap="nowrap" >
							<span class="button-blue"><html:submit property="type" value="Search"/></span>
						</td>
					</tr>
				</tbody>
			</table>
			</html:form>

			<br clear="all"/>
			<table border="0" cellpadding="2" cellspacing="0" width="100%">
				<tr>
					<td colspan=2><div class="hrule-dots"></div></td>
				</tr>
			</table>


	