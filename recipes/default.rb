# Encoding: UTF-8
# Cookbook Name::       default
# Description::         Bigpoint gitlab including nginx
# Recipe::              default
# Author::              Thorsten Winkler (<t.winkler@bigpoint.net>)

# MySQL/Percona
db_cred = Chef::EncryptedDataBagItem.load('gitlab', 'mysql')
node.set['mysql']['server']['packages'] = %w{percona-server-server-5.5}
node.set['mysql']['client']['packages'] = %w{percona-server-client-5.5
                                             libmysqlclient18-dev
                                             ruby-mysql}
node.set['mysql']['tunable']['innodb_file_per_table'] = true
node.set['mysql']['server_root_password'] = db_cred['root']
node.set['mysql']['server_repl_password'] = db_cred['replication']
node.set['mysql']['server_debian_password'] = db_cred['debian']
# nginx
node.set['nginx']['default_site_enabled'] = false
node.set['nginx']['client_max_body_size'] = '16M'
# For Debian Wheezy only
node.set['nginx-wrapper']['version'] = '1.4.1'
node.set['nginx-wrapper']['build'] = 'bigpoint-wheezy1_amd64'
node.set['nginx-wrapper']['url'] = \
'http://debianmirror.bigpoint.net/bigpoint-wheezy/nginx_1.4.1-bigpoint-wheezy1_amd64.deb'

include_recipe 'gitlab::_ruby'
include_recipe 'gitlab::_prerequisites'
include_recipe 'gitlab::_database'
include_recipe 'gitlab::_gitlab_shell'
include_recipe 'gitlab::_gitlab'
include_recipe 'gitlab::_logrotate'
include_recipe 'gitlab::_nginx'
