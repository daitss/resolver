# Index view

get '/' do
  erb :index
end

# List the collections we've created

get '/ieids' do
  redirect '/ieids/', 301
end

get '/ieids/' do
  @array = @@collections.listTar
  erb :list
end

# Return a tarfile of all of the schemas we've collected for the documents submitted

get '/ieids/:collection_id' do |collection_id|
   redirect "/ieids/#{collection_id}/", 301
end

get '/ieids/:collection_id/' do |collection_id|
  tarball = @@collections.retrieve collection_id
  raise Http404, "No such IEID #{collection_id}" unless File.exist?(tarball)
  send_file tarball
end
