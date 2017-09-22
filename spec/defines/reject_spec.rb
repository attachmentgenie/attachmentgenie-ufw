require 'spec_helper'

describe 'ufw::reject', type: :define do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:title) { 'foo' }

      context 'basic operation' do
        it do
          is_expected.to contain_exec('ufw-reject-IN-tcp-from-any-to-any-port-all').
            with_command('ufw reject  proto tcp from any to any').
            with_unless("ufw status | grep -qE '^Anywhere/tcp +REJECT  +Anywhere( +.*)?$'")
        end
      end

      context 'specifying from address' do
        let(:params) { { from: '192.0.2.42' } }
        it do
          is_expected.to contain_exec('ufw-reject-IN-tcp-from-192.0.2.42-to-any-port-all').
            with_command('ufw reject  proto tcp from 192.0.2.42 to any').
            with_unless("ufw status | grep -qE '^Anywhere/tcp +REJECT  +192.0.2.42( +.*)?$'")
        end
      end

      describe 'specifying to address' do
        context 'from ipaddress_eth0 fact' do
          let(:facts) { { ipaddress_eth0: '192.0.2.67' } }
          it do
            is_expected.to contain_exec('ufw-reject-IN-tcp-from-any-to-any-port-all').
              with_command('ufw reject  proto tcp from any to any').
              with_unless("ufw status | grep -qE '^Anywhere/tcp +REJECT  +Anywhere( +.*)?$'")
          end
        end

        context 'from $ip parameter' do
          let(:params) { { ip: '192.0.2.68' } }
          it do
            is_expected.to contain_exec('ufw-reject-IN-tcp-from-any-to-192.0.2.68-port-all').
              with_command('ufw reject  proto tcp from any to 192.0.2.68').
              with_unless("ufw status | grep -qE '^192.0.2.68/tcp +REJECT  +Anywhere( +.*)?$'")
          end
        end

        context 'from $ip parameter (ipv6)' do
          let(:params) { { ip: '2a00:1450:4009:80c::1001' } }
          it do
            is_expected.to contain_exec('ufw-reject-IN-tcp-from-any-to-2a00:1450:4009:80c::1001-port-all').
              with_command('ufw reject  proto tcp from any to 2a00:1450:4009:80c::1001').
              with_unless("ufw status | grep -qE '^2a00:1450:4009:80c::1001/tcp +REJECT  +Anywhere \\(v6\\)( +.*)?$'")
          end
        end

        context 'when both $ip and ipaddress_eth0 are specified' do
          let(:facts) { { ipaddress_eth0: '192.0.2.67' } }
          let(:params) { { ip: '192.0.2.68' } }
          it do
            is_expected.to contain_exec('ufw-reject-IN-tcp-from-any-to-192.0.2.68-port-all').
              with_command('ufw reject  proto tcp from any to 192.0.2.68').
              with_unless("ufw status | grep -qE '^192.0.2.68/tcp +REJECT  +Anywhere( +.*)?$'")
          end
        end
      end

      context 'specifying port' do
        let(:params) { { port: '8080' } }
        it do
          is_expected.to contain_exec('ufw-reject-IN-tcp-from-any-to-any-port-8080').
            with_command('ufw reject  proto tcp from any to any port 8080').
            with_unless("ufw status | grep -qEe '^Anywhere 8080/tcp +REJECT  +Anywhere( +.*)?$' -qe '^8080/tcp +REJECT  +Anywhere( +.*)?$'")
        end
      end
    end
  end
end
