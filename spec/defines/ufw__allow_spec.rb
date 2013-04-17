require 'spec_helper'

describe 'ufw::allow', :type => :define do
  let(:title) { 'foo' }
  it { should contain_exec('ufw-allow-tcp-from-any-to-any-port-all') }
end
