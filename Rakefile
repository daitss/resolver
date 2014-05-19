# -*- mode:ruby; -*-

# TODO: rcov appears to be broken on my system

require 'fileutils'
require 'rake'
require 'socket'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

HOME = File.expand_path(File.dirname(__FILE__))

#map local users to server users

if ENV["USER"] == "Carol"
  user = "cchou"
else
  user = ENV["USER"]
end

desc "deploy to darchive's production site (xmlresolution.fda.fcla.edu)"
task :darchive do
    sh "cap deploy -S target=darchive.fcla.edu:/opt/web-services/sites/xmlresolution -S who=#{user}:#{user}"
end

desc "deploy to development site (xmlresolution.retsina.fcla.edu)"
task :retsina do
    sh "cap deploy -S target=retsina.fcla.edu:/opt/web-services/sites/xmlresolution -S who=#{user}:#{user}"
end

desc "deploy to development site (xmlresolution.marsala.fcla.edu)"
task :marsala do
    sh "cap deploy -S target=marsala.fcla.edu:/opt/web-services/sites/xmlresolution -S who=#{user}:#{user}"
end

desc "deploy to ripple's test site (xmlresolution.ripple.fcla.edu)"
task :ripple do
    sh "cap deploy -S target=ripple.fcla.edu:/opt/web-services/sites/xmlresolution -S who=#{user}:#{user}"
end

desc "deploy to tarchive's coop (xmlresolution.tarchive.fcla.edu?)"
task :tarchive_coop do
    sh "cap deploy -S target=tarchive.fcla.edu:/opt/web-services/sites/coop/xmlresolution -S who=#{user}:#{user}"
end

