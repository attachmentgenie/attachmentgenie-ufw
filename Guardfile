guard 'rake', :task => 'validate' do
  watch(%r{^hiera\/.+\.yaml$})
  watch(%r{^manifests\/.+\.pp$})
  watch(%r{^metadata.json$})
  watch(%r{^templates\/.+\.erb$})
  watch(%r{^tests\/.+\.pp$})
end

guard 'rake', :task => 'lint' do
  watch(%r{^manifests\/.+\.pp$})
end

guard 'rake', :task => 'spec' do
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^manifests\/.+\.pp$})
  watch(%r{^templates\/.+\.erb$})
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb')  { "spec" }
end