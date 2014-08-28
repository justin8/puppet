require 'puppet'

local = 'false'
if Facter::Util::Resolution.exec('test -f /.remote || nslookup abachi.dray.be|grep 192.168.1.15 && ip route|grep default|grep 192.168.1.1')
  local = 'true'
end
Facter.add('local') do
  setcode do
    local
  end
end
