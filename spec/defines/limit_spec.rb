require 'spec_helper'

describe 'ufw::limit', :type => :define do
  let(:title) { 'foo' }
  context 'basic operation' do
    it { should contain_exec('ufw limit foo/tcp').
      with_command("ufw limit foo/tcp").
      with_unless("ufw status | grep -qE '^foo/tcp +LIMIT +Anywhere'")
    }
  end

  context 'specifying proto' do
    let(:params) { {:proto => 'udp'} }
    it { should contain_exec('ufw limit foo/udp').
      with_command("ufw limit foo/udp").
      with_unless("ufw status | grep -qE '^foo/udp +LIMIT +Anywhere'")
    }
  end

end
