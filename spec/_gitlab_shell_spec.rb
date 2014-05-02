require 'chefspec'

describe 'gitlab::_gitlab_shell' do
  let (:chef_run) {
    chef_run = ChefSpec::ChefRunner.new
    chef_run.node.automatic_attrs['platform_family'] = 'debian'
    chef_run.node.automatic_attrs['os'] = 'linux'
    chef_run.node.automatic_attrs['lsb'] = { 'codename' => 'squeeze' }
    chef_run.node.set['test'] = true
    chef_run.node.set['gitlab'] = { 'git_user' => 'gituser',
                                    'git_group' => 'gitgroup',
                                    'git_home' => '/home/git' }
    chef_run.converge 'gitlab::_gitlab_shell'
    chef_run
  }
  it 'Check git checkout' do
    pending 'No idea to check if a git repository is checked out'
  end

  it 'config' do
    expect(chef_run).to create_file_with_content chef_run.node['gitlab']['git_home'] + "/gitlab-shell/config.yml", "user: #{chef_run.node['gitlab']['shell']['http_user']}"
  end

#  it 'install/patch gitlab_shell' do
#    expect(chef_run).to create_cookbook_file Chef::Config[:file_cache_path] + "/install.patch"
#    expect(chef_run).to execute_bash_script "patch_gitlab_shell"
#    expect(chef_run).to execute_bash_script "install_gitlab-shell"
#  end
end
