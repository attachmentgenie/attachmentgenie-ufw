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

guard 'rake', :task => 'strings:generate', :task_args => [''] do
  watch(%r{^manifests\/(.+)\.pp$})
  watch('README.md')
end

guard 'rake', :task => 'spec_prep' do
  watch('.fixtures.yml')
end

guard 'rake', :task => 'spec_standalone' do
  watch(%r{^examples\/(.+)\.pp$})
  watch(%r{^manifests\/(.+)\.pp$})
  watch(%r{^templates\/(.+)\.erb$})
  watch(%r{^spec\/(.+)_spec\.rb$})
  watch('spec/spec_helper.rb')
  watch('.fixtures.yml')
  watch('metadata.json')
end
