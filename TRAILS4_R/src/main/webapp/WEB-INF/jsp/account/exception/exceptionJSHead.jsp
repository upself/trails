<script src="${pageContext.request.contextPath}/js/jquery.js"
	type="text/javascript"></script>
<script type="text/javascript">

$(document).ready(function(){
    $(window).resize(function(){        
    	resize();
    });

    $(window).scroll(function(){
    	 resize();
    });
});

function getViewPortSize(){
	 var viewportwidth;
	 var viewportheight;
	 // the more standards compliant browsers (mozilla/netscape/opera/IE7) use window.innerWidth and window.innerHeight
	 if (typeof window.innerWidth != 'undefined')
	 {
	      viewportwidth = window.innerWidth,
	      viewportheight = window.innerHeight
	 }
	// IE6 in standards compliant mode (i.e. with a valid doctype as the first line in the document)
	 else if (typeof document.documentElement != 'undefined'
	     && typeof document.documentElement.clientWidth !=
	     'undefined' && document.documentElement.clientWidth != 0)
	 {
	       viewportwidth = document.documentElement.clientWidth,
	       viewportheight = document.documentElement.clientHeight
	 }
	 // older versions of IE
	 else
	 {
	       viewportwidth = document.getElementsByTagName('body')[0].clientWidth,
	       viewportheight = document.getElementsByTagName('body')[0].clientHeight
	 }

	 var size={};
	 size["width"]=viewportwidth;
	 size["height"]=viewportheight;
	return size;
}


function resize(){
    var className = document.getElementById('popupDl').className;
	if( className=='showDlg'){       
      var w=368;
      var h=129;
      
      var dde=document.documentElement;
      
      var objDeck = document.getElementById("deck");
      var obox=document.getElementById('popupDl');
      
      objDeck.style.left=dde.scrollLeft+"px";
      objDeck.style.top=dde.scrollTop+"px";

      size = getViewPortSize();

      
      objDeck.style.width=size["width"]+"px";
      objDeck.style.height=size["height"]+"px";
    
      obox.style.left=dde.scrollLeft+(size["width"]-w)/2 +"px";
      obox.style.top=dde.scrollTop+(size["height"]-h)/2 +"px";
	}
}



function displayPopUp(page) {
	var winModalWindow;
	winModalWindow = window.open(page, 'PopUpWindow', 'left=200,top=180,resizable=yes,scrollbars=yes,width=700,height=500');
}

function popupBravoSl(accountId,lparName,swId) {
  newWin=window.open('//${bravoServerName}/BRAVO/lpar/view.do?accountId=' + accountId + '&lparName=' + lparName + '&swId=' + swId,'popupWindow','height=600,width=1200,resizable=yes,menubar=yes,status=yes,toolbar=yes,scrollbars=yes'); 
  newWin.focus(); 
  void(0);
}

function popupBravoHl(accountId,lparName,hwId) {
	  newWin=window.open('//${bravoServerName}/BRAVO/lpar/view.do?accountId=' + accountId + '&lparName=' + lparName + '&hwId=' + hwId,'popupWindow','height=600,width=1200,resizable=yes,menubar=yes,status=yes,toolbar=yes,scrollbars=yes'); 
	  newWin.focus(); 
	  void(0);
}

String.prototype.trim= function(){  
    return this.replace(/(^\s*)|(\s*$)/g, "");  
}

function openDl(){
	var objDeck = document.getElementById("deck");
    if(!objDeck)
    {
        objDeck = document.createElement("div");
        objDeck.id="deck";
        document.body.appendChild(objDeck);
    }
    //set the deck's width and height full screen.
    var dde=document.documentElement;
    objDeck.style.left=dde.scrollLeft+"px";
    objDeck.style.top=dde.scrollTop+"px";

    size = getViewPortSize();
    
    objDeck.style.width=size["width"]+"px";
    objDeck.style.height=size["height"]+"px";

    
    objDeck.className="showDeck";
    
    hideOrShowSelect(true); 
    
    var w=368;
    var h=129;
    var obox=document.getElementById('popupDl');
    
    obox.style.left=dde.scrollLeft+(size["width"]-w)/2 +"px";
    obox.style.top=dde.scrollTop+(size["height"]-h)/2 +"px";
    document.getElementById('popupDl').className='showDlg';

    $("textarea#id_comments").val("");
}

function hideDl()
{
    document.getElementById('popupDl').className='hideDlg';
    document.getElementById("deck").className="hideDeck";
    hideOrShowSelect(false);
}

function showDl(url,alertId,rowNumber)
{
    //store the url in hidden elements.
    $("input#id_url").val(url);
    $("input#id_alert_id").val(alertId);
    $("input#id_row_number").val(rowNumber);

    $("input#submit_button").unbind("click");
    $("input#submit_button").bind("click",submitSingle);

    openDl();
}

