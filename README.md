# Description

Install a server with gitlab on it and nginx as a ssl proxy.


# Requirements


## Cookbooks

*  default.rb

Installes the full server

*  _gitlab_prerequisites.rb

Installs everything needed for installing gitlab/-shell

*  _gitlab_shell.rb

Installs the gitlab']['shell

*  _gitlab.rb

Installs gitlab itself

*  _nginx.rb

Installs and configures the nginx as a ssl proxy for gitlab

* _logrotate.rb

Handles logrotate

## Platform
--------

The following platforms are supported and tested under test kitchen:

* Debian Wheezy and Jessie supported

Newer Debian family distributions are also assumed to work.


## Attributes

Node attributes for this cookbook are logically separated into
different files. Some attributes are set only via a specific recipe.

* `node['gitlab']['instance']` - Name of the instance
* `node['gitlab']['server_name']` - Name of the server
* `node['gitlab']['ssl_private']` - SSL private
* `node['gitlab']['ssl_public']` -  SSL public
* `node['gitlab']['ca']` -  SSL ca
* `node['gitlab']['gitlab_version']` - Version of gitlab to be installed
* `node['gitlab']['gitlab']['shell_version']` - Version of gitlab']['shell to be installed

The following attributes correspondence to the gitlab config files

LDAP credidentials

* `node['gitlab']['ldap_enabled']`
Rest moved into gitlab/ldap cookbook.

Gitlab Shell

* `node['gitlab']['shell']['version']` - Version to be installed
* `node['gitlab']['shell']['self_signed_cert']` - 
* `node['gitlab']['shell']['repos_path']`
* `node['gitlab']['shell']['auth_file']`
* `node['gitlab']['shell']['redis']['bin']`
* `node['gitlab']['shell']['redis']['host']`
* `node['gitlab']['shell']['redis']['port']`
* `node['gitlab']['shell']['redis']['socket']`
* `node['gitlab']['shell']['redis']['namespace']`
* `node['gitlab']['shell']['log_file']`
* `node['gitlab']['shell']['log_level']`
* `node['gitlab']['shell']['http_user']`
* `node['gitlab']['shell']['http_password']`
* `node['gitlab']['shell']['ca_file']`
* `node['gitlab']['shell']['ca_path']`
* `node['gitlab']['shell']['audit_usernames']`

Data bags
=============

* gitlab/mysql

root, debian and replication password by instance

* gitlab/db

username, password

* gitlab/nginx

cert, certkey, ca

* gitlab/ldap

host, base, port, uid, method, bind_dn, password


Usage
=====



## License & Authors
- Author:: Thorsten Winkler (<twinkler@bigpoint.net>)

```text
Copyright:: 2014 Bigpoint GmbH

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
