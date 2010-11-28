AuctionNow.controllers :lots, :parent => :auctions do
  
  get :index do
    @auction = Auction.find(params[:auctions_id])
    render 'lots/index'
  end
  
  post :new do
    p "RECORDING NEW"
    @auction = Auction.find(params[:auctions_id])
    lot = Lot.new(params[:lot])
    if @auction.add_lot_and_save(lot)
      lot.to_json
    else
      {:errors => lot.errors.errors, :errors_full => lot.errors.full_messages}.to_json
    end
  end
end