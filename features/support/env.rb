app_file = File.join(File.dirname(__FILE__), *%w[.. .. app.rb])
require app_file
Sinatra::Application.app_file = app_file

require 'rspec'
require 'rspec/expectations'
require 'rack/test'
require 'webrat'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

Webrat.configure do |config|
  config.mode = :rack
end

class MyWorld
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers
  
  Webrat::Methods.delegate_to_session :response_code, :responde_body
  #Webrat::SinatraSession.new
  def app
    Sinatra::Application
  end
  
end

World{MyWorld.new}