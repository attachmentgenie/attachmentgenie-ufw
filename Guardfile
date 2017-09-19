guard 'rake', :task => 'validate' do
  watch(%r{^examples\/(.+)\.pp$})
  watch(%r{^manifests\/(.+)\.pp$})
  watch(%r{^templates\/(.+)\.erb$})
end

guard 'rake', :task => 'lint' do
  watch(%r{^examples\/(.+)\.pp$})
  watch(%r{^manifests\/(.+)\.pp$})
  watch(%r{^templates\/(.+)\.erb$})
end

guard 'rake', :task => 'rubocop' do
watch(%r{^lib\/(.+)\.rb$})
watch(%r{^spec\/(.+)\.rb$})
end

guard 'rake', :task => 'strings:generate', :task_args => [''] do
  watch(%r{^manifests\/(.+)\.pp$})
  watch('README.md')
end

guard 'rake', :task => 'spec' do
  watch(%r{^examples\/(.+)\.pp$})
  watch(%r{^manifests\/(.+)\.pp$})
  watch(%r{^templates\/(.+)\.erb$})
  watch(%r{^spec\/(.+)_spec\.rb$})
  watch('spec/spec_helper.rb')
  watch('.fixtures.yml')
  watch('metadata.json')
end

=begin
guard 'rake', :task => 'kitchen:all' do
  watch(%r{^manifests\/(.+)\.pp$})
  watch('.kitchen.yml')
end
=end
