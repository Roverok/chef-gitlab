# Encoding: UTF-8
#default
default['gitlab']['instance'] = 'gitlab'
default['gitlab']['use_bp_percona'] = true
default['gitlab']['ruby2'] = ! `apt-cache search ruby2.0`.empty?
default['gitlab']['server_name'] = 'gitlab.bigpoint.net'
default['gitlab']['ssl_private'] = '/etc/ssl/private/gitlab.key'
default['gitlab']['ssl_bundle'] = '/etc/ssl/certs/gitlab-bundle.pem'
default['gitlab']['gitlab_version'] = '7-0-stable'
default['gitlab']['p_packages'] = %w{build-essential zlib1g-dev libyaml-dev libssl-dev
                                     libgdbm-dev libreadline-dev libncurses5-dev libffi-dev
                                     curl git-core openssh-server redis-server checkinstall
                                     libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev
                                     logrotate python-docutils}
default['gitlab']['git_user'] = 'git'
default['gitlab']['git_group'] = 'git'
default['gitlab']['git_home'] = '/home/git'
default['gitlab']['git_repositories'] = "#{node['gitlab']['git_home']}/repositories/"
#default['gitlab']['git_hooks'] = "#{node['gitlab']['git_home']}/gitlab-shell/hooks/"
# gitlab.yml
default['gitlab']['port'] = '443'
# timeout applies to unicorn and nginx
default['gitlab']['timeout'] = 45
default['gitlab']['email_from'] = 'gitlab@bigpoint.net'
default['gitlab']['support_email'] = 'sysadmins@bigpoint.net'
default['gitlab']['log_days'] = 14
default['gitlab']['mailer']['method'] = 'smtp'
default['gitlab']['mailer']['address'] = 'mailsrv.bigpoint.net'
default['gitlab']['mailer']['port'] = 25
default['gitlab']['mailer']['domain'] = 'bigpoint.net'
default['gitlab']['mailer']['authentication'] = nil
default['gitlab']['mailer']['user_name'] = nil
default['gitlab']['mailer']['password'] = nil
default['gitlab']['mailer']['enable_starttls_auto'] = true
default['gitlab']['default_projects_limit'] = 10
default['gitlab']['default_can_create_group'] = true
default['gitlab']['username_changing_enabled'] = false
default['gitlab']['default_theme'] = 2
default['gitlab']['signup_enabled'] = false
default['gitlab']['signin_enabled'] = true
default['gitlab']['default_projects_features']['issues'] = true
default['gitlab']['default_projects_features']['merge_requests'] = true
default['gitlab']['default_projects_features']['wiki'] = true
default['gitlab']['default_projects_features']['wall'] = false
default['gitlab']['default_projects_features']['snippets'] = false
default['gitlab']['default_projects_features']['visibility_level'] = 'private' # can be "private" | "internal" | "public"
default['gitlab']['default_projects_features']['user_filter'] = ''
default['gitlab']['jira_project_url'] = 'https://jira.bigpoint.net:8443/issues/?jql=project=:issues_tracker_id'
default['gitlab']['jira_issues_url'] = 'https://jira.bigpoint.net:8443/browse/:id'
default['gitlab']['jira_new_issue_url'] = 'https://jira.bigpoint.net:8443/secure/CreateIssue.jspa'
default['gitlab']['ldap_enabled'] = true
default['gitlab']['gravatar'] = true
# Rest of ldap went into an encrypted data_bag
