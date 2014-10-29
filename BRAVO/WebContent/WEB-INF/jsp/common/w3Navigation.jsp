<%@ taglib uri="http://jakarta.apache.org/struts/tags-html"
	prefix="html"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean"
	prefix="bean"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic"
	prefix="logic"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles"
	prefix="tmp"%>

<ul id="ibm-primary-links">

	<li id="ibm-parent-link">
		<a href="http://tap.raleigh.ibm.com">Asset Tools Home</a>
	</li>
		<li id="ibm-overview">
			<a href="/BRAVO/home.do">BRAVO</a>
			<a href="/BRAVO/mswiz.do">MS Wizard</a>
			<a href="/BRAVO/help/help.do">Help</a>
			<a href="/BRAVO/report/home.do">Reports</a>
			<a href="/BRAVO/systemStatus/home.do">System status</a>
		</li>		
		
		
		<% boolean lbValidRole = false;
   		boolean lbAdminRole = false; %>
		<req:isUserInRole role="com.ibm.tap.admin">
			<% lbValidRole = true;
   			lbAdminRole = true; %>
		</req:isUserInRole>
		
		<req:isUserInRole role="com.ibm.tap.sigbank.admin">
			<% lbValidRole = true;
	   		lbAdminRole = true; %>
		</req:isUserInRole>
		
		<req:isUserInRole role="com.ibm.tap.sigbank.user">
			<% lbValidRole = true; %>
		</req:isUserInRole>
		<% if (lbValidRole) { %>
		<li id="ibm-overview">
			<a href="/BRAVO/bankAccount/home.do">Bank accounts</a>
			<logic:present scope="request" name="bankAccountSection">
			<ul>
				<li>
					<a href="/BRAVO/bankAccount/connected.do">Connected</a>
					
					<logic:equal scope="request" name="bankAccountSection" value="CONNECTED">
						<% if (lbAdminRole) { %>
						<ul>
							<li>
								<a href="/BRAVO/bankAccount/connectedAddEdit.do">Add</a>
							</li>
						</ul>
						<% } %>
					</logic:equal>	
				</li>
				
				<li>
					<a href="/BRAVO/bankAccount/disconnected.do">Disconnected</a>
					
					<logic:equal scope="request" name="bankAccountSection" value="DISCONNECTED">
						<% if (lbAdminRole) { %>
						<ul>
							<li>
								<a href="/BRAVO/bankAccount/disconnectedAddEdit.do">Add</a>
							</li>
						</ul>
						<% } %>
					</logic:equal>
				</li>
			</ul>
			</logic:present>
		</li>
		<% } %>
		
		<%
		 boolean validRole = false;
		 %> <req:isUserInRole role="com.ibm.ea.bravo.admin">
			<%
			validRole = true;
			%>
		</req:isUserInRole> <req:isUserInRole role="com.ibm.ea.asset.admin">
			<%
			validRole = true;
			%>
		</req:isUserInRole> <req:isUserInRole role="com.ibm.ea.admin">
			<%
			validRole = true;
			%>
		</req:isUserInRole> <req:isUserInRole role="com.ibm.tap.admin">
			<%
			validRole = true;
			%>
		</req:isUserInRole> <%
		 if (validRole) {			
		 %> 
		<li id="ibm-overview">
			 <a href="/BRAVO/admin/home.do">Administration</a>
		</li>
		<%
		}
		%>
</ul>
