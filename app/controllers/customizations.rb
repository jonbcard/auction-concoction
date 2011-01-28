AuctionNow.controllers :customizations do

  get :index do
    render 'customizations/index'
  end

  get :edit, :with => :model do
    @custom = Customization.first_or_create(:model => params[:model])
    render 'customizations/edit'
  end

  post :edit, :with => :model do
    # TODO : Add proper validation
    @custom = Customization.first_or_create(params[:model])
    custom_fields = JSON.parse(params[:custom_fields])
    if @custom.set(:custom_fields => custom_fields)
      flash[:notice] = 'Record was successfully updated.'
      redirect url(:customizations, :edit, :model => @custom.model)
    else
      render 'customizations/edit'
    end
  end

end