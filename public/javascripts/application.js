// TODO : Organize this file a little better

String.prototype.startsWith = function(str){
    // TODO: kind of slow implementation. It would be nice
    // to have this check as lightening fast as possible.
    return (this.indexOf(str) === 0);
}

/**
 * Note : eventually we'll need to add support for doing sort comparisons
 * other than just by Strings. This should be good enough (for now), though.
 */
var sortArrayByProperty = function(array, property){
    return array.sort(function(a,b) {
        var x = eval("a." + property);
        var y = eval("b." + property);
        if(x == null) return (y==null) ? 0 : 1;
        return ((x < y) ? -1 : ((x > y) ? 1 : 0));  
    });
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

    // Stop events from propogating further when we're pulling up
    // a confirmation dialog.
    $("form[data-confirm]").click(function(e){
        e.stopPropagation();
        return true;
    });

    // Little hack to get the popup dialog working for now
    var confirmed = false;
    $("form[data-confirm]").submit(function(e){
        var dialogText = $(this).attr("data-confirm");

         var form = $(this);
        $("#dialog").html(dialogText);
        $("#dialog").dialog({
            buttons : {
                "Confirm" : function() {
                    confirmed = true;
                    form.submit();
                },
                "Cancel" : function() {
                    $(this).dialog("close");

                }
            }
        });
        $("#dialog").dialog('open');
        return confirmed;
    });
    	
});

// ---- Custom knockout bindings ----

// TODO - This is broken when used in a table for some reason..
// TODO - Cleanup code to not duplicate the data-confirm stuff..
ko.bindingHandlers.confirm = {
    init: function(element, valueAccessor, allBindingsAccessor, viewModel) {
        var value = valueAccessor();
        var valueUnwrapped = ko.utils.unwrapObservable(value);
        var confirmed = false;

        $(element).click(function(e){
            e.stopPropagation();
            return true;
        });

        $(element).submit(function(e){
            if(!confirmed){
                var form = $(element);
                $("#dialog").html(valueUnwrapped);
                $("#dialog").dialog({
                    buttons : {
                        "Confirm" : function() {
                            confirmed = true;
                            form.submit();
                        },
                        "Cancel" : function() {
                            $(this).dialog("close");
                        }
                    }
                });
                $("#dialog").dialog('open');
            }
            return confirmed;
        });
    },
    update: function(element, valueAccessor, allBindingsAccessor, viewModel) {
        var value = valueAccessor();
        var valueUnwrapped = ko.utils.unwrapObservable(value);
        $("#dialog").html(valueUnwrapped);
    }
}