AuctionNow.controllers :sales, :parent => :auctions do
  
  get :index do
    @auction = Auction.find(params[:auctions_id])
    render 'sales/index'
  end
  
  post :new do
    @auction = Auction.find(params[:auctions_id])
    sale = Sale.new(params[:sale])
    if sale.valid? && @auction.sales << sale && @auction.save
      sale.to_json
    else
      {:errors => sale.errors.errors, :errors_full => sale.errors.full_messages}.to_json
    end
  end
end