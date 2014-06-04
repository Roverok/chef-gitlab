# Encoding: UTF-8
# Cookbook Name::       gitlab
# Description::         Sets up the database
# Recipe::              _database
# Author::              Thorsten Winkler (<t.winkler@bigpoint.net>)

if node['gitlab']['use_bp_percona']
  node.set['bp-percona']['credidentials'] = ['gitlab', 'mysql', node['gitlab']['instance']]
  node.set_unless['bp-percona']['innodb-buffer-pool-size'] = '256M'
  include_recipe 'bp-percona::_server'
  root_password = get_root_password
else
  include_recipe 'mysql-chef_gem::default' unless `/opt/chef/embedded/bin/gem list`.include? 'mysql '

  mysql_db = Chef::EncryptedDataBagItem.load('gitlab', 'mysql')[node['gitlab']['instance']]
  root_password = mysql_db['root']

  node.set['mysql']['server_root_password'] = mysql_db['root']
  node.set['mysql']['server_repl_password'] = mysql_db['replication']
  node.set['mysql']['server_debian_password'] = mysql_db['debian']
  include_recipe 'mysql::server'
end

db_db = Chef::EncryptedDataBagItem.load('gitlab', 'db')[node['gitlab']['instance']]

include_recipe 'database::default'
mysql_connection_info = { :host => 'localhost',
                          :username => 'root',
                          :password => root_password }

mysql_database db_db['db']  do
  connection mysql_connection_info
  action :create
end

mysql_database_user db_db['username'] do
  connection mysql_connection_info
  password db_db['password']
  action :create
end

mysql_database_user db_db['username'] do
  connection mysql_connection_info
  password db_db['password']
  database_name db_db['db']
  host 'localhost'
  privileges ['select', 'lock tables', 'insert', 'update', 'delete',
              'create', 'drop', 'index', 'alter']
  action :grant
end
