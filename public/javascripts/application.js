// ---- Stuff we always want to do on load (UJS sort of stuff)  ----

$(function(){
    // Setup for input fields
    $('input[data-type|="date"]').datepicker({
        dateFormat: 'yy-mm-dd'
    });
    $("form[data-confirm]").each(function(){
        // TODO : The same dialog is re-initialized many times if the confirmation
        // is in a table. This is bad because 1) it wipes out the dialog text, if
        // it is different, and 2) its wasteful.
        setupConfirmationDialog($("#dialog"), $(this), $(this).attr("data-confirm"));
    });
// Automatically apply JQuery validation for simple forms
// Note that this is currently commented out because it is playing a bit
// strangely with some of the other JQuery UI components like the datepicker.
//$(".simple_form").validate({
//    errorPlacement: function(error, element) {
//        error.insertBefore(element);
//    }
//});


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
ConfirmationDialog = $.extend({}, $.ui.dialog.prototype, {
    options: {
        onConfirm: function(){
            alert("'onConfirm' action on dialog not properly specified.")
        },
        title: "Confirmation Dialog",
        modal: true,
        closeOnEscape: false,
        resizable: false,
        buttons: {
            "Confirm":function(event,ui){
                $(this).dialog("close");
                var confirm = $(this).dialog("option", "onConfirm");
                confirm.call();
            },
            "Cancel": function(){
                $(this).dialog("close");
            }
        }
    }
});
$.widget("ui.confirmationDialog", $.ui.dialog, ConfirmationDialog);

setupConfirmationDialog = function(dialogHandle, domHandle, dialogText){
    // Setup the options on the dialog
    dialogHandle.dialog({
        modal:true,
        closeOnEscape:false,
        autoOpen:false,
        resizable:false,
        buttons : {
            "Confirm" : function() {
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

// ---- Custom Knockout JS bindings and stuff ----
ko.bindingHandlers.confirm = {
    init: function(element, valueAccessor, allBindingsAccessor, viewModel) {
        var valueUnwrapped = ko.utils.unwrapObservable(valueAccessor());
        setupConfirmationDialog($("#dialog"), $(element), valueUnwrapped);
    },
    update: function(element, valueAccessor, allBindingsAccessor, viewModel) {
    // NO-OP - for now, no support for dynamic dialog text.
    }
}

ko.protectedObservable = function(initialValue) {
    var result = ko.observable(initialValue);


    //expose temp value for binding.  ko.toJS is an easy way to get a clean copy
    result.temp = ko.observable(ko.toJS(initialValue));
    result.errors = ko.observable();

    //apply edits to the original (only goes one level deep)
    result.commit = function() {
        var original = result(),
            edited = result.temp();

        for (var prop in edited) {
            if (original.hasOwnProperty(prop)) {
                if (ko.isWriteableObservable(original[prop])) {
                   original[prop](edited[prop]);
                   //ignore dependentObservables + methods
                } else if (typeof original[prop] !== "function") {
                   original[prop] = edited[prop];
                }
            }
        }

        return result; //for chaining
    };

    //start over with a new value
    result.init = function(newValue) {
        result.temp(ko.toJS(newValue));
        result(newValue);
        return result;  //for chaining
    }

    //revert back to a fresh copy
    result.reset = function(newValue){
        result.temp(ko.toJS(result));
        return result;  //for chaining
    };

    //clear it out, so it is ready for a new one
    result.clear = function() {
       result.temp(null);
       result(null);
       return result; //for chaining
    }

    return result;
  };