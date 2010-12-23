AuctionNow.helpers do

  ##
  # Used to generate odd/even CSS classes for rendering a table.
  # 
  def cycle(one, two)
    @_iter = 0 if @_iter.nil?
    result = (@_iter % 2 == 0) ? one : two
    @_iter += 1
    return result
  end

  ##
  # This is used to scaffold a cookie-cutter table into a page. The table's features include
  # sortable columns, and client-side pagination.
  # 
  # Valid options:
  # :paginate => [true (default), false]
  # :page_size => If pagination is on, how many records to display per page (Default is 25).
  # :click => URL to go to if the row is clicked. Use ${row._id} to reference this row's _id field.
  # :edit => If provided, an [Edit] link will be displayed to the user linking to the URL provided.
  # :delete => If provided, a [Remove] link will be displayed to the user linking to the URL provided.
  #
  def simple_table(list, properties, options={}, &block)
    # By default, have pagination on with page size of 25
    options.reverse_merge! :paginate => true, :page_size => 25
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