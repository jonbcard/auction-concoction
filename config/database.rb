#configure :production do
#  MongoMapper.connection = Mongo::Connection.from_uri('mongodb://auction:auction@staff.mongohq.com:10073/app1798972 ', 
#    :logger => logger,
#    :timeout => 5)
#end

#configure :development do 
#  MongoMapper.connection = Mongo::Connection.from_uri('mongodb://localhost:27017', 
#    :logger => logger,
#    :timeout => 5)
#end

case Padrino.env
  when :production then 
    MongoMapper.connection = Mongo::Connection.from_uri('mongodb://auction:auction@staff.mongohq.com:10073/app1798972 ', 
      :logger => logger,
      :timeout => 5)
    MongoMapper.database = 'app1798972'

  when :development  then 
    MongoMapper.connection = Mongo::Connection.from_uri('mongodb://localhost:27017',
      :logger => logger,
      :timeout => 5)
    MongoMapper.database = 'auction'
  when :test        then MongoMapper.database = 'auction'
end
