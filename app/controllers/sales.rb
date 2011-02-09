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

  get :check_bidder_number do
    sale_hash = params[:sale]
    @auction = Auction.find(params[:auctions_id])
    val = @auction.has_active_bidder?(sale_hash[:bidder])
    return "#{val}"
  end

  delete :destroy, :with => :id do
    auction = Auction.find(params[:auctions_id])
    if auction.remove_sale(params[:id])
      flash[:notice] = 'Sale was successfully removed.'
    else
      flash[:error] = 'Sale could not be removed. The associated bidder may already be checked out.'
    end
    redirect url(:sales, :index, :auctions_id => params[:auctions_id])
  end
end