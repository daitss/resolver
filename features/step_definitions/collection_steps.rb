path = File.join(Dir.pwd, '/lib')

require_relative "#{path}/resolver"
require_relative "#{path}/collection_manager"

path = File.join(Dir.pwd, '/features/files')
TESTFILE = "#{path}/daitss.xsd"
REDIRECTFILE = "#{path}/stylesample.xsl"

@file
@res
@collections
@collection_id


#tarball = @@collections.retrieve collection_id
#@@collections.remove tarball, collection_id
#content_type 'text/xml'
#res.premis

Given(/^a "(.+)" file$/) do |name|
  @collection_id = UUID.generate
  if name == 'test'
    @file = TESTFILE
  else
    @file = REDIRECTFILE
  end
end

When(/^I resolve$/) do
  @res = Resolver.new @file, @collection_id, app.settings.data_path, @file
end

Then(/^I should have checksum$/) do
  @res.checksum.length.should > 0
end                                                                

Then(/^I should have broken links$/) do
  @res.broken_links.length.should > 0
end                                                                

Then(/^I should have redirects$/) do
  @res.redirect.length.should > 0
end

When(/^I create a collection$/) do
  @collections = CollectionManager.instance
  @collections.data_path = app.settings.data_path
end

Then(/^I should have a manifest list$/) do
  @collections.ieids_manifest.length.should > 0
end

Then(/^I should have a manifest$/) do
  erb = @collections.viewManifest @collection_id
  doc = Nokogiri::XML(erb)
  node = doc.search("resolutions")
  attr = node.first.attr('collection')
  attr.should_not be_nil
end

When(/^I create a tarball$/) do
  @collections.retrieve @collection_id
end

Then(/^I should have a tarball location$/) do
  @collections.listTar.length.should > 0
end

Then(/^I should remove the tarball$/) do
  tarball = "#{app.settings.data_path}/#{@collection_id}.tar"
  @collections.remove tarball, @collection_id
end