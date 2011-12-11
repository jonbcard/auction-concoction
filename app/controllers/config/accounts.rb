AuctionNow.controllers :accounts do

  
  get :index, :provides => [:html, :json] do
    case content_type
      when :html
        render 'accounts/index'
      when :json
        Account.all.to_json
    end
  end
  
  get :index, :with => :id, :provides => :json do
    return  Account.find(params[:id]).to_json
  end

  post :new, :provides => [:json] do
    @account = Account.new(parse_json(request))
    if @account.save
      return @account.to_json
    else
      return {:errors => @account.errors}.to_json
    end
  end

  post :index, :with => :id, :provides => :json do
    @account = Account.new(parse_json(request))
    if !@account.save
      return {:errors => @account.errors}.to_json
    else
      return @account.to_json
    end
  end

  delete :destroy, :with => :id do
    account = Account.find(params[:id])
    if account != current_account && account.destroy
      flash[:notice] = 'Account was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Account!'
    end
    redirect url(:accounts, :index)
  end
end