#!/usr/bin/env ruby
# 201400518/JT
# Version 0.1
#
# TODO: Read: http://www.slideshare.net/timanglade/couchdb-ruby-youre-doing-it-wrong

require 'rubygems'
require 'json'
require 'couchrest'
require 'net/http'
require './couchdb.mod.rb'

puts "icdb version 0.1 (Image-CouchDB) Client"

Tmpl_config_file = {
  "_comment" => "ICDB configuration file.",
  "config"=> {
      "image_root_dir"=> "/data/workspace/git/github.com.spreadcat.octopress-cdb/images",
      "db_name"       => "images",
      "db_host"       => "localhost",
      "dp_port"       => "5984"
  }
}

# Get the current config file
# If no file is found, offer to create one
# or exit if none shall be created.
def find_config_file
  path_config_file = [
      "~/.icdb.cnf.json",
      "./.icdb.cnf.json",
      "/etc/icdb.cnf.json",
    ]

  # Checking for config file
  path_config_file.each do|p|
    if File.file?( File.expand_path(p) )
      $path_found = File.expand_path(p)
      break
    end
  end

  # If no config file was found, offer to create one or exit.
  if $path_found.nil?  then
    puts "No config file found. Shall I create it (~/.icdb.cnf.json) ? [Y]"
    config_file_create = gets.chomp
    if config_file_create.eql? 'y'
      path_config_file = './.icdb.cnf.json'
      f = File.open(path_config_file, 'w') do |f|
        f.write( JSON.pretty_generate(Tmpl_config_file) )
      end
      $path_found = path_config_file
    else
      abort
    end
  end
  $path_found
end

#
# Read the JSON format from the config file
#
def read_config_file (path_config_file)
  if File.file?(path_config_file)
    File.open( path_config_file, 'r') do |f|
      JSON.load(f)
    end
  end
end
#############################
# Main
#############################
path_config_file = find_config_file
config = read_config_file( path_config_file )

# Make sure couchDB is actually running
if `ps aux | grep couchdb` == ""
  puts "CouchDB is not running. Please start/install CouchDB first."
  exit
end

#
# Check if database is existing
#   If not: create it
@db = CouchRest.database!(config['config']['db_host'] + ':' + config['config']['db_port'] + "/couchrest-test")
#server  = Couch::Server.new( config['config']['db_host'] , config['config']['db_port'] )
#all_dbs = server.listdbs()

#all_dbs.each do |d|
#  puts d
#end


puts "=====\nCurrent config:"
puts config

