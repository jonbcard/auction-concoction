AuctionNow.controllers :sales, :parent => :auctions do
  
  get :index do
    @auction = Auction.find(params[:auctions_id])
    render 'sales/index'
  end
  
  post :new do
    @auction = Auction.find(params[:auctions_id])
    sale = Sale.new(params[:sale])
    if(!@auction.add_sale(sale))
      return {:errors => sale.errors.errors,
              :errors_full => sale.errors.full_messages}.to_json
    end
    sale.to_json
  end
end