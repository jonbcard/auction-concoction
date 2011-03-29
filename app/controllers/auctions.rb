AuctionNow.controllers :auctions do

  

  get :index do
    #if(params[:by_range] == "true")
    # Some lazy coding
    #  @auctions = Auction.where(
    #    :auction_date.gte => parse_date_as_utc(params[:start_date],"2000-01-01"),
    #    :auction_date.lte => parse_date_as_utc(params[:end_date],"2050-01-01")).sort(:auction_date).all
    #else
    #  @auctions = Auction.where(:auction_date.gte => today_as_utc).sort(:auction_date).all
    #end
    @auctions = Auction.all
    @auctions_upcoming = Auction.where(:auction_date.gte => today_as_utc).sort(:auction_date).all
    @auctions_recent   = Auction.where(:auction_date.lte => today_as_utc, :auction_date.gte => (today_as_utc - 60*60*24*7)).sort(:auction_date).all
    @auctions_json = to_events_json(@auctions)
    render 'auctions/index'
  end

  get :new do
    @auction = Auction.new()
    p "STRT"
    p params[:start]
    @auction.start = Time.parse(params[:start])
    @auction.end = Time.parse(params[:end])
    render 'auctions/new'
  end

  post :new do
    @auction = Auction.new(params[:auction])
    @auction.start = Time.parse(params[:auction_date] + " " + params[:start])
    @auction.end = Time.parse(params[:auction_date] + " " + params[:end])
    if @auction.save
      flash[:notice] = 'Auction was successfully created.'
      redirect url(:auctions, :index)
    else
      render 'auctions/new'
    end
  end

  get :edit, :with => :id do
    @auction = Auction.find(params[:id])
    render 'auctions/edit'
  end

  put :edit, :with => :id do
    @auction = Auction.find(params[:id])
    @auction.start = Time.parse(params[:auction_date] + " " + params[:start])
    @auction.end = Time.parse(params[:auction_date] + " " + params[:end])
    if @auction.update_attributes(params[:auction])
      flash[:notice] = 'Auction was successfully updated.'
      redirect url(:auctions, :index)
    else
      render 'auctions/edit'
    end
  end

  delete :destroy, :with => :id do
    # TODO : Do not allow an auction to be
    # removed if it has associated data
    auction = Auction.find(params[:id])
    
    if auction.destroy
      flash[:notice] = 'Auction was successfully destroyed.'
    else
      flash[:error] = 'Auction could not be cancelled.'
    end
    redirect url(:auctions, :index)
  end

end
