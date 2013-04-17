require 'spec_helper'

describe 'ufw::allow', :type => :define do
  let(:title) { 'foo' }
  context 'basic operation' do
    it { should contain_exec('ufw-allow-tcp-from-any-to-any-port-all').
      with_command("ufw allow proto tcp from any to any").
      with_unless('ufw status | grep -E " +ALLOW +Anywhere"')
    }
  end

  context 'when specifying from address' do
    let(:params) { {:from => '192.0.2.42'} }
    it { should contain_exec('ufw-allow-tcp-from-192.0.2.42-to-any-port-all').
      with_command("ufw allow proto tcp from 192.0.2.42 to any").
      with_unless('ufw status | grep -E " +ALLOW +192.0.2.42/tcp"')
    }
  end
end
