AuctionNow.controllers :base do

  get :index, :map => "/" do
    redirect "/auctions"
  end
end