function showDx(url)
{
    //store the url in hidden elements.
    $("input#id_url").val(url);

    $("input#submit_button").unbind("click");
    $("input#submit_button").bind("click",updateAll);

    openDl();
}

function hideOrShowSelect(v)
{
    var allselect = document.getElementsByTagName("select");
    for (var i=0; i<allselect.length; i++)
    {
      //allselect.style.visibility = (v==true)?"hidden":"visible";
      allselect.disabled =(v==true)?"disabled":"";
   }
}

function submitSingle(){

	var comments = $("textarea#id_comments").val();
	if(isCommentsEmpty(comments)){
		return;
	}

	var params={};
	params["comments"]=comments;
	
	var alertId = $("input#id_alert_id").val();
	var rowNum=$("input#id_row_number").val();

	params["list["+rowNum+"].id"] = alertId;

	showProgress(alertId);
	
	$.post($("input#id_url").val(),params,statusChange);
	hideDl();
}

function updateAll(){

	var comments = $("textarea#id_comments").val();
	if(isCommentsEmpty(comments)){
		return;
	}
	
	var params={};
	params["comments"]=comments;

	$("input[id^=lpar_list_assign]").each(function(i){
		params[$(this).attr("name")]=$(this).attr("checked");
	});
	
	$("input[id^=lpar_list_beenAssigned]").each(function(i){
		params[$(this).attr("name")]=$(this).val();
	});

	$("input[id^=lpar_list_id]").each(function(i){
		params[$(this).attr("name")]=$(this).val();
		showProgress($(this).val());
	});

	
	$.post($("input#id_url").val(),params,statusChange);
	hideDl();

}

function isCommentsEmpty(comments){
	if(comments.trim()==""){
		alert("Comments are required.");
		return true;
	}
	return false;
}

function showProgress(alertId){
	var action = "div#id_assignment_action_"+alertId;
	var assignee = "div#id_assignment_assignee_"+alertId;

	$(action).html("wait<img src='${pageContext.request.contextPath}/images/inprogress.gif'  alt='wait, processing.' />");
	$(assignee).html("<img src='${pageContext.request.contextPath}/images/inprogress.gif'  alt='wait, processing.' />");
}

function statusChange(msg,status){
	if(status=="success"){
		var rows = msg.split('{row}');
		//split returned msg with separator.
		//[0]alert id.
		//[1]action field content.
		//[2]check field content.
		for(i=0; i<rows.length-1; i++){
			 var msgs = rows[i].split('{sep}');
	         var alertId = msgs[0].trim();

		     var action = "div#id_assignment_action_"+alertId;
		     var assignee = "div#id_assignment_assignee_"+alertId;
       
             $(action).html(msgs[1]);
             $(assignee).html(msgs[2]);
		}
	}else{
		alert("ERROR\n"+msg);
	}
}



function selectAll(psType) {
	var laElement = document.alertSoftwareLpar.elements;
	var lfoTemp = null;
	var lsName = null;

	for (var i = 0; i < laElement.length; i++) {
		lfoTemp = laElement[i];
		lsName = lfoTemp.name;

		if ((psType == 'assign'
					&& lsName.length >= 14
					&& lsName.substring(0, 5) == "list["
					&& lsName.substring(lsName.length - 7, lsName.length) == ".assign")
				|| (psType == 'unassign'
					&& lsName.length >= 16
					&& lsName.substring(0, 5) == "list["
					&& lsName.substring(lsName.length - 9, lsName.length) == ".unassign")) {
			lfoTemp.checked = true;
		}
	}

	return false;
}
</script>

<style type="text/css">
.showDeck {
	display: block;
	top: 0px;
	left: 0px;
	margin: 0px;
	padding: 0px;
	width: 100%;
	height: 100%;
	position: absolute;
	z-index: 1000;
	background: #cccccc;
	filter: alpha(opacity =     50);
	moz-opacity: 0.5;
	opacity: 0.5;
}

.showDlg {
	background-color: #ffffdd;
	border-width: 3px;
	border-style: solid;
	height: 129px;
	width: 368px;
	position: absolute;
	align: center;
	z-index: 1005;
}

.hideDlg {
	height: 129px;
	width: 368px;
	display: none;
}

.hideDeck {
	display: none;
}

th.desc a,th.asc a,th.sortable a {
	background-position: right;
	background-repeat: no-repeat;
	display: block;
	padding-right: 25px;
	text-align: left;
}

th.sortable a {
	background-image:
		url(${pageContext.request.contextPath}/images/icon-link-sort-u-dark.gif)
		;
}

th.desc a {
	background-image:
		url(${pageContext.request.contextPath}/images/icon-link-sort-d-dark.gif)
		;
}

th.asc a {
	background-image:
		url(${pageContext.request.contextPath}/images/icon-link-sort-a-dark.gif)
		;
}
</style>