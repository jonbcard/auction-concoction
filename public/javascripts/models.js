var models = new function() {
    this.BaseModel = {
        display : function(){
            alert(ko.tempToJSON(this));
        }
    }
    
    
    /////////// BaseCustomer ////////////////
    
    /////////// Consignees ////////////////
    
    /** Lazy-loaded consignee list */
    var consignees = [];
    
    /** Load a consignee (by ID) from either the server or lazy cache */
    this.getConsigneeById = function(id){
        // Early out when no ID is provided
        if(!id){
            return null;
        }
        
        var result = ko.utils.arrayFirst(consignees, 
            function(con) {
                return con.id == id;
            }
            );
            
        if(!result){
            result = util.getJSON("/consignees/" + id + ".json");
            if(result){
                consignees.push(result);
            }
        }
        return result;
    };
    
    /** Load a consignee (by Code) from either the server or lazy cache */
    this.getConsigneeByCode = function(code){
        // Early out when no Code is provided
        if(!code){
            return null;
        }
        
        var result = ko.utils.arrayFirst(consignees, 
            function(con) { 
                return con.code == code; 
            }
            );

        if(!result){
            result = util.getJSON("/consignees/code/" + code);
            if(result){
                consignees.push(result);
            }
        }
        return result;
    };


    /////////// Customers ////////////////
    this.parseCustomers = function(data){
        var results = $.map(data, function(json) {
            return new models.Customer(json.id, json.bidder_number, json.company_name, json.first_name, json.last_name, json.phone, json.email, json.address, json.city, json.state);
        });
        return results;
    }
    
    this.Customer = {
        
        id : ko.property(),
        bidder_number : ko.property(),
        company_name : ko.property(),
        first_name : ko.property(),
        last_name : ko.property(),
        phone : ko.property(),
        email : ko.property(),
        address : ko.property(),
        city : ko.property(),
        state : ko.property()
    }
   
    /////////////// Lots ////////////////////
    this.parseLot = function (json){
        return new models.Lot(json.id, json.number, json.consignee_id, json.description, json.low, json.high, json.qty_available);
    }

    this.Lot = function(id, number, consignee_id, description, low, high, qty_available){
        this.id = ko.property(id)
        this.number = ko.property(number);
        this.consignee_id = ko.property(consignee_id);
        this.description = ko.property(description);
        this.low = ko.property(low);
        this.high = ko.property(high);
        this.qty_available = ko.property(qty_available || 1);
        
        var self = this;
        
        this.consignee_code = ko.dependentObservable({
            read: function () {
                var con = models.getConsigneeById(this.consignee_id());
                return (con == undefined ? null : con.code);
            },
            write: function (value) {
                var con = models.getConsigneeByCode(value);
                this.consignee_id(con == undefined ? null : con.id);
            },
            owner: self
        });
    
        this.consignee_text = ko.dependentObservable(
            function () {
                var con = models.getConsigneeById(this.consignee_id());
                return (con == undefined ? "" : "(" + con.code + ")" + " " + con.name);
            }, self
            );
            
        this.reset = function(){
            this.id("");
            this.number("");
            this.consignee_id("");
            this.description("");
            this.low("");
            this.high("");
            this.qty_available(1);
        };
        
        
    }
    
    /////////////// Sales ////////////////////
    this.parseSale = function(json){
        return new models.Sale(json.id, json.lot, json.consignee_id, json.description, json.bidder, json.price, json.quantity, json.sale_time);
    }
    
    this.Sale = function(id, lot, consignee_id, description, bidder, price, quantity, sale_time){
        this.id = ko.property(id);
        this.lot = ko.property(lot);
        this.consignee_id = ko.property(consignee_id);
        this.description = ko.property(description);
        this.bidder = ko.property(bidder);
        this.price = ko.property(price);
        this.quantity = ko.property(quantity || 1);
        this.sale_time = ko.property(sale_time);
        
        var self = this;
        
        this.consignee_code = ko.dependentObservable({
            read: function () {
                var con = models.getConsigneeById(this.consignee_id());
                return (con == undefined ? null : con.code);
            },
            write: function (value) {
                var con = models.getConsigneeByCode(value);
                this.consignee_id(con == undefined ? null : con.id);
            },
            owner: self
        });
    
        this.consignee_text = ko.dependentObservable(
            function () {
                var con = models.getConsigneeById(this.consignee_id());
                return (con == undefined ? "" : "(" + con.code + ")" + " " + con.name);
            }, self
            );
    }
};