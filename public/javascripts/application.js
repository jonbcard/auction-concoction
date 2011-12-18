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
});

// ---- General helper functions ----
(function() {
    // ---- General helper functions ----
    util = {};
    
    /* Get JSON syncronously from the server */
    util.getJSON = function(url){
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
    
    util.ajaxSubmit = function(form, successHandler){
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
    
    util.todayAsDate = function(){
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
    util.sortArrayByProperty = function(array, property){
        return array.sort(function(a,b) {
            var x = eval("a." + property);
            var y = eval("b." + property);
            if(x == null) return (y==null) ? 0 : 1;
            return ((x < y) ? -1 : ((x > y) ? 1 : 0));  
        });
    }
    
    
}).call(this);

// ---- JQuery helper stuff ----
$.extend( $.validator.defaults, {
    onkeyup: false,
    errorPlacement: function(error, element) {
        var errorDiv = element.next();
        error.appendTo(errorDiv);
    },
    highlight: function(element, errorClass, validClass) {
        $(element).addClass(errorClass).removeClass(validClass);
        var errorDiv = $(element).next();
        $(errorDiv).show();
    },
    unhighlight: function(element, errorClass, validClass) {
        if(element != null){
            $(element).removeClass(errorClass).addClass(validClass);
            var errorDiv = $(element).next();
            $(errorDiv).hide();
        }
    }
});

$.widget("ui.confirmationDialog", $.ui.dialog, $.extend({}, $.ui.dialog.prototype, {
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
}));

$.widget("ui.verticalTabs", $.ui.tabs, {
    _create: function() {
        this._super( "_create" );
        $("#tabs").addClass('ui-tabs-vertical ui-helper-clearfix');
        $("#tabs li").removeClass('ui-corner-top').addClass('ui-corner-left');
    }
});

setupConfirmationDialog = function(dialogHandle, domHandle, dialogText){
    // Setup the options on the dialog
    dialogHandle.confirmationDialog({
        autoOpen : false,
        onConfirm : function(){
            domHandle.get()[0].submit();
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

$.growlError = function(title, message) {
	var $m = $('<div class="growlUIError"></div>');
	if (title) $m.append('<h1>'+title+'</h1>');
	if (message) $m.append('<h4>'+message+'</h4>');
        $m.append('(click to close)');
	$.blockUI({
		message: $m, fadeIn: 700, centerY: false,
		showOverlay: false,
		css: $.blockUI.defaults.growlCSS
	});
        $('.growlUIError').click($.unblockUI); 
};

// ---- Custom Knockout JS bindings and stuff ----
ko.bindingHandlers.confirm = {
    init: function(element, valueAccessor, allBindingsAccessor, viewModel) {
        var valueUnwrapped = ko.utils.unwrapObservable(valueAccessor());
        setupConfirmationDialog($("#dialog"), $(element), valueUnwrapped);
    }
}

ko.bindingHandlers.mask = {
    init: function (element, valueAccessor) {
        var value = valueAccessor();
        $(element).mask(ko.utils.unwrapObservable(value));
    }
};

ko.bindingHandlers.icon = {
    init: function (element, valueAccessor, allBindings) {
        var icon = valueAccessor();
        var iconSecondary = allBindings.iconOnly || null;
        var iconOnly = allBindings.iconOnly || false;
        
        $(element).button({
            text: !iconOnly,
            icons: {
                primary: ko.utils.unwrapObservable(icon),
                secondary: ko.utils.unwrapObservable(iconSecondary)
            }
        });
    }
};

ko.bindingHandlers.iconSecondary = {
    init: function (element, valueAccessor) {
        var value = valueAccessor();
        $(element).button({
            icons: {
                secondary: ko.utils.unwrapObservable(value)
            }
        });
    }
};

ko.bindingHandlers.type = {
    init: function (element, valueAccessor) {
        var value = valueAccessor();
        if(value == 'date'){
            $(element).datepicker({
                dateFormat: 'yy-mm-dd'
            });
        }
    }
}

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
  
ko.model = function(initialValue) {  
    
    // TODO -- add dirty detection
    var result = ko.observable(initialValue); 
     
    result.hasErrors = ko.observable(false);
    
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
    
    // Create a new record on the server
    result.save = function(url, callback){
        var wrapper = this;
        $.ajax({
            url:  url,
            type: "post",
            data: ko.tempToJSON(this),
            contentType: "application/json",
            success: function(result) {
                if(result.errors){
                    wrapper.applyErrors(result.errors);
                } else {
                    ko.mapToModel(wrapper(), result);
                    wrapper.commit();
                    if(callback){
                        callback.call(wrapper, result);
                    }
                    wrapper.reset();
                }
            }
        });
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
    
    result.subscribe(function(newValue) {
        // Ensure the temp value is kept up-to-date with change to the observable..
        // TODO: maybe just make temp a dependent-observable?
        result.temp = newValue;
    });
    
    result.commit = function(){
        result(result.temp);
    };
    
    result.reset = function(){
        result.temp = result();
    }
    
    result.__ko_proto__ = ko.property;
    return result;
};

ko.storedObservable = function(initialValue, name) {
    if(localStorage.hasOwnProperty(name)){
        try{
            initialValue = JSON.parse(localStorage.getItem(name));
        }catch(e){};
    } else {
        localStorage.setItem(name,  JSON.stringify(initialValue));
    }
    var result = ko.observable(initialValue);
    
    result.subscribe(function(newValue) {
        localStorage.setItem(name,  JSON.stringify(newValue));
    });
    
    return result;
}

ko.saveModel = function(model, url, successHandler){
    $.ajax({
        url:  url,
        type: "post",
        data: ko.tempToJSON(model),
        contentType: "application/json",
        success: function(result) {
            successHandler(result);
        }
    });
}

ko.mapToModel = function(model, json){
    for(var prop in json){
        if(model.hasOwnProperty(prop) && (ko.isWriteableObservable(model[prop]) || ko.isProperty(model[prop])) ){
            model[prop](json[prop]);
        }
    }
    return model; // for chaining
}

ko.mapToModelList = function(modelType, data, viewModel){
    var results = $.map(data, function(json) {
        var model = new modelType(viewModel, json.id);
        return ko.mapToModel(model, json);
    });
    return results;
}