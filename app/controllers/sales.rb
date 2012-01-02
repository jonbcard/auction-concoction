AuctionNow.controllers :sales, :parent => :auctions do
  before do
    @auction = Auction.find(params[:auction_id]).details
  end

  get :index, :provides => [:html, :json] do
    case content_type
      when :html
        render 'sales_index'
      when :json
        @auction.sales.reverse.to_json
    end
  end
  
  post :new, :provides => [:json] do
    sale = Sale.new(parse_json(request))
    if(!@auction.add_sale(sale))
      return {:errors => sale.errors,
              :errors_full => sale.errors.full_messages}.to_json
    end
    sale.to_json
  end

  post :index, :with => :id, :provides => :json do
    sale = Sale.new(parse_json(request))
    if @auction.update_sale(sale)
      return sale.to_json
    else
      return {:errors => sale.errors}.to_json
    end
  end
  
  get :check_bidder_number do
    sale_hash = params[:sale]
    val = @auction.has_active_bidder?(sale_hash[:bidder])
    return "#{val}"
  end

  post :destroy, :with => :id do
    @auction.remove_sale(params[:id])
  end
end