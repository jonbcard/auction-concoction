// TODO : Organize this file a little better

String.prototype.startsWith = function(str){
    // TODO: kind of slow implementation. It would be nice
    // to have this check as lightening fast as possible.
    return (this.indexOf(str) === 0);
}

var submitOnEnter = function(formId){
    $('input').keypress(function(e){
        if(e.which == 13){
            $(formId).submit();
        }
    });
}



$(document).ready(function(){
    // Setup for input fields
    $('input[data-type|="date"]').datepicker();
	
    // Setup for confirmation dialogs
    $('form[data-confirm]').live('click', function(e) {
        e.preventDefault();
        $('#dialog').dialog({
            resizable : false,
            modal : true
        });
        $("#dialog").dialog("open");
        return false;
        if (!confirm($(this).attr('data-confirm'))) {
            return false;
        }
    });
	
});