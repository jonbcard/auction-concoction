AuctionNow.controllers :customers do
  get :index, :provides => [:html, :json] do
    case content_type
      when :html
        render 'customers_index'
      when :json
        # TODO : way too many records to be fetching all
        Customer.all.to_json
    end
  end
 
  get :data_table, :provides => :json do
    colName = [:company_name , :first_name, :last_name, :email, :bidder_number]
    order = colName[params[:iSortCol_0].to_i || 0]
    
    query_params = {}
    #query_params[:id_number] = params[:sSearch]
    #query_params[:bidder_number] = params[:sSearch]
    #query_params[:company_name] = /#{params[:sSearch]}/i
    query_params[:first_name] = /#{params[:sSearch]}/i
    #query_params[:last_name] = /#{params[:sSearch]}/i
    
    customers = Customer.where(query_params).sort(order)
    query_count = Customer.where(query_params).count
    
    {"sEcho" => params[:sEcho].to_i,
     "iTotalRecords" => Customer.count,
     "iTotalDisplayRecords" => query_count,
     "aaData" => @customers
    }.to_json
  end
  
  get :index, :with => :id, :provides => :json do
    return Customer.find(params[:id]).to_json
  end
  
  post :search, :provides => [:json] do
    criteria = parse_json(request)
    query_params = {}
    query_params[:id_number] = criteria["id_number"] unless criteria["id_number"].blank?
    query_params[:bidder_number] = criteria["bidder_number"] unless criteria["bidder_number"].blank?
    query_params[:company_name] = /#{criteria["company_name"]}/i unless criteria["company_name"].blank?
    query_params[:first_name] = /^#{criteria["first_name"]}/i unless criteria["first_name"].blank?
    query_params[:last_name] = /^#{criteria["last_name"]}/i unless criteria["last_name"].blank?
    query_params[:phone] = criteria["phone"] unless criteria["phone"].blank?
    query_params[:email] = /^#{criteria["email"]}/i unless criteria["email"].blank?
    Customer.where(query_params).to_json
  end

  post :new, :provides => [:json] do
    @customer = Customer.new(parse_json(request))
    
    if @customer.save
      return @customer.to_json
    else
      return {:errors => @customer.errors}.to_json
    end
  end

  post :index, :with => :id, :provides => :json do
    @customer = Customer.new(parse_json(request))
    if !@customer.save
      return {:errors => @customer.errors}.to_json
    else
      return @customer.to_json
    end
  end
end