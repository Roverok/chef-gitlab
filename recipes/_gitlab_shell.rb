# Encoding: UTF-8
# Cookbook Name::       gitlab
# Description::         Bigpoint gitlab
# Recipe::              _gitlab_shell
# Author::              Thorsten Winkler (<t.winkler@bigpoint.net>)

# patchfile = Chef::Config[:file_cache_path] + '/install.patch'

git "#{node['gitlab']['git_home']}/gitlab-shell" do
  repository 'https://github.com/gitlabhq/gitlab-shell.git'
  revision node['gitlab']['shell']['version']
  user node['gitlab']['git_user']
  group node['gitlab']['git_group']
  action :sync
end

template "#{node['gitlab']['git_home']}/gitlab-shell/config.yml" do
  source 'gitlab-shell_config.erb'
  user node['gitlab']['git_user']
  group node['gitlab']['git_group']
  mode '0644'
end

bash 'install_gitlab-shell' do
  cwd "#{node['gitlab']['git_home']}/gitlab-shell"
  code './bin/install'
  user node['gitlab']['git_user']
  action :nothing
end
