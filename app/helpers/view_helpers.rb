AuctionNow.helpers do

  def cycle(one, two)
    @_iter = 0 if @_iter.nil?
    result = (@_iter % 2 == 0) ? one : two
    @_iter += 1
    return result
  end

  
end