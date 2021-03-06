AuctionNow.helpers do
  
  def flash_growl(kind)
    # Yuck!
    flash_text = flash[kind]
    return '' if flash_text.blank?
    return "<script type='text/javascript'>$(function() { $.growlUI('#{flash_text}'); });</script>"
  end

  ##
  # Used to generate odd/even CSS classes for rendering a table.
  # TODO: deprecate for client-side soln.
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
  # :click => URL to go to if the row is clicked. Use ${row.id} to reference this row's id field.
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
  
  def button_link(caption, url, options={})
    options.reverse_merge!(:'data-href' => url, :onClick => "document.location='#{url}'")
    content_tag(:button, caption, options)
  end

  def button_to_edit(url, args={})
    args.reverse_merge!(:method => :get, :class => :button_to)
    button_to(pat(:edit), url, args)
  end

  def button_to_delete(url, args={})
    args.reverse_merge!(:method => :delete, :class => :button_to, :'data-confirm' => "Are you sure you want to remove this record?")
    button_to(pat(:delete), url, args)
  end

  def to_events_json(auctions)
    events = auctions.collect do |a|
      start = a.start
      if not start.nil?
        year = start.getlocal.year
        month = start.getlocal.month
        day = start.getlocal.day
        hour = start.getlocal.hour
        min = start.getlocal.min
        start_date = "#{year}-#{month}-#{day} #{hour}:#{min}"
        "[title:'#{a.title}', start:'#{start_date}']"
      else
        nil
      end
    end
    "{" << events.join(",") << "}"
  end

  def date_string(time)
    return nil if time.nil?
    year = time.year
    month = time.month.to_s.rjust(2,'0')
    day = time.day.to_s.rjust(2,'0')
    return "#{year}-#{month}-#{day}"
  end

  def time_string(time)
    return nil if time.nil?
    hour = time.hour.to_s.rjust(2,'0')
    min  = time.min.to_s.rjust(2,'0')
    return "#{hour}:#{min}"
  end
end