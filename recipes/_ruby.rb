# Encoding: UTF-8
# Cookbook Name::       gitlab
# Description::         Installs Ruby 2.0 and uses rbenv if nesassary
# Recipe::              _ruby
# Author::              Thorsten Winkler (<t.winkler@bigpoint.net>)

if node['gitlab']['ruby2']
  %w{ruby1.9.1 ruby1.9.1-dev}.each do |pkg|
    package pkg do
      action :remove
    end
  end
  %w{ruby2.0 ruby2.0-dev}.each do |pkg|
    package pkg do
      action :install
    end
  end
else
  %w{ruby ruby-dev}.each do |pkg|
    package pkg do
      action :install
    end
  end
end

%w{bundler ruby-rb-inotify}.each do |pkg|
  package pkg do
    action :install
  end
end
