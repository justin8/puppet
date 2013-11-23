require 'puppet'

local="false"
if Facter::Util::Resolution.exec("smbclient -t 2 -NL abachi.dray.be > /dev/null 2>&1")
	local="true"
end
Facter.add("local") do
	setcode do
		local
	end
end
