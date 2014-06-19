# Encoding: UTF-8
# Cookbook Name::       default
# Description::         Bigpoint gitlab including nginx
# Recipe::              _logrotate
# Author::              Thorsten Winkler (<t.winkler@bigpoint.net>)

template '/etc/logrotate.d/gitlab' do
  source 'logrotate.erb'
  user 'root'
  group 'root'
  mode '0644'
  variables('log_days' => node['gitlab']['log_days'])
end
