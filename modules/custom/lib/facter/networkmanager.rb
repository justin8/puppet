require 'puppet'

nm="false"
if Facter::Util::Resolution.exec("pacman -Qq networkmanager 2>/dev/null")
	nm="true"
end
Facter.add("networkmanager") do
	setcode do
		nm
	end
end
