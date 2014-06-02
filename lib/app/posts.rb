# POST a file to the resolver service.
#
# We expect Content-Type of enctype=multipart/form-data, which is used
# in your basic file upload form.  It expects the same behavior as
# produced by the form input having type="file" name="xmlfile".
# Additionally, we require that the content disposition must supply a
# filename.
post '/ieids/:collection_id/' do |collection_id|

  begin

    error 400, "Missing form data name='xmlfile'"    unless params['xmlfile']
    error 400, "Missing form data filename='...'"    unless filename = params['xmlfile'][:filename]
    error 500, "Data unavailable (missing tempfile)" unless tempfile = params['xmlfile'][:tempfile]

    client = env['REMOTE_ADDR']

    file_url = "file://#{client}/#{collection_id}/#{filename.gsub(%r(^/+), '')}"

    Datyl::Logger.info "Handling uploaded document #{file_url}.", @env

    res = Resolver.new tempfile, collection_id, settings.data_path, file_url
    
    res.broken_links.each do |link, message|
      Datyl::Logger.err  "Failed retrieving #{link} for document #{file_url}, error #{message[1]}.", @env
    end
    
    res.redirect.each do |link, message|
      Datyl::Logger.info "Schema #{link} for document #{file_url}, was redirected to #{message}.", @env
    end                      
    
    status = 201  
    content_type 'application/xml'
    res.premis #serve report here

  rescue Errno::ECONNREFUSED => e #proxy error caught here
    halt 503, { 'Content-Type' => 'text/plain' }, "Proxy Server Down.\n"
  ensure
    tempfile.unlink if tempfile.respond_to? 'unlink'
  end
end

#GUI - Post something to service#
post '/' do
  error 400, "Missing Data" unless params['xmlfile']
  error 400, "Missing Data" if params['xmlfile'].empty?

  tempfile = params['xmlfile'][:tempfile]
  filename = params['xmlfile'][:filename]
  client = env['REMOTE_ADDR']
  collection_id = UUID.generate
  file_url = "file://#{client}/#{collection_id}/#{filename.gsub(%r(^/+), '')}"
  res = Resolver.new tempfile, collection_id, settings.data_path, file_url

  tarball = @@collections.retrieve collection_id
  #man = @@collections.viewManifest collection_id
  #@@collections.remove tarball, collection_id
  content_type 'text/xml'
  res.premis
  #man
end
