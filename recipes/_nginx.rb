# Encoding: UTF-8
# Cookbook Name::       gitlab
# Description::         Bigpoint gitlab prerequisites
# Recipe::              _nginx.rb
# Author::              Thorsten Winkler (<t.winkler@bigpoint.net>)

#include_recipe 'nginx-wrapper::default'
include_recipe 'nginx::default'
include_recipe 'nginx::http_ssl_module'

db_nginx = Chef::EncryptedDataBagItem.load('gitlab', 'nginx')

file node['gitlab']['ssl_bundle'] do
  owner 'root'
  group 'root'
  mode '0644'
  content "#{db_nginx['cert']}\n#{db_nginx['ca']}\n"
end

file node['gitlab']['ssl_private'] do
  owner 'root'
  group 'root'
  mode '0644'
  content db_nginx['certkey']
end

# Logging
# directory '/var/log/nginx' do
#  owner node['nginx']['user']
#  group node['nginx']['group']
#  mode 0755
#  action :create
# end

# if !node['rsyslog'].nil? && !node['rsyslog']['server_ip'].nil?
#  template "#{node['rsyslog']['config_prefix']}/rsyslog.d/40-nginx.conf" do
#    source 'nginx_rsyslog.erb'
#    variables ({ 'server_ip' => node['rsyslog']['server_ip'],
#                 'port' => node['rsyslog']['port'],
#                 'protocol' => node['rsyslog']['protocol'], })
#    notifies :reload, 'service[rsyslog]', :delayed
#  end
#
#  [ "/var/log/nginx/#{node['gitlab']['server_name']}.log",
#     "/var/log/nginx/#{node['gitlab']['server_name']}-error.log"].each do |fifo|
#    execute "#{fifo}_create" do
#      command "rm -f #{fifo}; mkfifo #{fifo}"
#      action :run
#      only_if { ! File.exists?(fifo) || File.ftype(fifo) != 'fifo' }
#      notifies :reload, 'service[rsyslog]', :delayed
#    end
#  end
# end

template '/etc/nginx/sites-available/gitlab' do
  source 'site_gitlab.erb'
  notifies :reload, 'service[nginx]', :delayed
end

template '/etc/nginx/sites-available/gitlab80' do
  source 'site_gitlab80.erb'
  notifies :reload, 'service[nginx]', :delayed
end

nginx_site 'gitlab'
nginx_site 'gitlab80'
