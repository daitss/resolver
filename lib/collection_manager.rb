require 'singleton'
require_relative 'tar'

include Util::Tar

##The purpose of this class is to manage collections for retrieval and deletion##
class CollectionManager
  include Singleton
  
  attr_reader :ieids_manifest #hash of ieids and their manifests
  attr_accessor :data_path
  
  ##constructor method##
  def initialize
    @ieids_manifest = {}
  end
  
  ##prepare collection for retrieval by creating manifest.xml tarballing the collection##
  def retrieve ieid
    dir = (File.join(data_path, ieid))
    manifest dir, ieid
    
    tarball dir, ieid #creates tarball in dir
    FileUtils.mv "#{dir}/#{ieid}.tar", "#{data_path}/"
    FileUtils.rm_r dir
    return "#{data_path}/#{ieid}.tar"
  end
  
  ##tarball method##
  def tarball dir, ieid
    
    begin
      io = tar(dir)
      fname = "#{ieid}.tar"
      fname = File.join(dir, fname)
      file = File.new(fname, 'w') 
      file.write(io.string)
    ensure
      file.close
    end
  end
  
  ##array of tarball collections##
  def listTar
    tarfiles = File.join(data_path, '/', '*.tar')
    Dir.glob(tarfiles)
  end
  
  ##remove tarball##
  def remove tarball, ieid
    FileUtils.rm tarball
    ieids_manifest.delete(ieid)
  end
  
  ##store ieid manifest
  def addToManifest ieid, erb
    if ieids_manifest.has_key?(ieid)
      value = ieids_manifest[ieid]
      value << erb.to_s
    else
      ieids_manifest.store(ieid, erb.to_s)
    end
  end
  
  ##create manifest file##
  def manifest dir, ieid
    path = (File.join(dir, ieid))
    template_file = File.open("views/manifest_collection.erb", 'r').read
    man = ERB.new(template_file).result(binding)
    begin
      fname = "manifest.xml"
      fname = File.join(path, fname)
      file = File.new(fname, 'w')
      file.write(man.to_s)
    ensure
      file.close
    end
  end
  
  #display manifest#
  def viewManifest ieid
    template_file = File.open("views/manifest_collection.erb", 'r').read
    ERB.new(template_file).result(binding)
  end
  
end