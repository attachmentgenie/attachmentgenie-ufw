require 'spec_helper'

describe 'ufw::allow', :type => :define do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:title) { 'foo' }

      context 'basic operation' do
        it { should contain_exec('ufw-allow-IN-tcp-from-any-to-192.168.42.42-port-all').
          with_command("ufw allow  proto tcp from any to 192.168.42.42").
          with_unless("ufw status | grep -qE '^192.168.42.42/tcp +ALLOW +Anywhere( +.*)?$'")
        }
      end

      context 'specifying from address' do
        let(:params) { {:from => '192.0.2.42'} }
        it { should contain_exec('ufw-allow-IN-tcp-from-192.0.2.42-to-192.168.42.42-port-all').
          with_command("ufw allow  proto tcp from 192.0.2.42 to 192.168.42.42").
          with_unless("ufw status | grep -qE '^192.168.42.42/tcp +ALLOW +192.0.2.42/tcp( +.*)?$'")
        }
      end

      describe 'specifying to address' do
        context 'from ipaddress_eth0 fact' do
          let(:facts) { {:ipaddress_eth0 => '192.0.2.67'} }
          it { should contain_exec('ufw-allow-IN-tcp-from-any-to-192.0.2.67-port-all').
            with_command("ufw allow  proto tcp from any to 192.0.2.67").
            with_unless("ufw status | grep -qE '^192.0.2.67/tcp +ALLOW +Anywhere( +.*)?$'")
          }
        end

        context 'from $ip parameter' do
          let(:params) { {:ip => '192.0.2.68'} }
          it { should contain_exec('ufw-allow-IN-tcp-from-any-to-192.0.2.68-port-all').
            with_command("ufw allow  proto tcp from any to 192.0.2.68").
            with_unless("ufw status | grep -qE '^192.0.2.68/tcp +ALLOW +Anywhere( +.*)?$'")
          }
        end

        context 'from $ip parameter (any protocol)' do
          let(:params) { {:ip => '192.0.2.68'} }
          it { should contain_exec('ufw-allow-IN-any-from-any-to-192.0.2.68-port-all').
                       with_command("ufw allow  proto any from any to 192.0.2.68").
                       with_unless("ufw status | grep -qE '^192.0.2.68 +ALLOW +Anywhere( +.*)?$'")
          }
        end

        context 'from $ip parameter (ipv6)' do
          let(:params) { {:ip => '2a00:1450:4009:80c::1001'} }
          it { should contain_exec('ufw-allow-IN-tcp-from-any-to-2a00:1450:4009:80c::1001-port-all').
            with_command("ufw allow  proto tcp from any to 2a00:1450:4009:80c::1001").
            with_unless("ufw status | grep -qE '^2a00:1450:4009:80c::1001/tcp +ALLOW +Anywhere \\(v6\\)( +.*)?$'")
          }
        end

        context 'from $ip parameter (ipv6, any protocol)' do
          let(:params) { {:ip => '2a00:1450:4009:80c::1001'} }
          it { should contain_exec('ufw-allow-IN-any-from-any-to-2a00:1450:4009:80c::1001-port-all').
                       with_command("ufw allow  proto any from any to 2a00:1450:4009:80c::1001").
                       with_unless("ufw status | grep -qE '^2a00:1450:4009:80c::1001 +ALLOW +Anywhere \\(v6\\)( +.*)?$'")
          }
        end

        context 'when both $ip and ipaddress_eth0 are specified' do
          let(:facts) { {:ipaddress_eth0 => '192.0.2.67'} }
          let(:params) { {:ip => '192.0.2.68'} }
          it { should contain_exec('ufw-allow-IN-tcp-from-any-to-192.0.2.68-port-all').
            with_command("ufw allow  proto tcp from any to 192.0.2.68").
            with_unless("ufw status | grep -qE '^192.0.2.68/tcp +ALLOW +Anywhere( +.*)?$'")
          }
        end

        context 'when from is a specific ip address' do
          let(:facts) { {:ipaddress_eth0 => '192.0.2.68'} }
          let(:params) { {:from => '192.0.2.69'} }
          it { should contain_exec('ufw-allow-IN-tcp-from-192.0.2.69-to-192.0.2.68-port-all').
            with_command("ufw allow  proto tcp from 192.0.2.69 to 192.0.2.68").
            with_unless("ufw status | grep -qE '^192.0.2.68/tcp +ALLOW +192.0.2.69/tcp( +.*)?$'")
          }
        end
      end

      context 'specifying port' do
        let(:params) { {:port => '8080'} }
        it { should contain_exec('ufw-allow-IN-tcp-from-any-to-192.168.42.42-port-8080').
          with_command("ufw allow  proto tcp from any to 192.168.42.42 port 8080").
          with_unless("ufw status | grep -qE '^192.168.42.42 8080/tcp +ALLOW +Anywhere( +.*)?$'")
        }
      end

      context 'specifying port for any protocol' do
        let(:params) { {:port => '8080'} }
        it { should contain_exec('ufw-allow-IN-any-from-any-to-192.168.42.42-port-8080').
                     with_command("ufw allow  proto any from any to 192.168.42.42 port 8080").
                     with_unless("ufw status | grep -qE '^192.168.42.42 8080 +ALLOW +Anywhere( +.*)?$'")
        }
      end

      context 'with ensure => absent' do
        let(:params) { {:ensure => 'absent'} }
        it { should contain_exec('ufw-delete-tcp-from-any-to-192.168.42.42-port-all').
          with_command("ufw delete allow  proto tcp from any to 192.168.42.42").
          with_onlyif("ufw status | grep -qE '^192.168.42.42/tcp +ALLOW +Anywhere$'")
        }
      end
    end
  end
end
