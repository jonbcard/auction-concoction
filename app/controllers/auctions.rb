AuctionNow.controllers :auctions do

  get :index do
    @locations = Location.all
    @auctions = Auction.all       #TODO: Allow result subsets to be returned
    render 'auctions/index'
  end

  get :new, :provides => [:html] do
    @auction = Auction.new()
    @auction.start = Time.parse(params[:start])
    @auction.end = Time.parse(params[:end])
    render 'auctions/new'
  end

  post :new, :provides => [:json, :html] do
    case content_type
      when :html
        @auction = Auction.new(params[:auction])
        @auction.start = Time.parse(params[:auction_date] + " " + params[:start])
        @auction.end = Time.parse(params[:auction_date] + " " + params[:end])
        if @auction.save
          flash[:notice] = 'Auction was successfully created.'
          redirect url(:auctions, :index)
        else
          render 'auctions/new'
        end
      when :json
        @auction = Auction.from_map(parse_json(request))
        success = @auction.save
        if(!success)
          return {:errors => @auction.errors}.to_json
        else
          return @auction.to_json
    end
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
  # to not remove the record if there is associated data.
  ##
  get :destroy, :with => :id do
    auction = Auction.find(params[:id])
    return auction.destroy.to_json
    #if auction.destroy
    #  flash[:notice] = 'Auction was successfully destroyed.'
    #else
    #  flash[:error] = 'Auction could not be cancelled.'
    #end
    #redirect url(:auctions, :index)
  end

  
  # REST-ful JSON endpoints
  get :index, :provides => :json do
     Auction.all.to_json
  end
  
  get :index, :with => :id, :provides => :json do
    return Auction.find(params[:id]).to_json
  end

  post :index, :with => :id, :provides => :json do
    @auction = Auction.find(params[:id])
    @auction.update_from_map(parse_json(request))
    success = @auction.save
    if(!success)
      return {:errors => @auction.errors}.to_json
    else
      return @auction.to_json
    end
  end
end
