require 'prawn/core'
require 'prawn/layout'
require 'sinatra/prawn'

AuctionNow.controllers :lots, :parent => :auctions do
  include Sinatra::Prawn
  
  before do
    @auction = Auction.find(params[:auction_id])
  end

  get :index, :provides => [:html, :json] do
    # /auctions/#{params[:auction_id]}/bidders"
    case content_type
      when :html
        @consignees = Consignee.all # TODO: This could be quite a large set
        render 'lots_index'
      when :json
        @auction.lots.reverse.to_json
    end
  end
  
  post :new do
    lot = Lot.new(params[:lot])
    if(!@auction.add_lot(lot))
      return {:errors => lot.errors,
              :errors_full => lot.errors.full_messages}.to_json
    end
    lot.to_json
  end

  delete :destroy, :with => :id do
    if @auction.remove_lot(params[:id])
      flash[:notice] = 'Lot was successfully removed.'
    else
      flash[:error] = 'Lot could not be removed'
    end
    redirect url(:lots, :index, :auction_id => params[:auction_id])
  end
  
  get :catalog, :provides => :pdf do
    content_type 'application/pdf'
    prawn :'reports/lot_catalog'
  end
end