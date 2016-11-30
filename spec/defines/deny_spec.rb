require 'spec_helper'

describe 'ufw::deny', :type => :define do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:title) { 'foo' }

      context 'basic operation' do
        it { should contain_exec('ufw-deny-IN-tcp-from-any-to-any-port-all').
          with_command("ufw deny  proto tcp from any to any").
          with_unless("ufw status | grep -qE 'Anywhere/tcp +DENY  +Anywhere'")
        }
      end

      context 'specifying from address' do
        let(:params) { {:from => '192.0.2.42'} }
        it { should contain_exec('ufw-deny-IN-tcp-from-192.0.2.42-to-any-port-all').
          with_command("ufw deny  proto tcp from 192.0.2.42 to any").
          with_unless("ufw status | grep -qE 'Anywhere/tcp +DENY  +192.0.2.42'")
        }
      end

      describe 'specifying to address' do
        context 'from ipaddress_eth0 fact' do
          let(:facts) { {:ipaddress_eth0 => '192.0.2.67'} }
          it { should contain_exec('ufw-deny-IN-tcp-from-any-to-any-port-all').
            with_command("ufw deny  proto tcp from any to any").
            with_unless("ufw status | grep -qE 'Anywhere/tcp +DENY  +Anywhere'")
          }
        end

        context 'from $ip parameter' do
          let(:params) { {:ip => '192.0.2.68'} }
          it { should contain_exec('ufw-deny-IN-tcp-from-any-to-192.0.2.68-port-all').
            with_command("ufw deny  proto tcp from any to 192.0.2.68").
            with_unless("ufw status | grep -qE '192.0.2.68/tcp +DENY  +Anywhere'")
          }
        end

        context 'from $ip parameter (ipv6)' do
          let(:params) { {:ip => '2a00:1450:4009:80c::1001'} }
          it { should contain_exec('ufw-deny-IN-tcp-from-any-to-2a00:1450:4009:80c::1001-port-all').
            with_command("ufw deny  proto tcp from any to 2a00:1450:4009:80c::1001").
            with_unless("ufw status | grep -qE '2a00:1450:4009:80c::1001/tcp +DENY  +Anywhere \\(v6\\)'")
          }
        end

        context 'when both $ip and ipaddress_eth0 are specified' do
          let(:facts) { {:ipaddress_eth0 => '192.0.2.67'} }
          let(:params) { {:ip => '192.0.2.68'} }
          it { should contain_exec('ufw-deny-IN-tcp-from-any-to-192.0.2.68-port-all').
            with_command("ufw deny  proto tcp from any to 192.0.2.68").
            with_unless("ufw status | grep -qE '192.0.2.68/tcp +DENY  +Anywhere'")
          }
        end
      end

      context 'specifying port' do
        let(:params) { {:port => '8080'} }
        it { should contain_exec('ufw-deny-IN-tcp-from-any-to-any-port-8080').
          with_command("ufw deny  proto tcp from any to any port 8080").
          with_unless("ufw status | grep -qEe '^Anywhere 8080/tcp +DENY  +Anywhere( +.*)?$' -qe '^8080/tcp +DENY +Anywhere( +.*)?$'")
        }
      end
    end
  end
end
