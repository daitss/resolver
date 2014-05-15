class Resolver

  ##DTD and PI lookup methods##
  def get_dtd dir, doc
    
    xmldoc = Nokogiri::XML::Document.parse(File.open(doc))
    
    array = [] #array to hold working collection
    
    xss = xmldoc.at_xpath('//processing-instruction("xml-stylesheet")') #gets processing instruction xml-stylesheet
    
    dtdsys = xmldoc.internal_subset.system_id unless xmldoc.internal_subset.nil? #gets DTD location
    
    #puts "SystemID #{dtdsys}" unless dtdsys.nil?
    
    #recursively look through newly downloaded dtds and stylesheets for more dependancies.
    array.push(xss) unless xss.nil? 
    array.push(dtdsys) unless dtdsys.nil? 
    newarray = download(array, dir) unless array.nil? #download array of processing instructions
    newarray.each { |d| get_dtd dir, d} unless newarray.nil?
    newarray.each { |d| get_stylesheet dir, d} unless newarray.nil?

    
  end

end
