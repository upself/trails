<%@ taglib prefix="s" uri="/struts-tags" %>
<html>
  <head>
    <title>Please wait</title>
    <meta http-equiv="refresh" content="10;url=<s:url includeParams="all" />"/>
  </head>
  <body>
    Please wait while we process your request.<br />
    Please do not press your browser's back button while the alerts are being processed.<br />
    Processed <s:if test="recon.reconcileType.id == 10 || recon.reconcileType.id == 11"><s:property value="alertService.alertsProcessed" /></s:if><s:else><s:property value="reconWorkspaceService.alertsProcessed" /></s:else> alert(s) out of <s:if test="recon.reconcileType.id == 10 || recon.reconcileType.id == 11"><s:property value="alertService.alertsTotal" /></s:if><s:else><s:property value="reconWorkspaceService.alertsTotal" /></s:else> total.
  </body>
</html>
