AuctionNow.controllers :dashboard, :parent => :auctions do
  before do
    
  end

  get :index do
    # /auctions/:auction_id/dashboard"
    @auction = Auction.find(params[:auctions_id])
    print "AUCTION INFO::::::::"
    print @auction.to_s
    render 'dashboard/index'
  end
end