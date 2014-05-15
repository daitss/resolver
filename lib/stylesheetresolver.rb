class Resolver
  
  ##Get stylesheet Method##
  def get_stylesheet dir, doc

    xmldoc = Nokogiri::XML::Document.parse(File.open(doc))
  
    array = [] #array to hold working collection
    
    xmldoc.remove_namespaces!
  
    #collect stylesheet locations from xml
    xmldoc.xpath("//import/@href").each do |node|
      array.push(node.to_s) unless !node.to_s.include? "http"
    end
    
    xmldoc.xpath("//include/@href").each do |node|
      array.push(node.to_s) unless !node.to_s.include? "http"
    end
  
    array.delete_if { |ele| !ele.downcase.include? ".xsl" } #remove non stylesheet locations

    newarray = download(array, dir) #download array of schemas
    #recursively look through newly downloaded stylesheets for more dependancies.
    newarray.each { |d| get_stylesheet dir, d} unless newarray.nil?
  
  end

end
