require 'prawn/core'
require 'prawn/layout'
require 'sinatra/prawn'

AuctionNow.controllers :lots, :parent => :auctions do
  include Sinatra::Prawn
  
  before do
    @auction = Auction.find(params[:auction_id]).details
  end

  get :index, :provides => [:html, :json] do
    case content_type
      when :html
        render 'lots_index'
      when :json
        @auction.lots.reverse.to_json
    end
  end
  
  post :new, :provides => [:json] do
    lot = Lot.new(parse_json(request))
    if(!@auction.add_lot(lot))
      return {:errors => lot.errors,
              :errors_full => lot.errors.full_messages}.to_json
    end
    lot.to_json
  end

  post :index, :with => :id, :provides => :json do
    lot = Lot.new(parse_json(request))
    if @auction.update_lot(lot)
      return lot.to_json
    else
      return {:errors => lot.errors}.to_json
    end
  end
  
  post :destroy, :with => :id do
    @auction.remove_lot(params[:id])
  end
  
  get :catalog, :provides => :pdf do
    content_type 'application/pdf'
    prawn :'reports/lot_catalog'
  end
end