<script src="${pageContext.request.contextPath}/js/jquery.js" type="text/javascript"></script>
<script type="text/javascript">
var orgMappedModel= new Array;
var orgFreeModel= new Array;
var orgMachineType = new Array;   

function GetXmlHttpObject()
{
  if (window.XMLHttpRequest)
  {
  // code for IE7+, Firefox, Chrome, Opera, Safari
    return new XMLHttpRequest();
  }
  if (window.ActiveXObject)
  {
  // code for IE6, IE5
    return new ActiveXObject("Microsoft.XMLHTTP");
  }
  return null;
}

function stateChanged()
{
  if(xmlhttp.readyState==1){
    $("#mapped_model_select option").remove();
    $("#free_model_select option").remove();
    $("#map_stat_not_available").css("display","none");
    $("#map_stat_wait").css("display","block");    
  }

  if (xmlhttp.readyState==4)
  {
    var result=xmlhttp.responseText;
    var modelArr = result.split('{sep}');
    
    if(result.length==0||modelArr[1]==null||modelArr[1].length==0){
      if(modelArr[0]!=null&&modelArr[0].length!=0){      
        $("#mapped_model_select").append(modelArr[0]);
      }
        $("#map_stat_wait").css("display","none");        
      if((modelArr[1]==null||modelArr[1].length==0)&&(modelArr[0]==null||modelArr[0].length==0)){
        $("#map_stat_not_available").css("display","block");
      }
    }else{
      $("#mapped_model_select").append(modelArr[0]);
      $("#free_model_select").append(modelArr[1]);
      $("#map_stat_wait").css("display","none");
    }
    
    orgMappedModel=$('#mapped_model_select>option');
    orgFreeModel=$('#free_model_select>option');
  }  
}


function getAvailableProcessorModels(value)
{
  if(value==''){
    return;
  }else{
    var defaultItem = $("#asset_processor_brand_select>option[value='']");
    if(defaultItem!=null&&defaultItem.length!=0){
      defaultItem.remove();
      $("#asset_processor_brand_select>option[value='"+value+"']").attr('selected','selected');
    }
  }
  
  xmlhttp=GetXmlHttpObject();
  if (xmlhttp==null)
  {
    alert ("Your browser does not support AJAX!");
    return;
  }
  
    
  var poststr = "processorBrand="+encodeURIComponent($("#asset_processor_brand_select").val())
               +"&pvuId="+encodeURI(${pvu.id}) + "&machineTypeId=" +
               encodeURI($("#machineTypeSelect").val());
  xmlhttp.onreadystatechange=stateChanged;  
  xmlhttp.open("POST","${pageContext.request.contextPath}/admin/pvuMapping/getAvailableProcessorModels.htm",true);
  xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  xmlhttp.setRequestHeader("Content-length", poststr.length);
  xmlhttp.setRequestHeader("Connection", "close");
  xmlhttp.send(poststr);
}

function getMachineTypes(psValue) {
	if (psValue == '') {
		return;
	} else {
		var loDefaultItem = $("#machineTypeSelect>option[value='']");

		if (loDefaultItem !=null && loDefaultItem.length!=0) {
			loDefaultItem.remove();
			$("#machineTypeSelect>option[value='"+psValue+"']").attr('selected','selected');
		}
	}

	goXmlHttp = GetXmlHttpObject();
	if (goXmlHttp == null) {
		alert("Your browser does not support AJAX!");
		return;
	}

	var lsPostString = "processorBrand=" +
		encodeURIComponent($("#asset_processor_brand_select").val()) + "&pvuId=" +
		encodeURI(${pvu.id});
	
	goXmlHttp.onreadystatechange = machineTypesStateChanged;
	goXmlHttp.open("POST", "${pageContext.request.contextPath}/admin/pvuMapping/getMachineTypes.htm", true);
	goXmlHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	goXmlHttp.setRequestHeader("Content-length", lsPostString.length);
	goXmlHttp.setRequestHeader("Connection", "close");
	goXmlHttp.send(lsPostString);
}

function machineTypesStateChanged() {
	if(goXmlHttp.readyState == 1) {
		$("#mapped_model_select option").remove();
		$("#free_model_select option").remove();
		$("#machineTypeSelect option").remove();
		$("#map_stat_not_available").css("display","none");
		$("#map_stat_mt_wait").css("display","block");
	}

	if (goXmlHttp.readyState == 4) {
		var lsResult = goXmlHttp.responseText;
		var laResult = lsResult.split('{sep}');

		if (laResult.length > 1) {
			if (lsResult.length == 0 || laResult[1] == null || laResult[1].length==0){
				if (laResult[0] != null && laResult[0].length!=0) {
					$("#mapped_model_select").append(laResult[0]);
				}
				$("#map_stat_wait").css("display","none");
				$("#map_stat_mt_wait").css("display","none");
				if ((laResult[1] == null || laResult[1].length==0) && (laResult[0] == null || laResult[0].length==0)){
					$("#map_stat_not_available").css("display","block");
				}
			} else {
				$("#mapped_model_select").append(laResult[0]);
				$("#free_model_select").append(laResult[1]);
				$("#map_stat_wait").css("display","none");
				$("#map_stat_mt_wait").css("display","none");
			}
			$("#machineTypeSelect").append(laResult[2]);
		} else {
			$("#map_stat_wait").css("display","none");
			$("#map_stat_mt_wait").css("display","none");
			$("#machineTypeSelect").append(laResult[0]);
		}

		orgMappedModel=$('#mapped_model_select>option');
		orgFreeModel=$('#free_model_select>option');
		orgMachineType=$('#machineTypeSelect>option');
	}
}

function check(name,isChecked){
  $('input[name='+name+']').each(function(){
     $(this).attr('checked',isChecked);
  });
}


function removeSelection(){
     var freeModelSelect = document.getElementById("free_model_select"); 
     for(var i=0; i < freeModelSelect.options.length; i++) 
     { 
             freeModelSelect.options[i].selected=false; // or 
     }
}


$(document).ready(function() {

   $('#remove_all_map_items').click(
      function(){
        if($(this).attr('checked')){
          check('delPvuMapIdList',true);
        }else{
          check('delPvuMapIdList',false);
        }
      }
   );
   
   $('#submit_button').click(function(){
      $("#mapped_model_select>option").each( function() {
         $(this).attr("selected", "selected");
      });//end each   
   });
   
   
   $('#asset_processor_brand_select>option').each(function(){
      $(this).removeAttr('selected');
   });
   
   $('#map_cancel').click(function(event){
      event.preventDefault();
      window.location.replace('listPvu.htm');             
   });
   
}); 
</script>


<style type="text/css">
.map_items {
	width: 250px;
	height: 120px;
}

.map_freez_width {
	width: 200px;
}

.map_dropdown_width {
	width: 300px
}

.map_result_title {
	display: block;
	width: 250px;
	height: 120px;
	text-align: center;
	float: left;
	margin: 0px;
}

.map_seprator {
	display: block;
	width: auto;
	text-align: center;
	float: left;
	margin-top: 60px;
	margin: 10px;
	margin-top: 40px;
}

.map_hidden {
	display: none;
}
</style>