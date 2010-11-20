Admin.controllers :parameters do

  get :index do
    render "/sessions/new", nil, :layout => false
  end

  put :update do
    redirect url(:parameters, :index)
  end
end