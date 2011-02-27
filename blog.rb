begin
  require File.expand_path('../.bundle/environment', __FILE__)
rescue LoadError
  require 'rubygems'
  require 'bundler'
  Bundler.setup
end

Bundler.require :default
require 'models'

set :app_file, __FILE__
set :haml, :format => :html5, :escape_html => true


helpers do
  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['admin', 'adminpass']
  end
end


get '/' do
  @posts = Post.sort(:created_at).limit(10).all(:order => 'created_at DESC')

  haml :posts
end

get '/posts/new' do
  protected!
  @post = Post.new

  @title = 'New Post'
  haml :new
end

get '/posts/edit/:id' do |id|
  protected!
  @post = Post.find(id)

  @title = 'Edit Post'
  haml :new
end

post '/posts' do
  protected!
  @post = Post.new(params[:post])

  if @post.save
    redirect "/posts/#{@post.id}"
  else
    @title = 'New Post'
    haml :new
  end
end

get '/posts/:id' do |id|
  @post = Post.find(id)
  @comment = Comment.new

  @title = @post.title
  haml :show
end

post '/posts/:id/comments' do |id|
  @post = Post.find(id)
  @comment = @post.comments.build(params[:comment])

  if @comment.save
    redirect "/posts/#{@post.id}"
  else
    @post.comments.reload

    @title = @post.title
    haml :show
  end
end

get '/style.css' do
  content_type :css
  sass :style
end
