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

  opts.on('-m"NAME"', '--milestone="NAME"', 'Milestone name') { |v| options[:milestone_name] = v }

end.parse!

raise OptionParser::MissingArgument if options[:milestone_name].nil?

milestone_name = options[:milestone_name]

client = Octokit::Client.new(:access_token => oauth_access_token)

repos.each do |repo_name|

  puts "Accessing repo #{repo_name}"
  repo = client.repository repo_name

  puts "    Checking if milestone #{milestone_name} exists"
  rel = repo.rels[:milestones]
  milestones = rel.get.data
  matching_milestone = milestones.select { |m| m[:title] == milestone_name  }.first
  if matching_milestone
    puts "    The milestone #{milestone_name} already exists"
  else
    puts "    Creating milestone #{milestone_name}"
    client.create_milestone(repo_name, milestone_name)
  end

end
