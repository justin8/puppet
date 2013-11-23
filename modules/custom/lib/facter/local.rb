require 'puppet'

local="false"
if Facter::Util::Resolution.exec("smbclient -t 2 -NL abachi.dray.be")
	local="true"
end
Facter.add("local") do
	setcode do
		local
	end
end
