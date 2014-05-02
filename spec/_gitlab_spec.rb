require 'chefspec'

describe 'gitlab::_gitlab' do
  let (:chef_run) {
    Chef::EncryptedDataBagItem.stub(:load).with('gitlab', 'db').and_return({ 'username' => 'testuser',
                                                                             'password' => 'testpw',
                                                                             'database' => 'mydb' })
    Chef::EncryptedDataBagItem.stub(:load).with('gitlab', 'ldap').and_return({ 'base' => 'DC=somedc,DC=local',
                                                                               'bind_dn' => 'somesystemuser',
                                                                               'host' => 'ldap.somedomain',
                                                                               'id' => 'ldap',
                                                                               'method' => 'ssl',
                                                                               'password' => 'tosecrettobeinhere',
                                                                               'port' => '',
                                                                               'uid' => '' })
    chef_run = ChefSpec::ChefRunner.new
    chef_run.node.automatic_attrs['platform_family'] = 'debian'
    chef_run.node.automatic_attrs['os'] = 'linux'
    chef_run.node.automatic_attrs['lsb'] = { 'codename' => 'squeeze' }
    chef_run.node.set['gitlab'] = { 'git_user' => 'gituser',
                                    'git_group' => 'gitgroup',
                                    'git_home' => '/home/git' }
    chef_run.converge 'gitlab::_gitlab'
    chef_run
  }

  it 'config files' do
    expect(chef_run).to create_file_with_content chef_run.node['gitlab']['git_home'] + "/gitlab/config/gitlab.yml", "GitLab application config file"
    expect(chef_run).to create_file_with_content chef_run.node['gitlab']['git_home'] + "/gitlab/config/unicorn.rb", "This configuration file documents many features of Unicorn"
    expect(chef_run).to create_file_with_content chef_run.node['gitlab']['git_home'] + "/gitlab/config/database.yml", "username: \"testuser\""
  end

  it 'directory structure' do
    expect(chef_run).to execute_bash_script "fix_permissions_gl"
    directory = chef_run.directory(chef_run.node['gitlab']['git_home'] + "/gitlab-satellites")
    expect(directory).to be_owned_by(chef_run.node['gitlab']['git_user'], chef_run.node['gitlab']['git_group'])
    expect(directory.mode).to eq("0755")
    [ "/gitlab/tmp/pids", "/gitlab/tmp/sockets", "/gitlab/public/uploads" ].each do |dir|
      directory = chef_run.directory(chef_run.node['gitlab']['git_home'] + dir)
      expect(directory).to be_owned_by(chef_run.node['gitlab']['git_user'], chef_run.node['gitlab']['git_group'])
      expect(directory.mode).to eq("0777")
    end
    [ chef_run.node['gitlab']['git_repositories'], chef_run.node['gitlab']['git_hooks'] ].each do |dir|
      directory = chef_run.directory(dir)
      expect(directory).to be_owned_by(chef_run.node['gitlab']['git_user'], chef_run.node['gitlab']['git_group'])
      expect(directory.mode).to eq("0775")
    end
  end

  it "scripts" do
    #expect(chef_run).to execute_bash_script "copy_default_puma"
    expect(chef_run).to execute_bash_script("configure_git_global").with(:user => chef_run.node['gitlab']['git_user'],
                                                                         :cwd => chef_run.node['gitlab']['git_home'] + "/gitlab",
                                                                         :environment => { 'HOME' => chef_run.node['gitlab']['git_home'] })
    expect(chef_run).to execute_bash_script("install_gems").with(:user => chef_run.node['gitlab']['git_user'],
                                                                 :cwd => chef_run.node['gitlab']['git_home'] + "/gitlab",
                                                                 :environment => { 'HOME' => chef_run.node['gitlab']['git_home'] })
    expect(chef_run).to execute_command("echo yes | bundle exec rake gitlab:setup RAILS_ENV=production && touch .gitlab-setup").with(
                                        :cwd => chef_run.node['gitlab']['git_home']+"/gitlab",
                                        :user => chef_run.node['gitlab']['git_user'],
                                        :environment => { 'HOME' => chef_run.node['gitlab']['git_home'] })
  end

  it "service" do
    expect(chef_run).to create_file_with_content "/etc/init.d/gitlab", "# App Version: 6.0"
    expect(chef_run).to start_service 'gitlab'
    expect(chef_run).to set_service_to_start_on_boot 'gitlab'
  end
end
