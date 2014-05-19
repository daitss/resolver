require 'xml'

path = File.join(Dir.pwd, '/features/files')

Given(/^a schema file$/) do
  attach_file("xmlfile","#{path}/Cedar_Key.xml")
end

Given(/^a stylesheet file$/) do
  attach_file("xmlfile","#{path}/stylesample.xsl")
end

Given(/^a dtd file$/) do
  attach_file("xmlfile","#{path}/frick.xml")
end

Given(/^a binary file$/) do
  attach_file("xmlfile","#{path}/binary.xml")
end

Given(/^a successful file$/) do
  attach_file("xmlfile","#{path}/frick.xml")
end

Given(/^a mixed file$/) do
  attach_file("xmlfile","#{path}/daitss.xsd")
end

Given(/^a failure file$/) do
  attach_file("xmlfile","#{path}/daitssFailure.xsd")
end

Given(/^a file with redirects$/) do
  attach_file("xmlfile","#{path}/stylesample.xsl")
end

Given(/^a random data file$/) do
  attach_file("xmlfile","#{path}/random.data")
end

Then(/^I should see a premis report$/) do
  doc = Nokogiri::XML(last_response.body)
  event = doc.search("event")
  event = event.at("eventType").content
  event.should == 'XML Resolution'
end

Then(/^I should see eventOutcome "(.+)"$/) do |expected|
  doc = Nokogiri::XML(last_response.body)
  event = doc.search("event")
  event = event.at("eventOutcome").content
  event.should == expected
end