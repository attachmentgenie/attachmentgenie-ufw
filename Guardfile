guard 'rake', :task => 'validate' do
  watch(%r{^examples\/.+\.pp$})
  watch(%r{^hiera\/.+\.yaml$})
  watch(%r{^manifests\/.+\.pp$})
  watch(%r{^metadata.json$})
  watch(%r{^templates\/.+\.erb$})
  watch(%r{^tests\/.+\.pp$})
end

guard 'rake', :task => 'lint' do
  watch(%r{^examples\/.+\.pp$})
  watch(%r{^manifests\/.+\.pp$})
  watch(%r{^tests\/.+\.pp$})
end

guard 'rake', :task => 'strings:generate' do
  watch(%r{^manifests\/.+\.pp$})
  watch(%r{^README.md$})
end

guard 'rake', :task => 'spec' do
  watch(%r{^manifests\/.+\.pp$})
  watch(%r{^templates\/.+\.erb$})
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb')  { "spec" }
end
