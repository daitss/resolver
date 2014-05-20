Resolver Service
================
Optional service to replace XML Resolution.  This project is a work in progress.  Use at your own risk.
What this service does:

  1. Download external resources for a given file or files (schemas, stylesheets, etc).
  2. Returns premis reports.
  3. Create manifest reports.
  4. Tarballs collections and removes collections.
  
Reasons for this project
------------------------
  1. Smaller footprint over XML Resolution.
  2. Better resolutions for targetNamespace.
  3. Easier to implement enhancements and more maintainable code.
  4. In XML Resolution a poorly formed XML file can halt a package.  This should never happen.
  5. In the future - why not resolve HTML or CSS files?  Lots of dependancies including js and imported fonts.

Fixes over xml resolution
-------------------------
XML Resolution does not currently correctly handle stylesheets or stylesheets with import/include tags.
XML Resolution does not handle targetNamespace and thus does not download nor catch those types of links.

Current state of Resolver
-------------------------
  1. Downloads schemas, stylesheets and dtds and recusively checks for more dependancies.  
  2. Includes a test harness written in gherkin (cucumber). All tests passed.
  3. Deployment script has been used to deploy to development server.
  4. Environment and setup are otherwise exactly the same as xml resolution.  
  5. Changes made to core.  Core decides when the collections are no longer needed.
  6. Tempspace is cleaned on exit and by calling the appropriate cleanup method.
  
TODO
----
  1. Continue testing.
  2. Deploy to production.
     
