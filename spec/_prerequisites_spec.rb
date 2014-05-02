require 'chefspec'

describe 'gitlab::_prerequisites' do
  let (:chef_run) {
    chef_run = ChefSpec::ChefRunner.new
    chef_run.node.automatic_attrs['platform_family'] = 'debian'
    chef_run.node.automatic_attrs['os'] = 'linux'
    chef_run.node.automatic_attrs['lsb'] = { 'codename' => 'squeeze' }
    chef_run.node.set['rbenv'] = { 'install_pkgs' => [] }
    chef_run.node.set['nginx'] = { 'group' => 'ng-group' }
    chef_run.node.set['gitlab'] = { 'git_user' => 'gituser',
                                    'git_group' => 'gitgroup',
                                    'git_home' => '/home/git',
                                    'p_packages' => [ "build-essential", "zlib1g-dev", "libyaml-dev", "libssl-dev", "libgdbm-dev", "libreadline-dev", "libncurses5-dev", "libffi-dev", "curl", "git-core" ,"openssh-server", "redis-server", "checkinstall", "libxml2-dev", "libxslt-dev", "libcurl4-openssl-dev", "libicu-dev" ] }
    chef_run.converge 'gitlab::_gitlab_prerequisites'
    chef_run
  }

  it 'package' do
    expect(chef_run).to install_package "libmysqlclient-dev"
    chef_run.node['gitlab']['p_packages'].each do |pkg|
      expect(chef_run).to install_package pkg
    end
  end

  it "python link" do
    expect(chef_run).to create_link "/usr/bin/python2"
  end

  it "misc" do
    expect(chef_run).to create_group chef_run.node['gitlab']['git_group']
    expect(chef_run).to create_user chef_run.node['gitlab']['git_user']
    directory = chef_run.directory(chef_run.node.node['gitlab']['git_home'])
    expect(directory).to be_owned_by(chef_run.node['gitlab']['git_user'], chef_run.node['nginx']['group'])
    expect(directory.mode).to eq("0750")
  end
end
