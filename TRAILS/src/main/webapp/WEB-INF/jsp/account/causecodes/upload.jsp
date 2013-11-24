<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<script src="${pageContext.request.contextPath}/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
	function clearSteps() {
		$
				.ajax({
					url : "${pageContext.request.contextPath}//account/causecodes/clearsteps.htm",
					async : true,
					type : "POST"
				});
	}

	function progress() {
		var stop = false;
		var timer;
		$
				.ajax({
					url : "${pageContext.request.contextPath}//account/causecodes/progress.htm",
					async : false,
					type : "POST",
					contentType : "application/json",
					dataType : 'json',
					success : function(steps) {
						if (!steps) {
							return;
						}
						var bar = $("#progressbar");
						bar.empty();
						for ( var i = 0; i < steps.length; i++) {
							if (steps[i].finalState) {
								stop = true;
								clearSteps();
								if (timer) {
									clearTimeout(timer);
								}
								if (steps[i].status == 'SUCCESS') {
									alert('Your data has been loaded successfully');
								} else {
									alert('Cause code uploading failed');
								}
								break;
							}
							bar.append("<br/> step " + (i + 1) + "/" + "3 "
									+ steps[i].description + " "
									+ steps[i].progress + "% "
									+ steps[i].status);
						}

					},
					error : function(XmlHttpRequest, textStatus, errorThrown) {
						alert("Error:" + XmlHttpRequest.responseText);
						stop = true;
						if (timer) {
							clearTimeout(timer);
						}
					}
				});

		if (!stop) {
			timer = setTimeout(progress, 500);
		}
	}
</script>


<style>
.ui-progressbar {
	position: relative;
}

.progress-label {
	position: absolute;
	left: 50%;
	top: 4px;
	font-weight: bold;
	text-shadow: 1px 1px 0 #fff;
}
</style>

<h1>Upload Cause Codes</h1>
<p class="confidential">IBM Confidential</p>
<br />
TRAILS Cause Codes are used to document the root cause of an alert and
the team(s) responsible for the next action to resolve the alert. The
standard global Cause Codes are not intended to replace rigorous review
of open alerts and creation of action plans to resolve them; they are
concise text description. Consensus on the ownership of 'next action'
should be reached between Asset Management and the team outside Asset
prior to assigning a Cause Code that indicates action is required
outside Asset Management.
<br />
<br />
To populate the Cause Code data, take the following steps:
<br />
<br />
<strong>1. Download a report of existing cause codes.</strong>
From the blue navigation bar on the Account Detail screen, click on
'Account' - 'Alerts' - and the name of the desired alert to download a
TRAILS Alert report within an account. The report will contain five new
'Cause Code' columns for each alert, which will be blank if a Cause Code
has never been assigned:
<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;a. Cause Code: Text of the Cause Code, prefaced
by the alert number to which it applies. Use only the standard Cause
Codes listed on the new 'valid Cause Codes' tab. Do not attempt to
modify the standard list!
<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;b. CC Target Date: Target date for correcting
the issues; ensure the cell is under date formate. Optional field.
<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;c. CC Change Date: Timestamp when the Cause Code
was last changed. Automatically populated by TRAILS in format 2013-08-19
20:54:15:913273.
<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;d. CC Change Person: Email address of the person
changing the Cause Code. Automatically populated by TRAILS in format
lotusshortname@country.ibm.com.
<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;e. Internal ID: Do not use! Automatically
populated by TRAILS to help manage the data.
<br />
<br />
<strong>2. Update the desired Cause Codes.</strong>
User may update the first three columns (items a, b and c above) for
desired alerts. Remove alerts from report when Cause Code is not being
updated. Store report on local hard drive with meaningful name; for
example, Acct 12435 Alert 3 Cause Codes as of DD MM YYYY. Updates to any
other fields will be ignored!!!
<br />
<br />
<strong>3. Upload the cause code data.</strong>
From the blue navigation bar on the Account Detail screen, click on
'Account' - 'Cause Codes'. Use the 'Browse' function to select the
correct file from the local hard drive. Click 'Submit' to initiate
upload. User may consolidate multiple alert reports in to a single
upload file for an account, i.e. download all alert reports, update
desired Cause Codes, consolidate in one file and upload the consolidated
file.
<br />
<br />
<strong>4. Correct errors as needed.</strong>
If there were errors in the file, TRAILS will display the file used with
error fields marked in red. No data from the file will be loaded to
TRAILS until the errors are corrected and the file resubmitted. If there
were no errors, TRAILS will display a message that 'Your data has been
loaded successfully' in a separate pop-up window.
<br />
<div class="hrule-dots"></div>
<br />
<s:actionerror />
<s:actionmessage />

<s:form id="uploadForm" action="upload" namespace="/account/causecodes"
	enctype="multipart/form-data" theme="simple" onsubmit="progress()">
	<table>
		<tr>
			<td><label for="upload">*File:</label></td>
			<td><s:file id="upload" name="upload" label="File" /></td>
		</tr>
	</table>
	<div class="clear"></div>
	<div class="button-bar">
		<div class="buttons">
			<span class="button-blue"><s:submit alt="Submit" /></span>
		</div>
	</div>
	<iframe name="hiddenFrame" style="display: none;"></iframe>
</s:form>

<br />
<br />

<div id="progressbar"></div>

