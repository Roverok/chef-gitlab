# Encoding: UTF-8
default['gitlab']['shell']['version'] = 'v1.9.6'
default['gitlab']['shell']['self_signed_cert'] = true
default['gitlab']['shell']['repos_path'] = '/home/git/repositories'
default['gitlab']['shell']['auth_file'] = '/home/git/.ssh/authorized_keys'
default['gitlab']['shell']['redis']['bin'] = '/usr/bin/redis-cli'
default['gitlab']['shell']['redis']['host'] = '127.0.0.1'
default['gitlab']['shell']['redis']['port'] = 6379
default['gitlab']['shell']['redis']['socket'] = '/tmp/redis.socket'
default['gitlab']['shell']['redis']['namespace'] = ' resque:gitlab'
default['gitlab']['shell']['log_file'] = "#{node['gitlab']['git_home']}/gitlab-shell/gitlab-shell.log"
default['gitlab']['shell']['log_level'] = 'INFO'
default['gitlab']['shell']['http_user'] = ''
default['gitlab']['shell']['http_password'] = ''
default['gitlab']['shell']['ca_file'] = '/etc/ssl/cert.pem'
default['gitlab']['shell']['ca_path'] = '/etc/pki/tls/certs'
default['gitlab']['shell']['audit_usernames'] = false
