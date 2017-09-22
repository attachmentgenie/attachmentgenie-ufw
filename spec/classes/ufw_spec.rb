require 'spec_helper'

describe 'ufw', type: :class do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('ufw') }
      it { is_expected.to contain_anchor('ufw::begin').that_comes_before('Class[ufw::config]') }
      it { is_expected.to contain_class('ufw::config') }
      it { is_expected.to contain_class('ufw::install') }
      it { is_expected.to contain_class('ufw::params') }
      it { is_expected.to contain_class('ufw::service') }
      it { is_expected.to contain_anchor('ufw::end').that_requires('Class[ufw::service]') }

      describe 'ufw::config' do
        context 'with default parameters' do
          it do
            is_expected.to contain_exec('ufw-logging-low').
              with_command('ufw logging low').
              with_unless("grep -qE '^LOGLEVEL=low$' /etc/ufw/ufw.conf")
          end

          it 'bies default deny all incoming connections' do
            is_expected.to contain_exec('ufw-default-deny')
          end

          it do
            is_expected.to contain_file_line('forward policy').with(
              path: '/etc/default/ufw',
              line: 'DEFAULT_FORWARD_POLICY="DROP"',
              match: '^DEFAULT_FORWARD_POLICY='
            )
          end
        end

        context 'specifying log level' do
          let(:params) { { log_level: 'high' } }
          it do
            is_expected.to contain_exec('ufw-logging-high').
              with_command('ufw logging high').
              with_unless("grep -qE '^LOGLEVEL=high$' /etc/ufw/ufw.conf")
          end
        end
      end

      describe 'ufw::install' do
        context 'with default parameters' do
          it 'contains the package' do
            is_expected.to contain_package('ufw')
          end
        end
      end

      describe 'ufw::service' do
        context 'with default parameters' do
          it 'contains the service' do
            is_expected.to contain_service('ufw')
          end
          it 'enables ufw' do
            is_expected.to contain_exec('ufw-enable')
          end
        end
      end
    end
  end
end
