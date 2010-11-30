AuctionNow.controllers :lots, :parent => :auctions do
  
  get :index do
    @auction = Auction.find(params[:auctions_id])
    render 'lots/index'
  end
  
  post :new do
    auction = Auction.find(params[:auctions_id])
    lot = Lot.new(params[:lot])
    if(!auction.add_lot(lot))
      return {:errors => lot.errors.errors,
              :errors_full => lot.errors.full_messages}.to_json
    end
    lot.to_json
  end
end