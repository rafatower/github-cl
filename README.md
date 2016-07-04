# Github command-line tools
## Intro
This is just a small repo with some utilities that I found useful to me, for my particular github + zenhub workflow.

## Installation
```shell
# get the dependencies
bundle install

# create a config file
cp config.yml.sample config.yml
vim config.yml
```

## Usage
```shell
bundle exec ./create-milestones.rb --help
```

```shell
bundle exec ./create-milestones.rb -m "My new milestone" -e "2016-06-16"
bundle exec ./move-issues.rb --source="My old milestone" --dest="My new milestone"
bundle exec ./close-milestones.rb --milestone="My old milestone"
```

## To-do list
* [x] Script to move issues to another milestone
* [x] Script to close milestone
* [x] Publish
