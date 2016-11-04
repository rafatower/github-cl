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
  opts.on('-e"DATE"', '--end-date="DATE"', 'End date (due date) with the format "YYYY-MM-DD"') { |v| options[:end_date] = v }

end.parse!

raise OptionParser::MissingArgument if options[:milestone_name].nil?
raise OptionParser::MissingArgument if options[:end_date].nil?

milestone_name = options[:milestone_name]
end_date = options[:end_date]

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
    if matching_milestone.due_on.to_date.to_s == end_date
      puts "        and the 'due by' field matches the expected one."
    else
      puts "        but the 'due by' field doesn't match. Fixing..."
      client.update_milestone(repo_name, matching_milestone.number, due_on: end_date)
      puts "            ...done."
    end
  else
    puts "    Creating milestone #{milestone_name}"
    client.create_milestone(repo_name, milestone_name, due_on: Date.parse(end_date)+1)
  end

end
