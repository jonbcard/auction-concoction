MongoMapper.connection = Mongo::Connection.from_uri('mongodb://admin:adminadmin@flame.mongohq.com:27019/auction', :logger => logger)

case Padrino.env
  # Don't want to waste valuable mongohq databases for now
  when :development then MongoMapper.database = 'auction'
  when :production  then MongoMapper.database = 'auction'
  when :test        then MongoMapper.database = 'auction'
end
