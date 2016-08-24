<%@ taglib prefix="s" uri="/struts-tags"%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery.liveSearch.css" />
<script src="${pageContext.request.contextPath}/js/jquery.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/trails_style.css">

<script type="text/javascript">
var lastValue = '';
$(document.body).click(
	function(event) {
		var liveSearch = $("#jquery-live-search");
		if (liveSearch.length) {
			var clicked = $(event.target);
			if (!(clicked.is("#jquery-live-search") || clicked.parents("#jquery-live-search").length || clicked.is(this))) {
				liveSearch.slideUp();
			}
		}
	}
);

function keyup(type) {
	var value = $.trim(type.value);
	
	if (value == $.trim('') || value == '' || value == lastValue) {
		return;
	}
	
	lastValue = value;

	var liveSearch = $("#jquery-live-search");

	if (!liveSearch.length) {
		liveSearch = $("<div id='jquery-live-search'></div>").appendTo(document.body).hide().slideUp(0);
	}
	
	var inputPos = $(type).position();
	var inputHeight = $(type).outerHeight();

	liveSearch.css({
		"position" : "absolute",
		"top" : inputPos.top + inputHeight + "px",
		"left" : inputPos.left + "px"
	});

	if (this.timer) {
		clearTimeout(this.timer);
	}
	
	this.timer = setTimeout(
			function() {
				$.ajax({
					url : "${pageContext.request.contextPath}/admin/nonInstancebasedSW/liveSearch.htm",
					async : true,
					type : "POST",
					data : {
							key : value,
							label : type.name
					},
					beforeSend : function() {
						liveSearch.empty();
						liveSearch.append("searching...").fadeIn(400);
					},
					error : function() {
						liveSearch.empty();
						liveSearch.append("error").fadeIn(400);
					},
					success : function(data, status) {
						liveSearch.empty();
						if (!data.length) {
							liveSearch.append("no matched item found.")
						} else {
							liveSearch.append(data);
						}
						liveSearch.show("slow");
						var over = {
								"color" : "white",
								"background" : "blue"
								};

						var out = {
								"color" : "black",
								"background" : "white"
								};

						$("li.prompt").hover(
							function() {
								$(this).css(over);
							}, 
							function() {
								$(this).css(out);
							}
						);

						$("li.prompt").click(
							function() {
								if(type.name == 'softwareName') {
									type.value = $(this).text().slice(11,-10);	
								} else {
									type.value = $(this).text();	
								}
							}
						);
					}
				})
			}, 1000);
}
</script>
<!-- manage Non Instance based SW -->
<div class="ibm-columns">
    <p class="ibm-confidential">IBM Confidential</p>
	<div class="ibm-col-1-1">
   	    <div class="ibm-alternate-rule"><hr/></div>
		<form id="myForm" onsubmit="submitForm(); return false;" action="/" class="ibm-column-form" enctype="multipart/form-data" method="post">
			<s:if test="#request.nonInstanceDisplay != null">
				<input name="id" value="<s:property value='#request.nonInstanceDisplay.id'/>" type="hidden" />
			</s:if>
			<p>
				<label style="width:30%" for="softwareName_id">Software component:
					<span class="ibm-required">*</span> 
				</label> 
				<span>
					<input name="softwareName" id="softwareName_id" value="<s:property value='#request.nonInstanceDisplay.softwareName'/>" size="40" type="text" onKeyUp="keyup(this)">
				</span>
			</p>
			<p>
				<label style="width:30%" for="manufacturerName_id"> Manufacturer:
					<span class="ibm-required">*</span> 
					<span class="ibm-item-note"></span>
				</label> 
				<span> 
					<input name="manufacturerName" id="manufacturerName_id" value="<s:property value='#request.nonInstanceDisplay.manufacturerName'/>" size="40" value="" type="text" onKeyUp="keyup(this)">
				</span>
			</p>
			<p>
				<label style="width:30%" for="restriction_id"> Restriction:<span class="ibm-required">*</span>
				</label> <span> 
				<select name="restriction" id="restriction_id">
					<option value="">Please select one</option>
					<option value="Account" <s:if test="#request.nonInstanceDisplay.restriction eq 'Account'">selected="selected"</s:if> >Account</option>
					<option value="Machine" <s:if test="#request.nonInstanceDisplay.restriction eq 'Machine'">selected="selected"</s:if>>Machine</option>
					<option value="LPAR" <s:if test="#request.nonInstanceDisplay.restriction eq 'LPAR'">selected="selected"</s:if>>LPAR</option>
				</select>
				</span>
			</p>
			<p>
				<label style="width:30%" for="baseOnly_id"> Non Instance based only :<span class="ibm-required">*</span>
				</label> <span> <select name="baseOnly" id="baseOnly_id">
						<option value="">Please select one</option>
						<option value="1" <s:if test="#request.nonInstanceDisplay.baseOnly eq 1">selected="selected"</s:if> >Y</option>
						<option value="0" <s:if test="#request.nonInstanceDisplay.baseOnly eq 0">selected="selected"</s:if> >N</option>
				</select>
				</span>

			</p>
			<p>
				<label style="width:30%" for="capacityDesc_id"> Non Instance capacity type:<span class="ibm-required">*</span>
				</label> 
				<span>
					<select name="capacityCode" id="capacityCode_id" style="max-width:270px;">
						<option value="">Please select one</option>
						<s:iterator value="#request.capacityTypeList" id="capacityType">
							<option value="<s:property value='#capacityType.code'/>" <s:if test="#request.nonInstanceDisplay.capacityCode eq #capacityType.code">selected="selected"</s:if> ><s:property value='#capacityType.description'/></option>
						</s:iterator>
					</select>  
				</span>
			</p>
			<p>
				<label style="width:30%" for="statusId_id"> Status:<span class="ibm-required">*</span>
				</label> <span> <select name="statusId" id="statusId_id">
						<option value="">Please select one</option>
						<option value="2" <s:if test="#request.nonInstanceDisplay.statusId eq 2">selected="selected"</s:if> >ACTIVE</option>
						<option value="1" <s:if test="#request.nonInstanceDisplay.statusId eq 1">selected="selected"</s:if> >INACTIVE</option>
				</select>
				</span>
			</p>
			<span class="ibm-spinner-large" id="loading" style="display:none;position:relative;top:-120px;z-index:9999;"></span>
			<div class="ibm-alternate-rule">
				<hr/>
			</div>
			<div class="ibm-columns">
				<div class="ibm-col-6-3">
					<p>
						<input value="Save" name="ibm-submit" class="ibm-btn-pri" type="submit">
					</p>
				</div>
			</div>
		</form>
		<!-- FORM_END -->
	</div>
