require 'chefspec'

describe 'gitlab::_nginx' do
  let (:chef_run) {
    Chef::EncryptedDataBagItem.stub(:load).with('gitlab', 'nginx').and_return({ 'cert' => 'mycert',
                                                                                'certkey' => 'mycertkey',
                                                                                'ca' => 'myca' })
    chef_run = ChefSpec::ChefRunner.new
    chef_run.node.automatic_attrs['platform_family'] = 'debian'
    chef_run.node.automatic_attrs['os'] = 'linux'
    chef_run.node.automatic_attrs['lsb'] = { 'codename' => 'squeeze' }
    chef_run.node.set['gitlab'] = { 'ssl_public' => '/etc/ssl/certs/gitlab.pem',
                                    'ssl_private' => '/etc/ssl/private/gitlab.key',
                                    'ca_cert' => '/etc/ssl/certs/gitlab-ca-cert.crt' }
    chef_run.converge 'gitlab::_nginx_for_gitlab'
  }

  it 'should do something' do
    file = chef_run.file(chef_run.node['gitlab']['ssl_public'])
    expect(file).to be_owned_by('root', 'root')
    expect(file.mode).to eq("0644")
    expect(file.content).to eq("mycert")
    file = chef_run.file(chef_run.node['gitlab']['ssl_private'])
    expect(file).to be_owned_by('root', 'root')
    expect(file.mode).to eq("0644")
    expect(file.content).to eq("mycertkey")
    file = chef_run.file(chef_run.node['gitlab']['ca_cert'])
    expect(file).to be_owned_by('root', 'root')
    expect(file.mode).to eq("0644")
    expect(file.content).to eq("myca")
    expect(chef_run).to create_file_with_content "/etc/nginx/sites-available/gitlab", "listen 443 default_server ssl"
    expect(chef_run).to create_file_with_content "/etc/nginx/sites-available/gitlab80", "rewrite"
  end

  it "check activation of sites" do
    pending "Do not know how the enabling of a site can be checked"
  end
end
