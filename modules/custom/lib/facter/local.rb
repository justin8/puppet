require 'puppet'

local = 'false'
if Facter::Util::Resolution.exec('nslookup abachi.dray.be|grep -o 192.168.1.15') == '192.168.1.15'
  if Facter::Util::Resolution.exec('ip route|grep default|grep -o 192.168.1.1') == '192.168.1.1'
    local = 'true'
  end
end

if File.exist?('/.remote')
  local = 'false'
end

Facter.add('local') do
  setcode do
    local
  end
end
