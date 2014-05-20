require 'rubygems'
require 'bundler/setup'
require 'uri'
require 'uuid'
require_relative 'lib/resolver'
require_relative 'lib/collection_manager'
require 'sinatra'
require 'datyl/config'
require 'datyl/logger'
require 'fileutils'

#resolver utility for looking up external document dependancies and downloading them

RESOLVER_VERSION = 1 #maybe something fancier in the future :)
REDIRECT_LIMIT = 10 #how far down the rabbit hole are you willing to go?
RESOURCE_LIMIT = 100 #when your dependancies have dependants things get expensive
@@collections #global reference to collection manager
@@proxy #global proxy settings

def get_config
  raise ConfigurationError, "No DAITSS_CONFIG environment variable has been set, so there's no configuration file to read"             unless ENV['DAITSS_CONFIG']
  raise ConfigurationError, "The VIRTUAL_HOSTNAME environment variable has not been set"                                               unless ENV['VIRTUAL_HOSTNAME']
  raise ConfigurationError, "The DAITSS_CONFIG environment variable points to a non-existant file, (#{ENV['DAITSS_CONFIG']})"          unless File.exists? ENV['DAITSS_CONFIG']
  raise ConfigurationError, "The DAITSS_CONFIG environment variable points to a directory instead of a file (#{ENV['DAITSS_CONFIG']})"     if File.directory? ENV['DAITSS_CONFIG']
  raise ConfigurationError, "The DAITSS_CONFIG environment variable points to an unreadable file (#{ENV['DAITSS_CONFIG']})"            unless File.readable? ENV['DAITSS_CONFIG']
  
  return Datyl::Config.new(ENV['DAITSS_CONFIG'], ENV['VIRTUAL_HOSTNAME'])
end

def do_at_exit
  at_exit do
    FileUtils.rm_rf(settings.data_path)
    Datyl::Logger.info "Ending Resolver"
  end
end


configure do
  config = get_config
  
  disable :logging
  disable :dump_errors
  set :environment, :production
  set :raise_errors, false
  set :views, "#{File.dirname(__FILE__)}/views"
  #set :public, "#{File.dirname(__FILE__)}/public"
  
  set :data_path, Dir.mktmpdir #top level directory to hold collections for retrieval
  @@proxy = config.resolver_proxy

  Datyl::Logger.setup('XmlResolution', ENV['VIRTUAL_HOSTNAME'])
  
  if not (config.log_filename or config.log_syslog_facility)
    Datyl::Logger.stderr
  end
  
  Datyl::Logger.facility = config.log_syslog_facility  if config.log_syslog_facility
  Datyl::Logger.filename = config.log_filename         if config.log_filename
  
  use Rack::CommonLogger, Datyl::Logger.new(:info, 'Rack:')  # Bend CommonLogger to our will...
  
  Datyl::Logger.info "Starting Resolver"
  defconfig = Datyl::Config.new(ENV['DAITSS_CONFIG'], 'defaults')
  
  do_at_exit() #cleanup our temp directory at exit
end


begin
  load 'lib/app/errors.rb'
  load 'lib/app/gets.rb'
  load 'lib/app/posts.rb'
  load 'lib/app/puts.rb'
  @@collections = CollectionManager.instance
  @@collections.data_path = settings.data_path  
rescue ScriptError => e
  Datyl::Logger.err "Initialization Error: #{e.message}"
end


