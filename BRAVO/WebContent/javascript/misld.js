	function checkUncheckAll(theElement) {
     var theForm = theElement.form, z = 0;
     while (theForm[z].type == 'checkbox' && theForm[z].name != 'checkall') {
      theForm[z].checked = theElement.checked;
      z++;
     }
    }