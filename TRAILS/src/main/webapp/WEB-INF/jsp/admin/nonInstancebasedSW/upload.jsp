   <%@ taglib prefix="s" uri="/struts-tags"%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery.liveSearch.css" />
<script src="${pageContext.request.contextPath}/js/jquery.js" type="text/javascript"></script>

    	<form id="myForm"  action="${pageContext.request.contextPath}/ws/noninstance/upload" class="ibm-column-form" enctype="multipart/form-data" method="post">
 
       <p>
        Select a file : <input id="uploadedFile_id" type="file" name="uploadedFile" size="50" />
       </p>
 
       <input type="submit" value="Upload It" />
    </form>
