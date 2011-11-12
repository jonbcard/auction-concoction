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
var util = new function() {
    
    /* Get JSON syncronously from the server */
    this.getJSON = function(url){
        var result = null;
        $.ajax({
            url: url,
            dataType: 'json',
            async: false,
            success: function(data){
                result = data;
            }
        });
        return result;
    }
    
    this.todayAsDate = function(){
        var day = new Date();
        day.setHours(0); 
        day.setMinutes(0); 
        day.setSeconds(0); 
        return day;
    }
    
    /**
     * Note : eventually we'll need to add support for doing sort comparisons
     * other than just by Strings. This should be good enough (for now), though.
     */
    this.sortArrayByProperty = function(array, property){
        return array.sort(function(a,b) {
            var x = eval("a." + property);
            var y = eval("b." + property);
            if(x == null) return (y==null) ? 0 : 1;
            return ((x < y) ? -1 : ((x > y) ? 1 : 0));  
        });
    }
};

// ---- JQuery helper stuff ----
ConfirmationDialog = $.extend({}, $.ui.dialog.prototype, {
    options: {
        onConfirm: function(){
            alert("'onConfirm' action on dialog not properly specified.")
        },
        create: function() {
            $('.ui-dialog-buttonpane')
            .find('button:contains("Cancel")').button({
                icons: {
                    primary: 'ui-icon-cancel'
                }
            });
            $('.ui-dialog-buttonpane')
            .find('button:contains("Confirm")').button({
                icons: {
                    primary: 'ui-icon-check'
                }
            });
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

ko.utils.stringStartsWith = function (string, startsWith) {        
    string = string || "";
    if (startsWith.length > string.length)
        return false;
    return string.substring(0, startsWith.length) === startsWith;
};

ko.isProperty = function(instance){
    return ((typeof instance == "function") && instance.__ko_proto__ === ko.property);
}

ko.tempToJS = function(rootObject) {   
    var unwrappedObject = ko.utils.unwrapObservable(rootObject);
    var outputProperties = {};
    for (var prop in unwrappedObject) {
        if(ko.isProperty(unwrappedObject[prop])){
            outputProperties[prop] = unwrappedObject[prop].temp;
        }
    }
    return outputProperties;
}

ko.tempToJSON = function(rootObject) {
    var plainJavaScriptObject = ko.tempToJS(rootObject);
    return ko.utils.stringifyJson(plainJavaScriptObject);
};

ko.bindingHandlers.confirm = {
    init: function(element, valueAccessor, allBindingsAccessor, viewModel) {
        var valueUnwrapped = ko.utils.unwrapObservable(valueAccessor());
        setupConfirmationDialog($("#dialog"), $(element), valueUnwrapped);
    },
    update: function(element, valueAccessor, allBindingsAccessor, viewModel) {
        // NO-OP - for now, no support for dynamic dialog text.
    }
}

ko.bindingHandlers.mask = {
    init: function (element, valueAccessor) {
        var value = valueAccessor();
        $(element).mask(ko.utils.unwrapObservable(value));
    },
    update: function (element, valueAccessor) {
        // Nothing to do
    }
};

ko.protectedObservable = function(initialValue) {
    var result = ko.observable(initialValue);

    //expose temp value for binding.  ko.toJS is an easy way to get a clean copy
    result.temp = ko.observable(ko.toJS(initialValue));
    result.temp.model = result;

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
  
ko.model = function(initialValue) {
    var result = ko.observable(initialValue);
     
    result.hasErrors = ko.observable(false);
    
    this.save = function(){
        if(id == undefined){
            // create the record
            $.ajax({
                url:  result().url + "/new.json",
                type: "post",
                data: ko.tempToJSON(result()),
                contentType: "application/json",
                success: function(serverResult) {
                    if(serverResult.errors){
                        result.applyErrors(serverResult.errors);
                    } else {
                        result.commit();
                        result().id(serverResult.id);
                        result().onCreate();
                    }
                }
            });
        } else {
            // save the record
            $.ajax({
                url:  result().url + result.id + ".json",
                type: "post",
                data: ko.tempToJSON(this),
                contentType: "application/json",
                success: function(serverResult) {
                    if(serverResult.errors){
                        result.applyErrors(serverResult.errors);
                    } else {
                        result.commit().reset();
                        result().onSave();
                    }
                }
            });
        }
    }
    
    // Clear all errrors from the properties
    result.clearErrors = function(){
        result.hasErrors(false);
        var edited = result();
        for(var prop in edited){
            if(ko.isProperty(edited[prop])){
                edited[prop].errors("");
            }
        }
    }

    // Apply errors (received from the server) back to the properties
    result.applyErrors = function(errors){
        result.clearErrors();
        result.hasErrors(true);
        var edited = result();
        for(var prop in errors){
            if(edited.hasOwnProperty(prop) && ko.isProperty(edited[prop])){
                edited[prop].errors(errors[prop]);
            }
        }
    }

    // Iterate over all properties on the model and commit them
    result.commit = function() {
        result.clearErrors();
        var original = result();
        for (var prop in original) {
            if (ko.isProperty(original[prop])) {
                original[prop].commit();
            }
        }
       
        return result; //for chaining
    };

    // Revert back to a fresh copy -- this is done by resetting all
    // properties back to their initial state.
    result.reset = function(newValue){
        var original = result();
        result.clearErrors();
        for (var prop in original) {
            if (ko.isProperty(original[prop])) {
                original[prop].reset();
            }
        }
        return result;  //for chaining
    };

    return result;
};
  
ko.property = function(initialValue, errors) {
    var result = ko.observable(initialValue);
    result.errors = ko.observable(errors);
    result.temp = initialValue;
    
    result.commit = function(){
        result(result.temp);
    };
    
    result.reset = function(){
        result.temp = result();
    }
    
    result.__ko_proto__ = ko.property;
    return result;
};