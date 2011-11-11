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
  
  get :index, :with => :id, :provides => :json do
    return Customer.find(params[:id]).to_json
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