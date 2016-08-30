require 'spec_helper'

describe 'ufw' do

  let(:title) { 'foo' }
  context 'basic operation' do
    it { should contain_exec('ufw-logging-low').
      with_command("ufw logging low").
      with_unless("grep -qE '^LOGLEVEL=low$' /etc/ufw/ufw.conf")
    }
  end

  context 'specifying level' do
    let(:params) { {:log_level => 'high'} }
    it { should contain_exec('ufw-logging-high').
      with_command("ufw logging high").
      with_unless("grep -qE '^LOGLEVEL=high$' /etc/ufw/ufw.conf")
    }
  end
end