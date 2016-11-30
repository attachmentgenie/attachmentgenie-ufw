require 'spec_helper'

describe 'ufw', :type => :class do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile.with_all_deps }
      it { should contain_class('ufw') }
      it { should contain_anchor('ufw::begin').that_comes_before('Class[ufw::config]') }
      it { should contain_class('ufw::config') }
      it { should contain_class('ufw::install') }
      it { should contain_class('ufw::params') }
      it { should contain_class('ufw::service') }
      it { should contain_anchor('ufw::end').that_requires('Class[ufw::service]') }

      describe "ufw::config" do
        context 'with default parameters' do
          it { should contain_exec('ufw-logging-low').
            with_command("ufw logging low").
            with_unless("grep -qE '^LOGLEVEL=low$' /etc/ufw/ufw.conf")
          }

          it 'should by default deny all incoming connections' do
            should contain_exec('ufw-default-deny')
          end

          it { should contain_file_line('forward policy').with(
            :path   => '/etc/default/ufw',
            :line   => 'DEFAULT_FORWARD_POLICY="DROP"',
            :match  => '^DEFAULT_FORWARD_POLICY='
          )}
        end

        context 'specifying log level' do
          let(:params) { {:log_level => 'high'} }
          it { should contain_exec('ufw-logging-high').
            with_command("ufw logging high").
            with_unless("grep -qE '^LOGLEVEL=high$' /etc/ufw/ufw.conf")
          }
        end
      end

      describe "ufw::install" do
        context 'with default parameters' do
          it 'should contain the package' do
            should contain_package('ufw')
          end
        end
      end

      describe "ufw::service" do
        context 'with default parameters' do
          it 'should contain the service' do
            should contain_service('ufw')
          end
          it 'should enable ufw' do
            should contain_exec('ufw-enable')
          end
        end
      end
    end
  end
end