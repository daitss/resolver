Resolver Service
================
Optional service to replace XML Resolution.
What this service does:

  1. Download external resources for a given file or files currently files associated with xml (xsd, xsl, dtd).
  2. Returns a premis report for each xml posted.
  3. Create manifest report for each collection.
  4. Tarballs collections and removes collection tarballs.
  
Interactions with Core service:
-------------------------------
  Given an IEID package with xml files
  
    Step 1. POST each xml file to Resolver
            Create new collection for IEID if one does not exist.
            Returns premis report for each file posted.
    Step 2. GET IEID collection
            Creates manifest document of collection
            Returns tarball of collection and manifest
    Step 3. DELETE collection
    
Environment:
------------
  * SetEnv RESOLVER_PROXY squid.example.com:3128 - this is optional if you wish to use a proxy server.
  * SetEnv LOG_FACILITY LOG_LOCAL1 - optional facility code if you use syslog for loggin. 
  * SetEnv DATA_ROOT - no longer used.  Resolver will use tmp space defined for user. In our case /var/daitss/tmp.
    
Requirements:
-------------
  * ruby 1.9.3
  * sinatra, rack
  * nokogiri
  * rake, rspec and cucumber for testing
  * log4r
  * capistrano for deployment
  
  
Reasons for this project
------------------------
  1. Smaller codebase over XML Resolution.
  2. Better resolutions for targetNamespace.
  3. Easier to implement enhancements and more maintainable code.
     * Desirable enchancement would retrieve and tarball html resources such as js, fonts, images.
  4. In XML Resolution a poorly formed XML file can halt a package.  This should never happen.
     * Ex. An element in xhtml such as this <! comment > is poorly formed and will cause a snafu. 

Fixes over xml resolution
-------------------------
XML Resolution does not correctly handle stylesheets or import & include tags.
XML Resolution parses namespace in DTD as a resource in some cases.
XML Resolution does not handle targetNamespace and thus does not download nor catch those types of links.

Current state of Resolver
-------------------------
  1. Downloads schemas, stylesheets and dtds and recusively checks for more dependancies.  
  2. Includes a test harness written in gherkin (cucumber). All tests currently pass.
  3. Deployment script has been used to deploy to development server.
  4. Environment and setup are otherwise exactly the same as xml resolution.  
  5. A collection space is cleaned up after creating a tarball.
  6. Changes made to Core - Core decides when the tarballed collections are no longer needed via HTTP DELETE.
  7. All collection tempspace is cleaned upon service exit.
