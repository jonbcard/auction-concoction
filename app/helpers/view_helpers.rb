AuctionNow.helpers do

  def cycle(one, two)
    @_iter = 0 if @_iter.nil?
    result = (@_iter % 2 == 0) ? one : two
    @_iter += 1
    return result
  end

  def simple_table(list, properties, options={}, &block)
    # Using the partial method, the nested code block was not recognized
    render('helpers/_simple_table', :layout=>false,
        :locals => {:list => list, :properties => properties, :options => options}) do |row|
      yield(row) if block_given?
    end
  end

  def button_to_edit(url, args={})
    args.reverse_merge!(:method => :get, :class => :button_to)
    button_to(pat(:edit), url, args)
  end

  def button_to_delete(url, args={})
    args.reverse_merge!(:method => :delete, :class => :button_to, :'data-confirm' => "Are you sure you want to remove this record?")
    button_to(pat(:delete), url, args)
  end
end