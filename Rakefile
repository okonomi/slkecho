# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

require "steep/rake_task"

Steep::RakeTask.new(:steep)

task default: %i[spec rubocop steep]
