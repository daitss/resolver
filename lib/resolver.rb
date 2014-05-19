require 'nokogiri'
require 'uri'
require 'net/http'
require 'tmpdir'
require 'digest'
require 'sinatra'
require 'erb'
require 'uuid'
require_relative 'xmlresolver'
require_relative 'dtdresolver'
require_relative 'download'
require_relative 'tar'
require_relative 'stylesheetresolver'
require_relative 'exceptions'

include Util::Tar

class Resolver

  attr_reader :doc, :broken_links, :checksum, :redirect, :ieid, :data_path, :event_id, :file_url
  attr_accessor :outcome
  
  ##constructor method##
  def initialize doc, ieid, data_path, file_url
    @doc = doc
    @file_url = file_url
    @ieid = ieid
    @redirect = {} #hash of redirected uri links and redirected links
    @broken_links = {} #hash of broken uri links and array of [resource type, error message]
    @checksum = {} #hashes of successful uri links and checksums
    @data_path = data_path
    @event_id = 'file://' + File.dirname(@doc) + '/xmlresolution/events/' + UUID.generate
    #revolve this file!
    resolve
  end


  ##main resolve method##
  def resolve
    @schemaCount = 0 #track number of downloads for schemaLimit
  
    begin
      
      #setup folder for tarball
      dir = (File.join(data_path, ieid))
      tar_dir = File.join(dir, ieid)
      if !Dir.exists?(dir)
        Dir.mkdir dir
        Dir.mkdir tar_dir
      end
      
      #plugins - downloads external resources and updates hashes
      get_schema tar_dir, doc
      get_dtd tar_dir, doc
      get_stylesheet tar_dir, doc
      
      @outcome = eventOutcome
      manifest #add resolution manifest to collection manager
    
    #somethng unexpected happened
    rescue Exception => e
      Datyl::Logger.err "Internal Service Error - #{e.inspect} #{e.message}"
      raise
    end
          
  end

  #premis report#
  def premis
    template_file = File.open("views/premis.erb", 'r').read
    ERB.new(template_file).result(binding)
  end
  
  #manifest report for collection#
  def manifest
    template_file = File.open("views/manifest.erb", 'r').read
    manifest_erb = ERB.new(template_file).result(binding)
    @@collections.addToManifest(ieid, manifest_erb)
  end
  
  #event outcome#
  def eventOutcome
    if broken_links.length == 0
      return 'success'
    elsif checksum.length > 0
      return 'mixed'
    else
      return 'failure'
    end
  end

end ##end class Resolver


