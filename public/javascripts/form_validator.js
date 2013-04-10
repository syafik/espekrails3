function HighLightTextField(obj) {
	obj.style.borderColor = "#FF6666"
	percentageMoved = 0;
	hglt_obj = obj;
	//timerId = setInterval('MerahSekejap()',100);
}

function HighLight(obj) {
	//obj.style.background = "#FFdddd"
	obj.style.color = "#FF6666"
	percentageMoved = 0;
	hglt_obj = obj;
	//timerId = setInterval('MerahSekejap()',100);
}
/////////////////////////////////////////////////////////////////////////////////////////
function MerahSekejap() {
	percentageMoved += 0.1;
	if (percentageMoved > 5) {
		hglt_obj.style.background = "white"
		clearInterval(timerId);
	}
	else {
		hglt_obj.style.background = "#FF6666"
	}
}

/////////////////////////////////////////////////////////////////////////////////////////
/*
function : checkInput
@input : regex - pattern to be matched
@input : obj - object to be checked
@input : [obj_desc] - description of the object.More formal language.Needed for 
                      displaying error to user.
@output : boolean
*/
function checkInput(regex,obj,obj_desc) {

	if (obj_desc=="") obj_desc = obj.name;

	if (obj.val() == "") {
		alert('Sila Masukkan ' + obj_desc);
		obj.focus();
		HighLightTextField(obj);
		return false;
	}
	else {
		if (!regex.test(obj.val())) {
			alert('Invalid ' + obj_desc);
			obj.focus();
			HighLightTextField(obj);
			return false;
		}
	}
	return true;
}
/////////////////////////////////////////////////////////////////////////////////////////
function checkFormat(regex,obj,obj_desc) {

	if (obj_desc=="") obj_desc = obj.name;

	if (obj.value != "") {
        var cleanFilename = obj.value.replace(/C:\\fakepath\\/i, '');
		if (!regex.test(cleanFilename)) {
			alert('Invalid ' + obj_desc);
			obj.focus();
			HighLight(obj);
			return false;
		}
	}
	return true;
}

/////////////////////////////////////////////////////////////////////////////////////////

function checkSelection(regex,obj,obj_desc) {
//alert(obj.value);
	if (obj_desc=="") obj_desc = obj.name;

	if (obj.val() == 0) {
		alert('Sila Pilih ' + obj_desc);
		obj.focus();
		HighLight(obj);
		return false;
	}

	return true;
}

/////////////////////////////////////////////////////////////////////////////////////////
//list of regular expressions
	var loginIdRegExp = /^[a-z]+\d*[a-z]*\d*[a-z]*\d*$/
	var numRegExp = /^\d+$/ 	
	var floatRegExp = /(^-*\d+$)|(^-*\d+\.\d+$)/	
	var strRegExp = /^[a-zA-Z]+$/
	var anythingRegExp = /^.*[a-zA-Z]+.*$/
	var anything = /^.+$/
	var slashRegExp = /^.*[a-zA-Z]+.*\/.+$/
	var dateformat = /^\d{1,2}(\-|\/|\.)\d{1,2}\1\d{4}$/
	//var dateDayformat = /^\d{1,2}$/
	var dateDayformat   = /(^[1-9]$)|(^[12]\d*$)|(^0[1-9]$)|(^30$)|(^31$)/
	var dateMonthformat = /(^[1-9]$)|(^0[1-9]$)|(^10$)|(^11$)|(^12$)/
	var dateYearformat = /(^20\d{2}$)/
	var dateAllYearformat = /^\d{4}$/
	var heatnoRegExp = /^\d{7}$/
	var timeFormat = /^(\d{1,2}):(\d{2})(:(\d{2}))?(\s?(AM|am|PM|pm))?$/
	var moneyRegExp = /(^\d+$)|(^\d+\.\d{1,2}$)/
	//var icnumRegExp = /^\d{12}$/
	var icnumRegExp = /^\d{12}$|^\d{6}$|^[A-Z]\d{5}$|^[A-Z][A-Z]\d{5}$/
	//var armyicnumRegExp = /^\d{8}$///|^\s{1}-+\d{5}$/
	var phoneRegExp = /(^\d+-\d+$)|(^\d{5}\d+$)/
	//var emailRegExp = /^[.a-zA-Z1-9]+@[a-zA-Z1-9]+\.[a-zA-Z1-9]+\.*[a-zA-Z1-9]*\.*[a-zA-Z1-9]*\.*[a-zA-Z1-9]*$/
	var emailRegExp = /^[a-zA-Z0-9-_\.]+@[a-zA-Z0-9]+\.[a-zA-Z0-9]+\.*[a-zA-Z0-9]*\.*[a-zA-Z0-9]*\.*[a-zA-Z0-9]*$/
	var imageRegExp = /^[a-zA-Z0-9-_\.]+\.(jpg|jpeg|gif|png)$/
