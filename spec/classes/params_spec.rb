require 'spec_helper'
describe 'ufw::params' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'It should not contain any resources' do
        it { is_expected.to contain_class('ufw::params') }
        it { is_expected.to have_resource_count(0) }
      end
    end
  end
end
