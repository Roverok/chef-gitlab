require 'chefspec'

describe 'gitlab::_database' do
  let (:chef_run) {
    Chef::EncryptedDataBagItem.stub(:load).with('gitlab', 'db').and_return({ 'username' => 'testuser',
                                                                             'password' => 'testpw',
                                                                             'database' => 'mydb' })
    chef_run = ChefSpec::ChefRunner.new
    chef_run.node.automatic_attrs['platform_family'] = 'debian'
    chef_run.node.automatic_attrs['os'] = 'linux'
    chef_run.node.automatic_attrs['lsb'] = { 'codename' => 'squeeze' }
    chef_run.converge 'gitlab::_gitlab_pre_mysql'
    chef_run
  }

  it "database actions" do
    pending "don't know how to check mysql actions"
  end
end
