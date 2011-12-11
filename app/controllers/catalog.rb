AuctionNow.controllers :catalog do
  
  get :index, :provides => [:html, :json] do
    case content_type
      when :html
        render 'catalog_index'
      when :json
        CatalogItem.all.to_json
    end
  end
  
  get :index, :with => :id, :provides => :json do
    return  CatalogItem.find(params[:id]).to_json
  end
  
  get :number, :with => :number, :provides => :json do
    result =  CatalogItem.by_number(params[:number]).first
    return result ? result.to_json : nil
  end
  
  post :search, :provides => [:json] do
    criteria = parse_json(request)
    query_params = {}
    query_params[:number] = criteria["number"] unless criteria["number"].blank?
    query_params[:description] = /#{criteria["description"]}/i unless criteria["description"].blank?
    Catalog.where(query_params).to_json
  end

  post :new, :provides => [:json] do
    @item = CatalogItem.new(parse_json(request))
    if @item.save
      return @item.to_json
    else
      return {:errors => @item.errors}.to_json
    end
  end

  post :index, :with => :id, :provides => :json do
    @item = CatalogItem.new(parse_json(request))
    if !@item.save
      return {:errors => @item.errors}.to_json
    else
      return @item.to_json
    end
  end
end