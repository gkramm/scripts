#!/usr/bin/ruby
#require 'rubygems'
#require 'pp'
require 'ap'
#require 'git'
require 'json'
require 'getoptlong'
require 'pathname'
require 'logger'

opts = GetoptLong.new(
  [ '--From', '-F', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--To', '-T', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--cookbook', '-c', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--help', '-h', GetoptLong::OPTIONAL_ARGUMENT ]
)
opts.each do |opt, arg|
  case opt
    when '--help'
      puts <<-EOF
Usage: march -F -T 
  --From, -F env file promoting from
  --To, -T env file promoting to
  --cookbook, -c cookbook to promote

  -h, --help

      EOF
      exit 0
    when '--From'
      FromEnv = arg
    when '--cookbook'
      CB = arg
    when '--To'
      ToEnv = arg
  end
end

if ( !defined?(FromEnv)  || !defined?(ToEnv) || !defined?(CB)) 
  puts "Missing required argumnets (try --help)"
  exit 0
end

system("knife environment show #{FromEnv} -Fj > #{FromEnv}")
system("knife environment show #{ToEnv} -Fj > #{ToEnv}")
FromObj = JSON.parse(File.read(FromEnv))
ToObj = JSON.parse(File.read(ToEnv))
ap "From Ver: #{FromObj["cookbook_versions"][CB]}"
ap "To Ver: #{ToObj["cookbook_versions"][CB]}"
ToObj["cookbook_versions"][CB] = FromObj["cookbook_versions"][CB]

File.open(ToEnv,"w") do |f|
  f.write(JSON.pretty_generate(ToObj))
end

File.delete(FromEnv)
File.delete(ToEnv)
#
# do not do this until you're really ready
# REALLY!
#system("knife environment from file #{ToEv}")
#


#working_dir = Pathname.getwd
#g = Git.open(working_dir, :log => Logger.new(STDOUT))
#g.index
#puts g.log
