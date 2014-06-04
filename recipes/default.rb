# Encoding: UTF-8
# Cookbook Name::       default
# Description::         Bigpoint gitlab including nginx
# Recipe::              default
# Author::              Thorsten Winkler (<t.winkler@bigpoint.net>)

# nginx
node.set['nginx']['default_site_enabled'] = false
node.set['nginx']['client_max_body_size'] = '16M'

include_recipe 'gitlab::_ruby'
include_recipe 'gitlab::_prerequisites'
include_recipe 'gitlab::_database'
#include_recipe 'gitlab::_gitlab_shell'
include_recipe 'gitlab::_gitlab'
include_recipe 'gitlab::_logrotate'
include_recipe 'gitlab::_nginx'
