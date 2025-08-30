# frozen_string_literal: true

require 'rubocop/rake_task'

RuboCop::RakeTask.new do |task|
  task.options = ['--display-cop-names']
end

namespace :rubocop do
  desc 'Auto-fix RuboCop offenses'
  RuboCop::RakeTask.new(:auto_fix) do |task|
    task.options = ['--auto-fix', '--display-cop-names']
  end

  desc 'Generate RuboCop todo file'
  RuboCop::RakeTask.new(:todo) do |task|
    task.options = ['--auto-gen-config']
  end
end
