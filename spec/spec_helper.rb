require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.default_facts = {
    :ipaddress       => '192.168.42.42',
    :ipaddress_eth0  => '192.168.42.42',
    :lsbdistcodename => 'xenial',
  }
  c.after(:suite) do
    RSpec::Puppet::Coverage.report!
  end
end
