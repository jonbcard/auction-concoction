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

    // Setup any confirmation dialogs
    $("#dialog").dialog({
      modal:true,
      closeOnEscape:false,
      autoOpen:false
    });    
    $("form[data-confirm]").bind("click",function(e){
        var dialogText = $(this).attr("data-confirm");
        var form = $(this);
        $("#dialog").html(dialogText);
        $("#dialog").dialog({
        buttons : {
          "Confirm" : function() {
           form.trigger("submit")
          },
          "Cancel" : function() {
            $(this).dialog("close");

          }
        }
      });
      $("#dialog").dialog('open');
      return false;
    });
    	
});