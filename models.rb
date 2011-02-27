##logger = Logger.new('test.log')
##MongoMapper.connection = Mongo::Connection.new('flame.mongohq.com', 27053, { :logger => logger })
MongoMapper.connection = Mongo::Connection.new('flame.mongohq.com', 27053, {})
MongoMapper.database = 'mongoblog'
MongoMapper.database.authenticate('admin', 'xxxx')

class Post
  include MongoMapper::Document

  key :title, String, :required => true
  key :content, String, :required => true
  timestamps!

  many :comments
  validates_associated :comments
end

class Comment
  include MongoMapper::EmbeddedDocument

  key :name, String, :required => true
  key :comment, String, :required => true
end
