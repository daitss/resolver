class Resolver

  ###Download Utilities###

  ###Download array method###
  #returns array of downloaded filenames
  def download(array, dir)

    newarray = []

    array.each_with_index do |loc, i| #for each schema location
      begin
        uri = URI.parse(loc)
        fname = File.basename(uri.path) #name of file to save
        path = File.join(dir, File.dirname(loc).gsub(':','/').gsub(%r{//+},'/')) #use url as path to store file
        
        FileUtils::mkdir_p path
        
        ext =  File.extname(fname)

        response = fetch(uri,ext) #get response recursively and raise ArgumentError when there is a problem
  
        if response.kind_of? Net::HTTPSuccess
        
          digest = Digest::SHA2.hexdigest(response.read_body) #get hexdigest of schema
          next unless !checksum.has_key?(digest) #next schema if checksum exists. indicates presence of duplicate
        
          @schemaCount += 1
          break unless @schemaCount <= RESOURCE_LIMIT #too many schemas
        
          fname = File.join(path, fname)
          file = File.new(fname, 'w')
        
          begin
            file.write(response.body)
            checksum.store(fname, digest)
            newarray << fname
            #puts "    #{File.basename(fname)} saved to #{path}"
          ensure
            file.close
          end
        else
          #puts "Fail to download #{loc} with response: #{response.code}"
          broken_links.store(uri,[types(ext), response.message])
          raise if response.message == 'Connection refused - connect(2)'
        end
      rescue ArgumentError => e #raise if limit is reached or if squid is down
        broken_links.store(uri,[types(ext), e.message])
        #raise if e.message == response.message == 'Connection refused - connect(2)'
      #rescue Exception => e #something bad happened
      #  broken_links.store(uri, [types(ext), e.message])
      end
    end #end collection
    newarray
  end ##end download method


  ###RECURSIVE FETCH METHOD###
  #Returns response or raises ArgumentError
  def fetch(uri, ext, limit = REDIRECT_LIMIT)
  
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.instance_of? URI::HTTPS
    response = http.get(uri.request_uri)

    case response
    when Net::HTTPSuccess
      if uri.to_s.include? ext #then we should still have what we want
        response
      else
        raise ArgumentError, "No longer points to a #{ext} file"
      end
    
    when Net::HTTPRedirection
      redirect.store(uri,response['location'])
      #puts "Server response redirect at #{uri} with response: #{response.code}"
      fetch(URI.parse(response['location']),ext, limit -1)
    else
      response
    end
  end ##end fetch method
  
  
  ###Types for Premis###
  #Returns type name for premis xml use
  def types ext
    case ext
    when ".xsd"
      "schema"
    when ".xsl"
      "stylesheet"
    when ".dtd"
      "dtd"
    when ".css"
      "cascading stylesheet"
    when ".js"
      "javascript"
    else
      ext
    end
  end ##end types method

end ##end class Resolver
