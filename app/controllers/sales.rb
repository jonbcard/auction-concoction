AuctionNow.controllers :sales, :parent => :auctions do
  
  get :index do
    @auction = Auction.find(params[:auctions_id])
    render 'sales/index'
  end
  
  post :new do
    auction_id = BSON::ObjectId.from_string(params[:auctions_id])
    sale = Sale.new(params[:sale])
    if(not sale.valid?)
      return {:errors => sale.errors.errors,
              :errors_full => sale.errors.full_messages}.to_json
    end

    Auction.push(auction_id, :sales => sale.to_mongo, :safe => true)
    sale.to_json
  end
end