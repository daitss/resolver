# PUT a new collection resource id.

put '/ieids/:collection_id' do |collection_id|
  content_type 'text/plain'
  
  file_url = "#{settings.data_path}/#{collection_id}.tar"
  if File.exist?(file_url)
    status 200
    "Collection #{collection_id} exists.\n"
  else
    status 201
    "Collection #{collection_id} created.\n"
  end

end

#Remove a tarfile associated with a collection_id

put '/ieids/remove/:collection_id' do |collection_id|
  content_type 'text/plain'

  tarball = "#{settings.data_path}/#{collection_id}.tar"
  raise Http404, "No such IEID #{collection_id}" unless File.exist?(tarball)
  @@collections.remove tarball, collection_id
  status 200
end
