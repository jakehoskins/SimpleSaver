#!/usr/bin/env bash
source ~/.rvm/scripts/rvm

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

rvm install ruby-2.0.0-p648
rvm use 2.0.0
rvmsudo gem install bundler
gem list
bundle install
pod install --verbose --no-repo-update

bundle exec fastlane beta
