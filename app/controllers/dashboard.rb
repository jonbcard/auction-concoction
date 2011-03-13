AuctionNow.controllers :dashboard, :parent => :auctions do

  get :index do
    # /auctions/#{params[:auction_id]}/dashboard"
    @auction = Auction.find(params[:auctions_id])
    render 'dashboard/index'
  end

  #get :
  #  "google.visualization.Query.setResponse({" +
  #      "status:'ok'," +
  #      "table:{" +
  #      "cols:[" +
  #          "{id:'Time', label:'Time', type:'datetime'}," +
  #          "{id:'Lots Sold', label:'Lots Sold', type:'number'}]" +
  #      "rows:[" +
  #          "{}]}" +
  #      "})";
  #end
end