$(document).ready(function(){
	// Setup for input fields
	$('input[data-type|="date"]').datepicker();
	
	// Setup for confirmation dialogs
	$('form[data-confirm]').live('click', function(e) {
		e.preventDefault();
	  $('#dialog').dialog({
			resizable : false,
			modal : true,
		});
		$("#dialog").dialog("open");
		return false;
	  if (!confirm($(this).attr('data-confirm'))) {
	    return false;
	  }
	});
	
});