# Github command-line tools
## Intro
This is just a small repo with some utilities that I found useful to me.

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
bundle exec ./create-milestones.rb -m "My milestone" -e "2016-06-16"
```

## To-do list
* [ ] Script to move issues to another milestone
* [ ] Script to close milestone
* [ ] Publish
