require 'puppet'

real_users = ''
Facter::Util::Resolution.exec("getent passwd|awk -F: '$3 >= 1000 { print $1}'").split("\n").each do |x|
  if real_users == ''
    real_users = x
  else
    real_users.concat(' ' + x)
  end
end

Facter.add('real_users') do
  setcode do
    real_users
  end
end
