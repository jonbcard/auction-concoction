AuctionNow.controllers :base do

  get :index, :map => "/" do
    redirect url(:auctions, :index)
  end
end