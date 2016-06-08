#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'octokit'
require 'yaml'
require 'optparse'

# Read config
config = YAML.load_file('config.yml')
oauth_access_token = config.fetch('oauth_access_token')
repos = config.fetch('repos')

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__} [options]"

  opts.on('-s"NAME"', '--source="NAME"', 'Source milestone name') { |v| options[:source_milestone_name] = v }
  opts.on('-d"NAME"', '--dest="NAME"', 'Destination milestone name') { |v| options[:dest_milestone_name] = v }

end.parse!

raise OptionParser::MissingArgument if options[:source_milestone_name].nil?
raise OptionParser::MissingArgument if options[:dest_milestone_name].nil?

source_milestone_name = options[:source_milestone_name]
dest_milestone_name = options[:dest_milestone_name]

client = Octokit::Client.new(:access_token => oauth_access_token)

repos.each do |repo_name|

  puts "Accessing repo #{repo_name}"
  repo = client.repository repo_name

  print "    Checking if milestone '#{source_milestone_name}' exists... "
  rel = repo.rels[:milestones]
  milestones = rel.get.data
  matching_milestone = milestones.select { |m| m[:title] == source_milestone_name  }.first
  if matching_milestone
    puts "YES"
    puts "TODO: open destination milestone"
  else
    puts "NO. Nothing to do"
  end

end
