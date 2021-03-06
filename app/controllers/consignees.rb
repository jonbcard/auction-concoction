AuctionNow.controllers :consignees do
  get :index, :provides => [:html, :json] do
    case content_type
      when :html
        render 'consignees_index'
      when :json
        Consignee.all.to_json
    end
  end
  
  get :index, :with => :id, :provides => :json do
    return Consignee.find(params[:id]).to_json
  end
  
  get :code, :with => :code, :provides => :json do
    result = Consignee.by_code(params[:code]).first
    return result ? result.to_json : nil
  end
  
  post :search, :provides => [:json] do
    criteria = parse_json(request)
    query_params = {}
    query_params[:code] = criteria["code"] unless criteria["code"].blank?
    query_params[:name] = /#{criteria["name"]}/i unless criteria["name"].blank?
    Consignee.where(query_params).to_json
  end

  post :new, :provides => [:json] do
    @consignee = Consignee.new(parse_json(request))
    if @consignee.save
      return @consignee.to_json
    else
      return {:errors => @consignee.errors}.to_json
    end
  end

  post :index, :with => :id, :provides => :json do
    @consignee = Consignee.new(parse_json(request))
    if !@consignee.save
      return {:errors => @consignee.errors}.to_json
    else
      return @consignee.to_json
    end
  end
end