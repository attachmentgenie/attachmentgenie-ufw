describe service('ufw') do
  it { should be_installed }
  it { should be_running }
end
describe port(22) do
  it { should be_listening }
end
