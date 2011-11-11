var models = new function() {

    var consignees = [];
    
    /** Load a consignee (by ID) from either the server or lazy cache */
    this.getConsigneeById = function(id){
        // Early out when no ID is provided
        if(!id){ return null; }
        
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
        if(!code){ return null; }
        
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

};