guard 'rake', :task => 'validate' do
  watch(%r{^examples\/.+\.pp$})
  watch(%r{^manifests\/.+\.pp$})
  watch(%r{^templates\/.+\.erb$})
end

guard 'rake', :task => 'lint' do
  watch(%r{^examples\/.+\.pp$})
  watch(%r{^manifests\/.+\.pp$})
end

guard 'rake', :task => 'strings:generate', :task_args => [''] do
  watch(%r{^manifests\/.+\.pp$})
  watch(%r{^README.md$})
end

guard 'rake', :task => 'spec' do
  watch(%r{^manifests\/.+\.pp$})
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{^templates\/.+\.erb$})
  watch(%r{^metadata.json$})
end
