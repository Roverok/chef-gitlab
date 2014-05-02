name             'gitlab'
maintainer       'Bigpoint GmbH'
maintainer_email 't.winkler@bigpoint.net'
license          'All rights reserved'
description      'Provides a gitlab server and a nginx, which does the ssl encryption.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.1'
depends          'apt', '>= 2.3.10'
depends          'nginx', '>= 2.6.2'
depends          'build-essential', '>= 2.0.0'
depends          'mysql', '>= 5.2.2'
depends          'database', '>= 2.1.8'
depends          'bp-percona', '>= 0.0.6'
#depends          'ssmtp'
