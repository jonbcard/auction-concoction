AuctionNow.helpers do
  def today_as_utc
    Time.utc(Time.now.year, Time.now.month, Time.now.day, 0, 0, 0, 0)
  end

  def parse_date_as_utc(param, default)
    date = param.length > 0 ? Date.parse(param) : Date.parse(default)
    Time.utc(date.year, date.month, date.day, 0, 0, 0, 0)
  end
end