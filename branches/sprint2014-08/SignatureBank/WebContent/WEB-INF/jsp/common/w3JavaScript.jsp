<script>
var checkflag = "false";
function check(field)
{
 var i;
 if (eval(field[0].checked))
 {
  for (i=0;i<field.length;i++)
    field[i].checked=true;
  LL(field); 
  return "Uncheck All";
 } 
 else
 { 
   for(i=0;i<field.length;i++)
     field[i].checked=false;
   UU(field); 
   return "Check All";
 } 
}
function LL(field){field.disabled=true;}
function UU(field){field.disabled=false;}


function displayPopUp(page) {
	
	window.open(page, 'PopUpWindow', 'left=200,top=180,resizable=yes,scrollbars=yes,width=700,height=500');
}

</script>
