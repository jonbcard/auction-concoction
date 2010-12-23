// ---- Stuff we always want to do on load (UJS sort of stuff)  ----

$(function(){
    // Setup for input fields
    $('input[data-type|="date"]').datepicker();
    $("form[data-confirm]").each(function(){
        // TODO : The same dialog is re-initialized many times if the confirmation
        // is in a table. This is bad because 1) it wipes out the dialog text, if
        // it is different, and 2) its wasteful.
        setupConfirmationDialog($("#dialog"), $(this), $(this).attr("data-confirm"));
    });

});

// ---- General helper functions ----

String.prototype.startsWith = function(str){
    // TODO: kind of slow implementation. It would be nice
    // to have this check as lightening fast as possible.
    return (this.indexOf(str) === 0);
}

var nullOrEmpty = function(value){
    return value == null || value.length == 0
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

// ---- JQuery helper stuff ----
setupConfirmationDialog = function(dialogHandle, domHandle, dialogText){
    // Setup the options on the dialog
    dialogHandle.dialog({
        modal:true,
        closeOnEscape:false,
        autoOpen:false,
        resizable:false,
        buttons : {
            "Confirm" : function() {
                $(this).dialog("close");
                domHandle.get()[0].submit();
            },
            "Cancel" : function() {
                $(this).dialog("close");
            }
        }
    });

    domHandle.bind("submit", function(e){
        $("#dialog").html(dialogText);
        $("#dialog").dialog('open');
        return false;
    });

    domHandle.click(function(e){
        e.stopPropagation();
    });
}

ajaxSubmit = function(form, successHandler){
    var type = form.attr("method");
    var method = form.attr("action");
    $.ajax({
        type: form.attr("method"),
        url: form.attr("action"),
        data: form.serialize(),
        dataType: 'json',
        success: successHandler,
        error: function(request, status, error_thrown){
            alert(error_thrown);
        }
    });
}

// ---- Custom Knockout JS bindings ----
ko.bindingHandlers.confirm = {
    init: function(element, valueAccessor, allBindingsAccessor, viewModel) {
        var valueUnwrapped = ko.utils.unwrapObservable(valueAccessor());
        setupConfirmationDialog($("#dialog"), $(element), valueUnwrapped);
    },
    update: function(element, valueAccessor, allBindingsAccessor, viewModel) {
    // NO-OP - for now, no support for dynamic dialog text.
    }
}