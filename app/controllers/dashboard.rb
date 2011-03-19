AuctionNow.controllers :dashboard, :parent => :auctions do
  before do
    @auction = Auction.find(params[:auctions_id])
  end

  get :index do
    # /auctions/:auction_id/dashboard"
    render 'dashboard/index'
  end
end