</div>
<script>
function submitForm(){
	if(validateForm()){
		$.ajax({
	        cache: true,
	        type: "POST",
	        url: '${pageContext.request.contextPath}/ws/noninstance/saveOrUpdate',
	        data: $('#myForm').serialize(),
	        dataType:'json',
	        async: false,
	        beforeSend: function (XMLHttpRequest) {
            	$("#loading").show();
            },
	        error: function(XMLHttpRequest, textStatus, errorThrown) {
	            alert(textStatus);
	        },
	        success: function(data) {
	            alert(data.msg);
	        },
	        complete: function (XMLHttpRequest, textStatu) {
            	$("#loading").hide();
            }
	    });
	} 
}

function validateForm(){
	var softwareName = $("#softwareName_id").val();
	var manufacturerName = $("#manufacturerName_id").val();
	var restriction = $("#restriction_id").val();
	var baseOnly = $("#baseOnly_id").val();
	var capacityCode = $("#capacityCode_id").val();
	var statusId = $("#statusId_id").val();

	if(softwareName.trim() == ''){
		alert('Software component is required');
		return false;
	}
	
	if(manufacturerName.trim() == ''){
		alert('Manufacturer is required');
		return false;
	}
	
	if(restriction.trim() == ''){
		alert('Restriction is required');
		return false;
	}
	
	if(baseOnly.trim() == ''){
		alert('Non Instance based only is required');
		return false;
	}
	
	if(capacityCode.trim() == ''){
		alert('Non Instance capacity type is required');
		return false;
	}
	
	if(statusId.trim() == ''){
		alert('Status is required');
		return false;
	}
	
	return true;
}

</script>






