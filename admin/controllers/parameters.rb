Admin.controllers :parameters do

  get :index do
    @app_parameters = AppParameters.get
    render "parameters/index"
  end

  put :update do
    @app_parameters = AppParameters.get
    if @app_parameters.update_attributes(params[:app_parameters])
      flash[:notice] = 'Application Parameters were successfully updated.'
      redirect url(:parameters, :index)
    else
      render 'parameters/index'
    end
  end
end