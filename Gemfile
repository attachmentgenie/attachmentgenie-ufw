source ENV['GEM_SOURCE'] || "https://rubygems.org"

def location_for(place, fake_version = nil)
  if place =~ /^(git[:@][^#]*)#(.*)/
    [fake_version, { :git => $1, :branch => $2, :require => false }].compact
  elsif place =~ /^file:\/\/(.*)/
    ['>= 0', { :path => File.expand_path($1), :require => false }]
  else
    [place, { :require => false }]
  end
end

group :test do
  gem 'json', '1.8.3',           :require => false
  gem 'json_pure', '2.0.1',      :require => false
  gem 'metadata-json-lint',      :require => false
  gem 'puppet-strings',          :require => false
  gem 'puppet_facts',            :require => false
  gem 'puppetlabs_spec_helper',  :require => false
  gem 'rspec-core',              :require => false
  gem 'simplecov',               :require => false
end

group :development do
  gem 'guard-rake',   :require => false
  gem 'redcarpet',    :require => false
  gem 'travis',       :require => false
  gem 'travis-lint',  :require => false
end

group :integration do
  gem 'concurrent-ruby', '~> 0.9',  :require => false
  gem 'kitchen-inspec',             :require => false
  gem 'kitchen-puppet',             :require => false
  gem 'kitchen-vagrant',            :require => false
  gem 'librarian-puppet',           :require => false
  gem 'test-kitchen', '~> 1.4',     :require => false
end



if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

# vim:ft=ruby
