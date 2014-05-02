# Encoding: UTF-8
# Cookbook Name::       gitlab
# Description::         Bigpoint gitlab prerequisites
# Recipe::              _prerequisites
# Author::              Thorsten Winkler (<t.winkler@bigpoint.net>)

include_recipe 'apt::default'

node['gitlab']['p_packages'].each do |pkg|
  package pkg do
    action :install
  end
end

package 'python' do
  action :install
end

link '/usr/bin/python2' do
  to '/usr/bin/python'
  action :create
end

group node['gitlab']['git_group'] do
  action :create
end

user node['gitlab']['git_user'] do
  comment 'GitLab'
  group node['gitlab']['git_group']
  system true
  home node['gitlab']['git_home']
  shell '/bin/bash'
end

directory node['gitlab']['git_home'] do
  owner node['gitlab']['git_user']
  group node['nginx']['group']
  mode '0750'
end

group 'mail' do
  members node['gitlab']['git_user']
  action :modify
end
