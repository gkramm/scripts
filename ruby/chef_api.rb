#!/usr/bin/env ruby
#require 'rubygems'
#require 'chef'
require 'chef/config'
require 'chef/log'
require 'chef/environment'
require 'chef/rest'
require 'chef/knife'
require 'json'
require 'optparse'
require 'chef/cookbook_loader'

options = {}
parse = OptionParser.new do |opts|
  opts.banner = "Usage: chef_api.rb [options]"
  opts.separator ""
  opts.separator "Specific options:"
  opts.on("-v", "--version version", "cookbook version") do |v|
    options[:version] = v
  end
  opts.on("-c", "--cookbook cookbook", "coookbook name") do |c|
    options[:cookbook] = c
  end
  opts.on("-e", "--environment x,y,z", Array, "list of Environment to promote to") do |e|
    options[:environment] = e
  end
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end
begin
  parse.parse!
  raise OptionParser::MissingArgument if (options[:environment].nil? || options[:cookbook].nil? || options[:version].nil? )
rescue OptionParser::InvalidOption, OptionParser::MissingArgument => e 
  puts e
  puts parse
  exit(1)
end

def check_cookbook_exists(cookbook_name,version)
  rest = Chef::REST.new(Chef::Config[:chef_server_url], Chef::Config[:validation_client_name], Chef::Config[:validation_key])
  api_endpoint = "cookbooks/#{cookbook_name}/#{version}"
  begin
    cookbooks = rest.get_rest(api_endpoint)
  rescue Net::HTTPServerException => e
    puts "#{cookbook_name}@#{version} does not exist on #{Chef::Config[:chef_server_url]} Chef Server! Upload the cookbook first \n\n"
    exit(1)
  end
end

def promote(target_env, new_cookbook_version, new_cookbook)
  print "updating environment: "
  target_env.each do |te|
    print te, " " 
    begin
      env = Chef::Environment.load(te) # pull down current env
      env.cookbook_versions[new_cookbook]=new_cookbook_version  # update with new cookbook version 
      env.save
    rescue Net::HTTPServerException => e
      if e.message.include? '400'
        puts " The contents of the request are not formatted correctly. '#{new_cookbook}@#{new_cookbook_version}'"
      elsif e.message.include? '404'
        puts "I failed to find Chef environment '#{te}'", e.message
        puts " I was looking in ", Chef::Config[:chef_server_url]
      else
        puts "an error occurred ", e.message
        exit(1)
      end
    end
  end
  puts ""
  puts "Promotion complete at #{Time.now}"
end

#new_cookbook_version = options[:version]
#new_cookbook = options[:cookbook]
#target_env = options[:environment]

config_file = "#{Dir.home}/.chef/knife.rb"
Chef::Config.from_file(config_file)
Chef::Log.level = Chef::Config[:log_level]
check_cookbook_exists(options[:cookbook],options[:version])
exit(0)
promote(options[:environment],options[:version],options[:cookbook])



