<%
	boolean admin = request.isUserInRole("com.ibm.tap.admin");
	if(admin){
%>
	<div id="ibm-contact-module">
		<!--IBM Contact Module-->
		<a href="${pageContext.request.contextPath}/admin/nonInstancebasedSW/manage.htm?type=add">Add Non Instance base SW</a> <br />
		<a href="${pageContext.request.contextPath}/ws/noninstance/download">Export Non Instance based SW</a>
	</div>
	
	<div id="ibm-merchandising-module">
		<!--IBM Web Merchandising Module-->
		<a href="${pageContext.request.contextPath}/admin/nonInstancebasedSW/upload.htm">Import Non Instance based SW</a>
	</div>
<%
} else{
	
%>
	<div id="ibm-contact-module">
		<!--IBM Contact Module-->
		<a href="${pageContext.request.contextPath}/ws/noninstance/download">Export Non Instance based SW</a>
	</div>
	
	<div id="ibm-merchandising-module">
		<!--IBM Web Merchandising Module-->
	</div>
<%
}
%>

