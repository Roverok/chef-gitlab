# Encoding: UTF-8
# Cookbook Name::       gitlab
# Description::         Bigpoint gitlab
# Recipe::              _gitlab
# Author::              Thorsten Winkler (<t.winkler@bigpoint.net>)

git "#{node['gitlab']['git_home']}/gitlab" do
  repository 'https://github.com/gitlabhq/gitlabhq.git'
  revision node['gitlab']['gitlab_version']
  user node['gitlab']['git_user']
  group node['gitlab']['git_group']
  action :sync
end

db_ldap = Chef::EncryptedDataBagItem.load('gitlab', 'ldap')

template "#{node['gitlab']['git_home']}/gitlab/config/gitlab.yml" do
  source 'gitlab.yml.erb'
  user node['gitlab']['git_user']
  group node['gitlab']['git_group']
  variables('host' => db_ldap['host'],
            'port' => db_ldap['port'],
            'uid' => db_ldap['uid'],
            'method' => db_ldap['method'],
            'bind_dn' => db_ldap['bind_dn'],
            'password' => db_ldap['password'],
            'allow_username_or_email_login' => !db_ldap['allow_username_or_email_login'].nil? && db_ldap['allow_username_or_email_login'] ? 'true' : 'false',
            'base' => db_ldap['base'],
            'user_filter' => db_ldap['user_filter'])
  mode '0644'
end

template "#{node['gitlab']['git_home']}/gitlab/config/unicorn.rb" do
  source 'unicorn.erb'
  user node['gitlab']['git_user']
  group node['gitlab']['git_group']
  mode '0644'
end

cookbook_file "#{node['gitlab']['git_home']}/gitlab/config/initializers/rack_attack.rb" do
  source 'rack_attack.rb'
  user node['gitlab']['git_user']
  mode 0644
end

template "#{node['gitlab']['git_home']}/gitlab/config/application.rb" do
  source 'application.erb'
  user node['gitlab']['git_user']
  group node['gitlab']['git_group']
  mode '0644'
end

db_db = Chef::EncryptedDataBagItem.load('gitlab', 'db')

template "#{node['gitlab']['git_home']}/gitlab/config/database.yml" do
  source 'database.yml.erb'
  user node['gitlab']['git_user']
  group node['gitlab']['git_group']
  variables('username' => db_db['username'],
            'password' => db_db['password'],
            'database' => db_db['db'])
  mode '0600'
end

template "#{node['gitlab']['git_home']}/gitlab/config/environments/production.rb" do
  source 'production.erb'
  user node['gitlab']['git_user']
  group node['gitlab']['git_group']
  variables('method' => node['gitlab']['mailer']['method'],
            'address' => node['gitlab']['mailer']['address'],
            'port' => node['gitlab']['mailer']['port'],
            'domain' => node['gitlab']['mailer']['domain'],
            'authentication' => node['gitlab']['mailer']['authentication'],
            'user_name' => node['gitlab']['mailer']['user_name'],
            'password' => node['gitlab']['mailer']['password'],
            'enable_starttls_auto' => node['gitlab']['mailer']['enable_starttls_auto'])
  mode '0644'
end

bash 'fix_permissions_gl' do
  cwd node['gitlab']['git_home']
  user node['gitlab']['git_user']
  environment 'HOME' => node['gitlab']['git_home']
  code <<-EOH
    chown -R #{node['gitlab']['git_user']} gitlab/log/
    chown -R #{node['gitlab']['git_user']} gitlab/tmp/
    chmod -R u+rwX  gitlab/log/
    chmod -R u+rwX  gitlab/tmp/
  EOH
end

directory "#{node['gitlab']['git_home']}/gitlab-satellites" do
  user node['gitlab']['git_user']
  group node['gitlab']['git_group']
  mode '0755'
end

directory "#{node['gitlab']['git_home']}/gitlab/tmp/pids" do
  user node['gitlab']['git_user']
  group node['gitlab']['git_group']
  mode '0777'
end

directory "#{node['gitlab']['git_home']}/gitlab/tmp/sockets" do
  user node['gitlab']['git_user']
  group node['gitlab']['git_group']
  mode '0777'
end

directory "#{node['gitlab']['git_home']}/gitlab/public/uploads" do
  user node['gitlab']['git_user']
  group node['gitlab']['git_group']
  mode '0777'
end

directory node['gitlab']['git_repositories'] do
  action :create
  recursive true
  owner node['gitlab']['git_user']
  group node['gitlab']['git_group']
  mode '2770'
end

directory node['gitlab']['git_hooks'] do
  action :create
  recursive true
  owner node['gitlab']['git_user']
  group node['gitlab']['git_group']
  mode '0775'
end

bash 'configure_git_global' do
  cwd "#{node['gitlab']['git_home']}/gitlab"
  user node['gitlab']['git_user']
  environment 'HOME' => node['gitlab']['git_home']
  code <<-EOH
    git config --global user.name "GitLab"
    git config --global user.email "#{node['gitlab']['email_from']}"
  EOH
end

execute 'install_gems' do
  cwd "#{node['gitlab']['git_home']}/gitlab"
  command "bundle install --deployment --without development test postgres aws"
  environment 'HOME' => node['gitlab']['git_home']
  user node['gitlab']['git_user']
  not_if { File.exists?("#{node['gitlab']['git_home']}/gitlab/.gitlab-setup") }
end

execute 'gitlab-bundle-rake' do
  command "echo yes | bundle exec rake gitlab:setup RAILS_ENV=production && touch .gitlab-setup"
  environment 'HOME' => node['gitlab']['git_home']
  cwd "#{node['gitlab']['git_home']}/gitlab"
  user node['gitlab']['git_user']
  not_if { File.exists?("#{node['gitlab']['git_home']}/gitlab/.gitlab-setup") }
end

template '/etc/default/gitlab' do
  source 'default_gitlab.erb'
  user 'root'
  group 'root'
  mode '0644'
end

template '/etc/init.d/gitlab' do
  source 'init_gitlab.erb'
  user 'root'
  group 'root'
  mode '0755'
end

service 'gitlab' do
  action    [:enable, :start]
  supports :status => true, :start => true, :stop => true, :restart => true
end
