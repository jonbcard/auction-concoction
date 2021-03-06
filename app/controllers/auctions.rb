AuctionNow.controllers :auctions do

  get :index do
    @locations = Location.all
    @profiles  = Profile.all
    render 'auctions_index'
  end
  
  get :all, :provides => :json do
    Auction.all.to_json
  end

  post :new, :provides => :json do
    auction = Auction.from_map(parse_json(request))
    auction.save ? auction.to_json : {:errors => auction.errors}.to_json
  end
  
  post :index, :with => :id, :provides => :json do
    auction = Auction.find(params[:id])
    auction.update_from_map(parse_json(request))
    auction.save ? auction.to_json : {:errors => auction.errors}.to_json
  end

  ##
  # TODO : Obviously this shouldn't be a 'GET' since it has
  # consequences to the stored data. Also need to update this method
  # to not remove the record if there is associated data.
  ##
  get :destroy, :with => :id do
    auction = Auction.find(params[:id])
    if auction.total_lot_count == 0 && auction.total_sale_count == 0 then
      return auction.destroy.to_json
    else
      return {:errors => "Cannot remove an auction with associated lots or sales."}.to_json
    end
    
  end
  
  get :index, :with => :id, :provides => :json do
    return Auction.find(params[:id]).to_json
  end

  get :statistics, :with => :id, :provides => :html do
    @auction = Auction.find(params[:id])
    partial "templates/auction_statistics.haml"
  end
end
