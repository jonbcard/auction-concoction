AuctionNow.controllers :auctions do
  # TODO : Not a big fan of the current URL-scheme. To fix.

  get :index do
    @auctions = Auction.all
    render 'auctions/index'
  end

  get :new do
    render 'auctions/new'
  end

  post :new do
    @auction = Auction.new(params[:auction])
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