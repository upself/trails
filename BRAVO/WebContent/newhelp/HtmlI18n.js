//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=//
// file: HtmlI18n.js
//
// use:
//	Reference this script in a proxy HTML document.  When an alternate 
//		language is selected, the file will be loaded that has the 
//		same name as the proxy in the directory with the same name 
//		as the ISO639-1 language code:
//		.../help/file.html will load .../help/en/file.html
//	docRoot is the relative base URL, including the trailing slash, where 
//		this script is used.
//	To source the script (for use with body's onload attribute):
//		<head>
//			<script type="text/javascript" language="JavaScript" src="HtmlI18n.js">
//			</script>
//		</head>
//	To have a document loaded by default (the loaded language is the first, 
//		or previously selected, language in the drop-down):
//		<body onload="HtmlI18n_onSelect( docRoot )" ...>
//	To add the language selection form:
//		<script type="text/javascript">
//		<!--//
//			HtmlI18n_writeForm( docRoot );
//		//-->
//		</script>
//
// creation: This script loads files with identical names with the language 
//	code inserted (with a slash) between the last slash and the file name.
//		example: http://tld.com/path/to/file.html#anchor
//		becomes: http://tld.com/path/to/lc/file.html#anchor
//		or:      http://tld.com/path/to/lc-var/file.html#anchor
//	where 'lc' and 'lc-var' is an ISO-629-1 language code.
// created: 2007-08-14
// creator: Milburn Young
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=//
// Specify the default file used by the web server when no file 
//	is specified in the URL.
var HtmlI18n_defaultFile = "index.html";
var HtmlI18n_promptedLanguages = 
[ 
	"English", 
];
var HtmlI18n_dropDownLanguages = 
[ 
	"English", 
//	"Japanese", 
//	"Korean", 
//	"Simplified Chinese", 
//	"Thai", 
//	"Traditional Chinese", 
];
var HtmlI18n_cfg = new Object();
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=//
HtmlI18n_cfg[ "English" ] = new HtmlI18n_Language( "en" );
HtmlI18n_cfg[ "English" ].labels[ "English" ] = "English";
HtmlI18n_cfg[ "English" ].labels[ "language" ] = "Language";
HtmlI18n_cfg[ "English" ].labels[ "select" ] = "Select";
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=//
HtmlI18n_cfg[ "Japanese" ] = new HtmlI18n_Language( "ja" );
HtmlI18n_cfg[ "Japanese" ].labels[ "Japanese" ] = "nihongo (Japanese)";
HtmlI18n_cfg[ "Japanese" ].labels[ "language" ] = "kotoba";
HtmlI18n_cfg[ "Japanese" ].labels[ "select" ] = "serekuto";
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=//
// Source YongHoon Youn/Korea/IBM@IBMKR (younyh@kr.ibm.com).
HtmlI18n_cfg[ "Korean" ] = new HtmlI18n_Language( "ko" );
HtmlI18n_cfg[ "Korean" ].labels[ "Korean" ] = "&#xD55C;&#xAD6D;&#xC5B4; (Korean)";
HtmlI18n_cfg[ "Korean" ].labels[ "language" ] = "&#xC5B8;&#xC5B4;";
HtmlI18n_cfg[ "Korean" ].labels[ "select" ] = "&#xC120;&#xD0DD;";
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=//
HtmlI18n_cfg[ "Simplified Chinese" ] = new HtmlI18n_Language( "zh-hans" );
HtmlI18n_cfg[ "Simplified Chinese" ].labels[ "Simplified Chinese" ] = "&#x6B63;&#x4F53;&#x5B57; (Simplified Chinese)";
HtmlI18n_cfg[ "Simplified Chinese" ].labels[ "language" ] = "&#x8BED;";
HtmlI18n_cfg[ "Simplified Chinese" ].labels[ "select" ] = "&#x6311;&#x9009;";
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=//
HtmlI18n_cfg[ "Thai" ] = new HtmlI18n_Language( "th" );
HtmlI18n_cfg[ "Thai" ].labels[ "Thai" ] = "&#x0E44;&#x0E17;&#x0E22; (Thai)";
HtmlI18n_cfg[ "Thai" ].labels[ "language" ] = "&#x0E20;&#x0E32;&#x0E29;&#x0E32;";
HtmlI18n_cfg[ "Thai" ].labels[ "select" ] = "&#x0E40;&#x0E25;&#x0E37;&#x0E2D;&#x0E01;";
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=//
HtmlI18n_cfg[ "Traditional Chinese" ] = new HtmlI18n_Language( "zh-hant" );
HtmlI18n_cfg[ "Traditional Chinese" ].labels[ "Traditional Chinese" ] = "&#x7E41;&#x9AD4;&#x4E2D;&#x6587; (Traditional Chinese)";
HtmlI18n_cfg[ "Traditional Chinese" ].labels[ "language" ] = "&#x8A9E;&#x8A00;";
HtmlI18n_cfg[ "Traditional Chinese" ].labels[ "select" ] = "&#x9078;&#x64C7;";
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=//
function HtmlI18n_Language( iso_639_1, direction )
{
	this.path = this.lang = iso_639_1;
	this.dir = direction || "ltr";
	this.labels = new Object();
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=//
function HtmlI18n_getLabel( key )
{
	var sep = new String( " / " );
	var label;
	for( var index in HtmlI18n_promptedLanguages )
	{
		var language = HtmlI18n_promptedLanguages[ index ];
		if( !label )
		{
			label = HtmlI18n_cfg[ language ].labels[ key ];
		}
		else
		{
			label += sep + HtmlI18n_cfg[ language ].labels[ key ];
		}
	}
	return( label );
}
/*
function HtmlI18n_guessLanguage()
{
	var language = (navigator.language)?(navigator.language):(navigator.userLanguage);
	// Determine if there's a hyphen in the language value after the first 2 positions.
	var index = language.indexOf( "-", 2 );
	if( index != -1 )
	{
		language = language.substring( 0, index );
	}
	return( language );
}
*/
function HtmlI18n_onSelect( docRoot )
{
	var path_re = /(?:(?:[^\?\#])*?[\/])*/;
	var file = document.location.pathname;
//test//	alert( file );
		file = file.replace( path_re, "" );
		if( file == "" )
		{
//test//	alert( "Using default file." );
			file = HtmlI18n_defaultFile;
		}
	var select = document.forms.languageForm.languageSelect;
	var newUrl = docRoot;
	var index = select.selectedIndex;
	if( index != -1 )
	{
		var language = select.options[ index ].value;
		newUrl += language + "/";
	}
	newUrl += file;
	var anchor = document.location.hash;
	if( anchor )
	{
		newUrl += "#" + anchor;
	}
//test//	alert( newUrl );
	window.document.all.languageDiv.innerHTML = '<iframe' 
			+ ' id="languageIFrame"' 
			+ ' frameborder="0"' 
			+ ' width="100%"' 
			+ ' height="' + window.screen.height + '"' 
			+ ' src="' + newUrl + '"' 
			+ '></iframe>';
	return( true );
}
function HtmlI18n_writeButton( label, docRoot )
{
	// 'button-blue' is a w3 v8 CSS class.
	// 'onkeypress' is important for accessibility.
	window.document.writeln( '<input' 
		+ ' class="button-blue"' 
		+ ' type="button"' 
		+ ' id="languageButton"' 
		+ ' name="languageButton"' 
		+ ' value="' + label + '"' 
		+ ' onclick="return(HtmlI18n_onSelect(\'' + docRoot + '\'));"' 
		+ ' onkeypress="return(this.onclick());"' 
		+ '/>' );
}
function HtmlI18n_writeForm( docRoot )
{
	window.document.writeln( '<form' 
		+ ' id="languageForm"' 
		+ ' name="languageForm"' 
		+ '>' );
	HtmlI18n_writeSelect( HtmlI18n_getLabel( "language" ));
	window.document.writeln( '&nbsp;' );
	HtmlI18n_writeButton( HtmlI18n_getLabel( "select" ), docRoot );
	window.document.writeln( '</form>' );
}
function HtmlI18n_writeSelect( label )
{
	// Label form field for accessibility.
	window.document.writeln( '<label' 
		+ ' for="languageSelect"' 
		+ '>' + label + '</label>' );
	// Open form ('name' required with 'input' 'type' 'button').
	window.document.writeln( '<select' 
		+ ' id="languageSelect"' 
		+ ' name="languageSelect"' 
		+ ' size="1"' 
		+ '>' );
	for( var index in HtmlI18n_dropDownLanguages )
	{
		var language = HtmlI18n_dropDownLanguages[ index ];
		window.document.writeln( '<option' 
			+ ' value="' + HtmlI18n_cfg[ language ].path + '"' 
			+ ' lang="' + HtmlI18n_cfg[ language ].lang + '"' 
			+ ' xml:lang="' + HtmlI18n_cfg[ language ].lang + '"' 
			+ ' dir="' + HtmlI18n_cfg[ language ].dir + '"'
			+ '>' 
				+ HtmlI18n_cfg[ language ].labels[ language ] 
//				+ " (" + language + ")" 
			+ '</option>' );
	}
	// Close form.
	window.document.writeln( '</select>' );
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=//