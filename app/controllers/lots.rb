AuctionNow.controllers :lots, :parent => :auctions do
  before do
    @auction = Auction.find(params[:auctions_id])
  end

  get :index do
    render 'lots/index'
  end
  
  post :new do
    lot = Lot.new(params[:lot])
    if(!@auction.add_lot(lot))
      return {:errors => lot.errors.errors,
              :errors_full => lot.errors.full_messages}.to_json
    end
    lot.to_json
  end

  delete :destroy, :with => :id do
    if @auction.remove_lot(params[:id])
      flash[:notice] = 'Lot was successfully removed.'
    else
      flash[:error] = 'Lot could not be removed'
    end
    redirect url(:lots, :index, :auctions_id => params[:auctions_id])
  end
end