control 'ufw 01' do
  impact 1.0
  title 'ufw package is installed'
  desc 'Ensures that the ufw package is installed on this system'
  describe service('ufw') do
    it { is_expected.to be_installed }
    it { is_expected.to be_running }
  end
end
