AuctionNow.controllers :customizations do

  get :index do
    render 'customizations/index'
  end

  get :edit, :with => :model do
    @custom = Customization.get_by_model_name(params[:model])
    render 'customizations/edit'
  end

  post :edit, :with => :model do
    # TODO : Add proper validation
    @custom = Customization.get_by_model_name(params[:model])
    custom_fields = JSON.parse(params[:custom_fields])
    @custom.custom_fields = custom_fields
    if  @custom.valid? && @custom.save
      flash[:notice] = 'Record was successfully updated.'
      redirect url(:customizations, :index)
    else
      render 'customizations/edit'
    end
  end

end