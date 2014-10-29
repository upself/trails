// project.js

// newFunction
function newFunction() {
}

function checkAll(theForm) { // check all the checkboxes in the list
	for (var i=0;i<theForm.elements.length;i++) {
		var e = theForm.elements[i];
		var eName = e.name;
		
		if (eName != 'allbox' && (e.type.indexOf("checkbox") == 0)) {
			if (! e.disabled) {
				e.checked = theForm.allbox.checked;
			}
		}
	} 
}

// Check all the checkboxes in the list
function checkAll(pForm, psAllCheckboxName, psCheckboxName) {
	var lsName = null;

	for (var i = 0; i < pForm.elements.length; i++) {
		var leTemp = pForm.elements[i];
		
		if (leTemp.name != psAllCheckboxName &&
				leTemp.name == psCheckboxName &&
				leTemp.type.indexOf("checkbox") == 0 &&
				!leTemp.disabled) {
			leTemp.checked = pForm[psAllCheckboxName].checked;
		}
	} 
}

function openUserGuide(url){
    if(url==""||url ==  null){
     url = "http://tap.raleigh.ibm.com/helpdocs/bravo/en/bravo_userguide_en.pdf";
    }
    if(confirm('Open the user guide in new window?')){
        window.open (url, "UserGuide", "scrollbars,resizable");
    }
    return false;   
}
