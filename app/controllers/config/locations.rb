AuctionNow.controllers :locations do
  get :index, :provides => [:html, :json] do
    case content_type
      when :html
        render 'config/locations_index'
      when :json
        Location.all.to_json
    end
  end

  post :new, :provides => [:json] do
    @location = Location.new(parse_json(request))
    if @location.save
      return @location.to_json
    else
      return {:errors => @location.errors}.to_json
    end
  end

  get :index, :with => :id, :provides => :json do
    return Location.find(params[:id]).to_json
  end

  post :index, :with => :id, :provides => :json do
    @location = Location.new(parse_json(request))
    if !@location.save
      return {:errors => @location.errors}.to_json
    else
      return @location.to_json
    end
  end
end