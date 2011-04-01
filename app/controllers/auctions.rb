AuctionNow.controllers :auctions do

  

  get :index do
    @auctions = Auction.all
    @auctions_upcoming = Auction.where(:start.gte => today_as_utc).sort(:start).all
    @auctions_recent   = Auction.where(:start.lte => today_as_utc, :start.gte => (today_as_utc - 60*60*24*7)).sort(:start).all
    render 'auctions/index'
  end

  get :new do
    @auction = Auction.new()
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

  ##
  # TODO : Obviously this shouldn't be a 'GET' since it has
  # consequences to the stored data. Also need to update this method
  # to note remove the record if there is associated data.
  ##
  get :destroy, :with => :id do
    auction = Auction.find(params[:id])
    
    if auction.destroy
      flash[:notice] = 'Auction was successfully destroyed.'
    else
      flash[:error] = 'Auction could not be cancelled.'
    end
    redirect url(:auctions, :index)
  end

end
