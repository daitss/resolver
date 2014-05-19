class Resolver

  ##Get Schema Method##
  def get_schema dir, doc

    xmldoc = Nokogiri::XML::Document.parse(File.open(doc))
    target = xmldoc.root.attributes["targetNamespace"] unless xmldoc.root.nil? #target namespace if it exists
  
    array = [] #array to hold working collection
  
    #collect schema locations from xml
    xmldoc.xpath("//*[substring(name(), string-length(name()) - string-length('schemaLocation') +1)]").each do |node|
      array += node.attributes["schemaLocation"].to_s.strip.split(/\s+/)
    end
  
    array.delete_if { |ele| !ele.downcase.include? ".xsd" } #remove non schema locations
  
    array.map! do |ele|
      if target && (!ele.include? "http") #if schema is not an href then check if there is a targetNamespace and append
        ele = "#{target}" + "#{ele}"
      else #keep element
        ele
      end
    end
  
    newarray = download(array, dir) #download array of schemas
    #recursively look through newly downloaded schemas for more dependancies.
    newarray.each { |d| get_schema dir, d} unless newarray.nil?
  
  end

end
