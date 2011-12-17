AuctionNow.controllers :profiles do
  get :index, :provides => [:html, :json] do
    case content_type
      when :html
        render 'config/profiles_index'
      when :json
        Profile.all.to_json
    end
  end

  post :new, :provides => [:json] do
    @profile = Profile.new(parse_json(request))
    if @profile.save
      return @profile.to_json
    else
      return {:errors => @profile.errors}.to_json
    end
  end

  get :index, :with => :id, :provides => :json do
    return Profile.find(params[:id]).to_json
  end

  post :index, :with => :id, :provides => :json do
    @profile = Profile.new(parse_json(request))
    if !@profile.save
      return {:errors => @profile.errors}.to_json
    else
      return @profile.to_json
    end
  end
end