require 'puppet'

Facter::Util::Resolution.exec(
    "getent passwd|awk -F: '{ print $1\"=\"$6}'").split("\n").each do |x|
  user, home = x.split('=')
  Facter.add('home_' + user) do
    setcode do
      home
    end
  end
end
