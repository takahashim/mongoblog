# This file is used by Rack-based servers to start the application.

require 'rubygems'
require './blog.rb'

set :run, false
set :environment, :production

run Sinatra::Application


