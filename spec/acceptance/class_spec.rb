require 'spec_helper_acceptance'

describe '::ufw class' do
  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
        class { 'ufw': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end

    describe package('ufw') do
      it { is_expected.to be_installed }
    end

    describe service('ufw') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end