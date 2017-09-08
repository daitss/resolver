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

delete '/ieids/remove/:collection_id' do |collection_id|
  content_type 'text/plain'

  tarball = "#{settings.data_path}/#{collection_id}.tar"
  error 404, "No such IEID #{collection_id}" unless File.exist?(tarball)
  @@collections.remove tarball, collection_id
  status 200
end

#browsers without html 5 do not support delete method - below method is used in gui
post '/ieids/remove/:collection_id' do |collection_id|
  tarball = "#{settings.data_path}/#{collection_id}.tar"
  error 404, "No such IEID #{collection_id}" unless File.exist?(tarball)
  @@collections.remove tarball, collection_id
  redirect "/", 301
end
