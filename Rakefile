require 'rake'

begin
  require 'rspec/core/rake_task'
  require 'puppet-lint/tasks/puppet-lint'
rescue LoadError
  require 'rubygems'
  retry
end

task :test => [:lint]

task :default => :test