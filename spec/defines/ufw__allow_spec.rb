require 'spec_helper'

describe 'ufw::allow', :type => :define do
  let(:title) { 'foo' }
  context 'basic operation' do
    it { should contain_exec('ufw-allow-tcp-from-any-to-any-port-all').
      with_command("ufw allow proto tcp from any to any").
      with_unless("ufw status | grep -qE ' +ALLOW +Anywhere$'")
    }
  end

  context 'specifying from address' do
    let(:params) { {:from => '192.0.2.42'} }
    it { should contain_exec('ufw-allow-tcp-from-192.0.2.42-to-any-port-all').
      with_command("ufw allow proto tcp from 192.0.2.42 to any").
      with_unless("ufw status | grep -qE ' +ALLOW +192.0.2.42$'")
    }
  end

  describe 'specifying to address' do
    context 'from ipaddress_eth0 fact' do
      let(:facts) { {:ipaddress_eth0 => '192.0.2.67'} }
      it { should contain_exec('ufw-allow-tcp-from-any-to-192.0.2.67-port-all').
        with_command("ufw allow proto tcp from any to 192.0.2.67").
        with_unless("ufw status | grep -qE '^192.0.2.67/tcp +ALLOW +Anywhere$'")
      }
    end

    context 'from $ip parameter' do
      let(:params) { {:ip => '192.0.2.68'} }
      it { should contain_exec('ufw-allow-tcp-from-any-to-192.0.2.68-port-all').
        with_command("ufw allow proto tcp from any to 192.0.2.68").
        with_unless("ufw status | grep -qE '^192.0.2.68/tcp +ALLOW +Anywhere$'")
      }
    end

    context 'when both $ip and ipaddress_eth0 are specified' do
      let(:facts) { {:ipaddress_eth0 => '192.0.2.67'} }
      let(:params) { {:ip => '192.0.2.68'} }
      it { should contain_exec('ufw-allow-tcp-from-any-to-192.0.2.68-port-all').
        with_command("ufw allow proto tcp from any to 192.0.2.68").
        with_unless("ufw status | grep -qE '^192.0.2.68/tcp +ALLOW +Anywhere$'")
      }
    end
  end

  context 'specifying port' do
    let(:params) { {:port => '8080'} }
    it { should contain_exec('ufw-allow-tcp-from-any-to-any-port-8080').
      with_command("ufw allow proto tcp from any to any port 8080").
      with_unless("ufw status | grep -qE '^8080/tcp +ALLOW +Anywhere$'")
    }
  end
end
