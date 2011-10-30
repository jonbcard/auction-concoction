AuctionNow.controllers :dashboard, :parent => :auctions do
  get :index do
    # /auctions/:auction_id/dashboard"
    print params[:auction_id]
    @auction = Auction.find(params[:auction_id])
    render 'dashboard/index'
  end
end