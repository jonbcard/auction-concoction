AuctionNow.controllers :parameters do

  get :index do
    @app_parameters = AppParameters.get
    render "parameters/index"
  end

  put :update, :provides => :json do
    @app_parameters = AppParameters.get
    if @app_parameters.update_attributes(parse_json(request))
      return @app_parameters.to_json
    else
      return {:errors => @app_parameters.errors}.to_json
    end
  end
  
end