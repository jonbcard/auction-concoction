AuctionNow.controllers :lots, :parent => :auctions do
  
  get :index do
    @auction = Auction.find(params[:auctions_id])
    render 'lots/index'
  end
  
  post :new do
    auction_id = BSON::ObjectId.from_string(params[:auctions_id])
    lot = Lot.new(params[:lot])
    if(not lot.valid?)
      return {:errors => lot.errors.errors,
              :errors_full => lot.errors.full_messages}.to_json
    end

    Auction.push(auction_id, :lots => lot.to_mongo, :safe => true)
    lot.to_json
  end
end