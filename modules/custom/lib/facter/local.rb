require 'puppet'

local="false"
if Facter::Util::Resolution.exec("nslookup abachi.dray.be|grep -q 192.168.1.15")
	local="true"
end
Facter.add("local") do
	setcode do
		local
	end
end
