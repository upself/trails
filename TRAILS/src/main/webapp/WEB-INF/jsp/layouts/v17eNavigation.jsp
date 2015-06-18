<!-- NAVIGATION_BEGIN -->
<div id="ibm-navigation">
	<h2 class="ibm-access">Content navigation</h2>
	<ul id="ibm-primary-links">
		<li id="ibm-overview"><a href="${pageContext.request.contextPath}">TRAILS home</a></li>
		<li><a href="${pageContext.request.contextPath}/search/home.htm">Search</a></li>
		<li><a href="${pageContext.request.contextPath}/reports/home.htm">Reports</a></li>
		<li><a href="${pageContext.request.contextPath}/account/home.htm">Account</a></li>
		<li class="ibm-active"><a href="${pageContext.request.contextPath}/admin/home.htm">Administration</a>
			<ul>
	    		<li><a href="${pageContext.request.contextPath}/admin/scheduleF/showUpload.htm">Schedule F</a></li>
	    		<li><a href="${pageContext.request.contextPath}/admin/pvuMapping/listPvu.htm">PVU Mapping</a></li>
	    		<li><a href="${pageContext.request.contextPath}/admin/alertCause/list.htm">Cause code</a></li>
	    		<li class="ibm-active"><a href="${pageContext.request.contextPath}/admin/nonInstancebasedSW/list.htm">Non Instance based SW</a>
	    			<%
						boolean admin = request.isUserInRole("com.ibm.tap.admin");
						if(admin){
					%>
						<ul>
	    					<li><a href="${pageContext.request.contextPath}/admin/nonInstancebasedSW/manage.htm?type=add">Non Instance based SW manage</a></li>
	    				</ul>
					<%
						} 
					%>
	    		</li>
			</ul>
		</li>
		<li><a href="${pageContext.request.contextPath}/help/home.htm">Help</a></li>
		<li><a href="http://tap.raleigh.ibm.com/">Asset home</a></li>
	</ul>
</div>
<!-- NAVIGATION_END -->
