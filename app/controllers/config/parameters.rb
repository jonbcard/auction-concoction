AuctionNow.controllers :parameters do

  get :index, :provides => [:html, :json] do
    @profiles = Profile.all
    @app_parameters = AppParameters.get
    case content_type
      when :html
        render "config/parameters_index"
      when :json
        return @app_parameters.to_json
    end
  end

  post :update, :provides => :json do
    # TODO: Appears to still be saving when there are validation errors
    @app_parameters = AppParameters.get
    if @app_parameters.update_attributes(parse_json(request))
      return @app_parameters.to_json
    else
      return {
        :error_summary => "Validation errors occurred while attempting to save the record.",
        :errors => @app_parameters.errors}.to_json
    end
  end
  
end