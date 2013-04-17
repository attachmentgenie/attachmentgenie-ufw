require 'spec_helper'

describe 'ufw::allow', :type => :define do
  let(:title) { 'foo' }
  context 'basic operation' do
    it { should contain_exec('ufw-allow-tcp-from-any-to-any-port-all').
      with_command("ufw allow proto tcp from any to any").
      with_unless('ufw status | grep -E " +ALLOW +Anywhere"')
    }
  end
end
