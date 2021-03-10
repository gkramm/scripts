#!/usr/bin/ruby
require 'rubygems'
require 'json'
require 'pp'
require 'ap'
require 'git'
require 'getoptlong'

opts = GetoptLong.new(
  [ '--From', '-F', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--To', '-T', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--help', '-h', GetoptLong::OPTIONAL_ARGUMENT ]
)
opts.each do |opt, arg|
  case opt
    when '--help'
      puts <<-EOF
Usage: march -F -T 
  --From, -F env file promoting from
  --To, -T env file promoting to

  -h, --help

      EOF
      exit 0
    when '--From'
      FromEnv = arg
    when '--To'
      ToEnv = arg
  end
end

if ( !defined?(FromEnv)  || !defined?(ToEnv)) 
  puts "Missing required argumnets (try --help)"
  exit 0
end

FromObj = JSON.parse(File.read(FromEnv))
ToObj = JSON.parse(File.read(ToEnv))


puts "in #{ToEnv} Promote value From -> To"
puts "  UI_Release Ver: #{ToObj["override_attributes"]["UI_Release"]} -> #{FromObj["override_attributes"]["UI_Release"]}"
puts "  CoreClient_Release Ver: #{ToObj["override_attributes"]["CoreClient_Release"]} -> #{FromObj["override_attributes"]["CoreClient_Release"]}"
puts "  L10nService_Rlease Ver: #{ToObj["override_attributes"]["L10nService_Rlease"]} -> #{FromObj["override_attributes"]["L10nService_Rlease"]}"
ToObj["override_attributes"]["UI_Release"] =  FromObj["override_attributes"]["UI_Release"]
ToObj["override_attributes"]["CoreClient_Release"] =  FromObj["override_attributes"]["CoreClient_Release"]
ToObj["override_attributes"]["L10nService_Rlease"] =  FromObj["override_attributes"]["L10nService_Rlease"]
ToObj["cookbook_versions"]["ui"] =  FromObj["cookbook_versions"]["ui"]
ToObj["cookbook_versions"]["ui_apache"] =  FromObj["cookbook_versions"]["ui_apache"]


File.open(ToEnv,"w") do |f|
  f.write(JSON.pretty_generate(ToObj))
end
